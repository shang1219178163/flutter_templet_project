import 'dart:async';
import 'dart:collection';
import 'dart:math' show min;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/mixin/safe_change_notifier_mixin.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_chat_models.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_env_service.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_provider.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_provider_config.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_chat_stream_source.dart';

/// AI 对话状态：消息列表、流式标记、打字缓冲。
///
/// 数据流：Source 产出 [AiStreamEvent] → 入队打字缓冲 → 定时器吐到气泡 → UI Listenable 刷新。
class AiChatController extends ChangeNotifier with SafeChangeNotifierMixin {
  AiChatController({SwitchingAiChatStreamSource? source})
      : _source = source ?? SwitchingAiChatStreamSource() {
    // 异步读缓存，构造完成后可能再刷一次 UI
    loadConfigFromCache();
  }

  final SwitchingAiChatStreamSource _source;

  /// 各 provider 独立配置（策略注册表）
  final Map<AiProvider, AiProviderConfig> _configs = {
    for (final p in AiProvider.values) p: AiProviderConfig(p),
  };

  /// 当前选中的 provider
  AiProvider _currentProvider = AiProvider.deepseek;

  AiProvider get provider => _currentProvider;

  AiProviderConfig get currentConfig => _configs[_currentProvider]!;

  AiProviderConfig configOf(AiProvider p) => _configs[p]!;

  final List<AiChatMessage> _messages = [];

  /// 对外只读消息列表
  List<AiChatMessage> get messages => List.unmodifiable(_messages);

  bool _isStreaming = false;

  /// 是否正在生成（发送中 / 打字中）
  bool get isStreaming => _isStreaming;

  String? _errorMessage;

  /// 最近一次错误；非 null 时顶部 Banner 展示
  String? get errorMessage => _errorMessage;

  bool get useMock => _source.useMock;

  String get sseUrl => currentConfig.baseUrl;

  String get apiKey => currentConfig.apiKey;

  String get model => currentConfig.model;

  /// 由当前 completions URL 推导的 models 地址
  String get modelsUrl => currentConfig.modelsUrl;

  /// 当前 provider 拉取并缓存的模型 id 列表
  List<String> get models => currentConfig.models;

  set models(List<String> value) {
    currentConfig.models = List.of(value);
    _persistConfig();
    // 列表刷新后若当前 model 不属于该 provider，立刻改回合法值并同步 remote
    _ensureModelInList();
    _syncActiveRemote();
    notifyListeners();
  }

  /// 下拉可选模型（无缓存时至少包含当前模型）
  List<String> get selectableModels {
    final current = model.isEmpty ? provider.defaultModel : model;
    if (models.isEmpty) {
      return [current];
    }
    return models.contains(current) ? List.of(models) : [current, ...models];
  }

  /// 取消当前 HTTP / Mock 流
  CancelToken? _cancelToken;

  StreamSubscription<AiStreamEvent>? _subscription;

  /// 待打字字符队列（按 rune 入队，避免拆开 emoji）
  final Queue<String> _typeQueue = Queue<String>();

  Timer? _typeTimer;

  /// 当前正在流式写入的助手消息 id
  String? _streamingAssistantId;

  /// 会话代际：stop / fail / dispose / 新 send 时递增，作废未完成的收尾 Future
  int _session = 0;

  /// 是否已进入「等打字队列排空再 finish」阶段，避免 done 与 onDone 重复触发
  bool _ending = false;

  int _idSeq = 0;

  /// 切换 Mock / Remote（流式中勿调）
  void setUseMock(bool value) => _setField(() => _source.useMock = value, _source.useMock == value);

  void setSseUrl(String url) {
    if (currentConfig.baseUrl == url) {
      return;
    }
    currentConfig.baseUrl = url;
    _syncActiveRemote();
    _persistConfig();
    notifyListeners();
  }

  void setApiKey(String key) {
    if (currentConfig.apiKey == key) {
      return;
    }
    currentConfig.apiKey = key;
    _syncActiveRemote();
    _persistConfig();
    notifyListeners();
  }

  /// 更新模型并写入当前 provider 缓存；下次 Remote 发送即生效
  void setModel(String value) {
    if (currentConfig.model == value) {
      return;
    }
    currentConfig.model = value;
    _syncActiveRemote();
    _persistConfig();
    notifyListeners();
  }

  /// 配置加载代际：丢弃过期的 [loadConfigFromCache]，避免覆盖用户刚切的 provider
  int _configLoadEpoch = 0;

  /// 切换 provider：先落盘当前，再载入目标（流式中拒绝）
  Future<void> setProvider(AiProvider p) async {
    if (p == _currentProvider || !mounted) {
      return;
    }
    if (_isStreaming) {
      return;
    }
    // 作废进行中的缓存加载，防止异步回调把 provider 改回去
    _configLoadEpoch++;
    await _writeConfigToCache(_currentProvider);
    _currentProvider = p;
    await CacheService().setString(CacheKey.aiProvider.name, p.name);
    // 目标可能尚未写入过缓存：再读一次以合并 .env 兜底
    await _loadProviderConfigFromCache(p);
    _ensureModelInList();
    _syncActiveRemote();
    // 切换后端后清空会话，避免带着 Kimi 历史让 DeepSeek「接着扮 Kimi」
    _messages.clear();
    _errorMessage = null;
    notifyListeners();
  }

  void _setField(VoidCallback apply, bool unchanged) {
    if (unchanged) {
      return;
    }
    apply();
    notifyListeners();
  }

  /// 激活的 remote 与当前 config 对齐
  void _syncActiveRemote() {
    final c = currentConfig;
    _source.remote
      ..url = c.baseUrl
      ..apiKey = c.apiKey
      ..model = c.model;
  }

  /// 当前 model 不在列表中时，回退到默认或列表首项
  void _ensureModelInList() {
    final c = currentConfig;
    if (c.model.isEmpty) {
      c.model = provider.defaultModel;
      return;
    }
    if (c.models.isEmpty) {
      return;
    }
    if (c.models.contains(c.model)) {
      return;
    }
    c.model = c.models.contains(provider.defaultModel)
        ? provider.defaultModel
        : c.models.first;
    _persistConfig();
  }

  FutureOr<void> _persistConfig([AiProvider? p]) {
    final target = p ?? provider;
    return CacheService().setMap(
      aiConfigCacheKey(target).name,
      _configs[target]!.toJson(),
    );
  }

  Future<void> _writeConfigToCache(AiProvider p) async {
    final cache = CacheService();
    await cache.init();
    await _persistConfig(p);
  }

  Future<void> _loadProviderConfigFromCache(AiProvider p) async {
    final cache = CacheService();
    await cache.init();
    final c = _configs[p]!;
    final map = cache.getMap(aiConfigCacheKey(p).name);
    if (map != null && map.isNotEmpty) {
      c.applyJson(map);
    }
    // 空串视为未配置，继续走 .env / 默认值，避免被空缓存挡住
    if (c.apiKey.isEmpty) {
      c.apiKey = AiEnvService.keyFor(p.name) ??
          (p == AiProvider.deepseek ? kAiDefaultApiKey : '');
    }
    if (c.baseUrl.isEmpty) {
      c.baseUrl = p.defaultBaseUrl;
    }
    // 旧版 Kimi 缓存指向国际区域名 api.moonshot.ai（会 401），迁移到中国区默认
    if (p == AiProvider.kimi && c.baseUrl.contains('api.moonshot.ai')) {
      c.baseUrl = p.defaultBaseUrl;
      await _persistConfig(p);
    }
    if (c.model.isEmpty) {
      c.model = p.defaultModel;
    }
    // 旧默认模型 moonshot-v1-8k 已不存在，回退到当前默认
    if (p == AiProvider.kimi && c.model == 'moonshot-v1-8k') {
      c.model = p.defaultModel;
      await _persistConfig(p);
    }
    if (_currentProvider == p) {
      _syncActiveRemote();
    }
  }

  /// 从本地缓存恢复当前 provider 及各项配置
  Future<void> loadConfigFromCache() async {
    final epoch = ++_configLoadEpoch;
    final cache = CacheService();
    await cache.init();
    if (!mounted || epoch != _configLoadEpoch) {
      return;
    }
    final name = cache.getString(CacheKey.aiProvider.name);
    if (name != null && name.isNotEmpty) {
      final p = AiProvider.values.asNameMap()[name];
      if (p != null) {
        _currentProvider = p;
      }
    }
    // 预加载全部 provider，切换时内存里已有各自 Key / URL
    for (final p in AiProvider.values) {
      if (!mounted || epoch != _configLoadEpoch) {
        return;
      }
      await _loadProviderConfigFromCache(p);
    }
    if (!mounted || epoch != _configLoadEpoch) {
      return;
    }
    _ensureModelInList();
    _syncActiveRemote();
    notifyListeners();
  }

  /// 发送用户消息并开始流式回复（流式中再次调用会被忽略）
  Future<void> send(String text) async {
    final prompt = text.trim();
    if (prompt.isEmpty || _isStreaming || !mounted) {
      return;
    }

    // 发送前强制对齐 remote，避免切换 provider 后仍打到旧 URL / model
    _ensureModelInList();
    _syncActiveRemote();

    _session++;
    _ending = false;
    _errorMessage = null;
    _messages
      ..add(AiChatMessage(id: _nextId(), role: AiChatRole.user, content: prompt))
      ..add(AiChatMessage(
        id: _nextId(),
        role: AiChatRole.assistant,
        content: '',
        isStreaming: true,
      ));
    _streamingAssistantId = _messages.last.id;
    _isStreaming = true;
    _typeQueue.clear();
    notifyListeners();

    final apiMessages = _buildApiMessages();
    _cancelToken = CancelToken();
    _startTypewriter();
    await _subscription?.cancel();
    if (!mounted) {
      return;
    }
    _subscription = _source.start(messages: apiMessages, cancelToken: _cancelToken).listen(
      _onStreamEvent,
      onError: (Object e) => _fail(e.toString()),
      onDone: _requestEnd,
      cancelOnError: true,
    );
  }

  /// 组装发给 API 的多轮 messages（排除当前正在流式的空助手气泡）
  List<Map<String, String>> _buildApiMessages() {
    final streamingId = _streamingAssistantId;
    return _messages
        .where((m) => m.id != streamingId)
        .where((m) => m.content.isNotEmpty || m.role == AiChatRole.user)
        .map((m) => {
              'role': switch (m.role) {
                AiChatRole.user => 'user',
                AiChatRole.assistant => 'assistant',
                AiChatRole.system => 'system',
              },
              'content': m.content,
            })
        .toList();
  }

  /// 用户手动停止：取消请求、冲刷缓冲、标记结束
  void stop() {
    _session++;
    _cancelToken?.cancel('user_stop');
    _subscription?.cancel();
    _subscription = null;
    _flushTypewriter();
    _finishAssistant(emptyHint: '（已停止）');
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }
    _errorMessage = null;
    notifyListeners();
  }

  /// 清空会话；若正在流式则先 stop
  void clearMessages() {
    if (_isStreaming) {
      stop();
    }
    _messages.clear();
    notifyListeners();
  }

  void _onStreamEvent(AiStreamEvent event) {
    if (!mounted) {
      return;
    }
    switch (event.kind) {
      case AiStreamEventKind.delta:
        final delta = event.delta ?? '';
        if (delta.isEmpty) {
          return;
        }
        // 按 Unicode 码点入队，再由定时器逐批吐出
        for (final r in delta.runes) {
          _typeQueue.add(String.fromCharCode(r));
        }
      case AiStreamEventKind.error:
        _fail(event.message ?? '未知错误');
      case AiStreamEventKind.done:
        _requestEnd();
    }
  }

  /// 流结束：等打字队列排空后再收尾（避免最后几字被截断）
  void _requestEnd() {
    if (!_isStreaming || _ending || !mounted) {
      return;
    }
    _ending = true;
    final session = _session;
    Future<void>(() async {
      while (_typeQueue.isNotEmpty && session == _session && mounted) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      if (session == _session && _isStreaming && mounted) {
        _finishAssistant();
      }
    });
  }

  /// 启动打字机：约每 18ms 吐最多 3 个字符
  void _startTypewriter() {
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 18), (_) {
      if (!mounted || _typeQueue.isEmpty || _streamingAssistantId == null) {
        return;
      }
      final take = min(3, _typeQueue.length);
      final buf = StringBuffer();
      for (var i = 0; i < take; i++) {
        buf.write(_typeQueue.removeFirst());
      }
      _appendAssistant(_streamingAssistantId!, buf.toString());
    });
  }

  /// 立刻写出剩余缓冲（stop / fail 时用）
  void _flushTypewriter() {
    if (_typeQueue.isEmpty || _streamingAssistantId == null) {
      _typeQueue.clear();
      return;
    }
    final buf = StringBuffer()..writeAll(_typeQueue);
    _typeQueue.clear();
    _appendAssistant(_streamingAssistantId!, buf.toString());
  }

  void _appendAssistant(String id, String text) {
    if (!mounted) {
      return;
    }
    final i = _messages.indexWhere((m) => m.id == id);
    if (i < 0) {
      return;
    }
    _messages[i].content += text;
    notifyListeners();
  }

  /// 流错误：取消 HTTP、展示 Banner 并结束当前助手气泡
  void _fail(String message) {
    _session++;
    _cancelToken?.cancel('fail');
    _subscription?.cancel();
    _subscription = null;
    _flushTypewriter();
    _errorMessage = message;
    _finishAssistant(emptyHint: '（出错）');
  }

  /// 结束当前助手消息：停定时器、清流式标记
  void _finishAssistant({String? emptyHint}) {
    if (!_isStreaming) {
      return;
    }
    _typeTimer?.cancel();
    _typeTimer = null;
    final id = _streamingAssistantId;
    if (id != null) {
      final i = _messages.indexWhere((m) => m.id == id);
      if (i >= 0) {
        final msg = _messages[i];
        msg.isStreaming = false;
        if (msg.content.isEmpty && emptyHint != null) {
          msg.content = emptyHint;
        }
      }
    }
    _streamingAssistantId = null;
    _isStreaming = false;
    _ending = false;
    _cancelToken = null;
    notifyListeners();
  }

  String _nextId() => 'm_${++_idSeq}';

  @override
  void dispose() {
    _session++;
    _typeTimer?.cancel();
    _typeTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _cancelToken?.cancel('dispose');
    _cancelToken = null;
    // SafeChangeNotifierMixin 会将 mounted 置 false，再 dispose ChangeNotifier
    super.dispose();
  }
}
