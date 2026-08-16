import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' show min;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/mixin/safe_change_notifier_mixin.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/enum/ai_provider.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/enum/ai_reply_phase.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_chat_models.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_chat_error.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_chat_stream_source.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_provider_config.dart';

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

  /// 配置加载代际：丢弃过期的 [loadConfigFromCache]，避免覆盖用户刚切的 provider
  int _configLoadEpoch = 0;

  final List<AiChatMessage> _messages = [];

  /// 历史会话列表（含当前活动会话快照，按 updatedAt 倒序）
  final List<AiChatSession> _sessions = [];

  /// 当前活动会话 id；null 表示尚未落库的空白会话
  String? _activeSessionId;

  /// 回复相位：idle → streaming → draining → idle
  AiReplyPhase _phase = AiReplyPhase.idle;

  String? _errorMessage;

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

  int _idSeq = 0;

  AiProvider get provider => _currentProvider;

  AiProviderConfig get currentConfig => _configs[_currentProvider]!;

  /// 对外只读消息列表
  List<AiChatMessage> get messages => List.unmodifiable(_messages);

  /// 历史会话（只读，已按时间倒序）
  List<AiChatSession> get sessions => List.unmodifiable(_sessions);

  /// 当前活动会话 id
  String? get activeSessionId => _activeSessionId;

  /// 是否正在生成（收流 / 打字 / 排空缓冲）
  bool get isStreaming => _phase != AiReplyPhase.idle;

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

  /// 写入指定 provider 的模型列表（避免异步拉取完成时写到已切换的当前 provider）
  Future<void> setModelsFor(AiProvider p, List<String> value) async {
    final c = _configs[p]!;
    c.models = List.of(value);
    if (p == _currentProvider) {
      _ensureModelInList();
      await _commitConfig(p);
      return;
    }
    await _persistConfig(p);
  }

  /// 下拉可选模型（无缓存时至少包含当前模型）
  List<String> get selectableModels {
    final current = model.isEmpty ? provider.defaultModel : model;
    if (models.isEmpty) {
      return [current];
    }
    if (models.contains(current)) {
      return List.of(models);
    }
    return [current, ...models];
  }

  /// 切换 Mock / Remote（流式中拒绝）
  void setUseMock(bool value) {
    if (_source.useMock == value || isStreaming) {
      return;
    }
    _source.useMock = value;
    notifyListeners();
  }

  /// 更新模型并写入当前 provider 缓存；下次 Remote 发送即生效
  Future<void> setModel(String value) async {
    if (currentConfig.model == value) {
      return;
    }
    currentConfig.model = value;
    await _commitConfig();
  }

  /// 切换 provider：落盘当前 → 载入目标 → 清空会话（流式中拒绝）
  Future<void> setProvider(AiProvider p) async {
    if (p == _currentProvider || !mounted || isStreaming) {
      return;
    }
    // 作废进行中的缓存加载，防止异步回调把 provider 改回去
    _configLoadEpoch++;
    await _persistConfig(_currentProvider);
    _currentProvider = p;
    await CacheService().setString(CacheKey.aiProvider.name, p.name);
    // 目标可能尚未写入过缓存：再读一次以合并 .env 兜底
    await _loadProviderConfig(p);
    _ensureModelInList();
    await _commitConfig(p);
    // 切换后端后开启新会话，避免跨模型带着旧上下文
    await newSession();
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
    if (c.models.isEmpty || c.models.contains(c.model)) {
      return;
    }
    c.model = c.models.contains(provider.defaultModel)
        ? provider.defaultModel
        : c.models.first;
  }

  /// 同步 remote + 落盘 + 通知 UI
  Future<void> _commitConfig([AiProvider? p]) async {
    final target = p ?? provider;
    if (target == _currentProvider) {
      _syncActiveRemote();
    }
    await _persistConfig(target);
    notifyListeners();
  }

  Future<CacheService> _readyCache() async {
    final cache = CacheService();
    await cache.init();
    return cache;
  }

  /// 配置加载是否已被新一轮 load / setProvider 作废
  bool _isConfigStale(int epoch) => !mounted || epoch != _configLoadEpoch;

  Future<void> _persistConfig([AiProvider? p]) async {
    final target = p ?? provider;
    final cache = await _readyCache();
    await cache.setMap(aiConfigCacheKey(target).name, _configs[target]!.toJson());
  }

  Future<void> _loadProviderConfig(AiProvider p) async {
    final cache = await _readyCache();
    final c = _configs[p]!;
    final map = cache.getMap(aiConfigCacheKey(p).name);
    if (map != null && map.isNotEmpty) {
      c.applyJson(map);
    }
    c.resolveApiKey();
    if (c.normalize()) {
      await _persistConfig(p);
    }
    if (_currentProvider == p) {
      _syncActiveRemote();
    }
  }

  /// 从本地缓存恢复当前 provider 及各项配置
  Future<void> loadConfigFromCache() async {
    final epoch = ++_configLoadEpoch;
    final cache = await _readyCache();
    if (_isConfigStale(epoch)) {
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
      if (_isConfigStale(epoch)) {
        return;
      }
      await _loadProviderConfig(p);
    }
    if (_isConfigStale(epoch)) {
      return;
    }

    _ensureModelInList();
    _syncActiveRemote();
    await _loadSessions();
    if (_isConfigStale(epoch)) {
      return;
    }
    notifyListeners();
  }

  Future<void> _loadSessions() async {
    final cache = await _readyCache();
    final raw = cache.getString(CacheKey.aiChatSessions.name);
    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return;
      }
      _sessions
        ..clear()
        ..addAll(
          decoded
              .whereType<Map>()
              .map((e) => AiChatSession.fromJson(Map<String, dynamic>.from(e))),
        );
      _sortSessions();
    } catch (e) {
      debugPrint('loadSessions failed: $e');
    }
  }

  Future<void> _persistSessions() async {
    final cache = await _readyCache();
    await cache.setString(
      CacheKey.aiChatSessions.name,
      jsonEncode(_sessions.map((e) => e.toJson()).toList()),
    );
  }

  void _sortSessions() {
    _sessions.sort((a, b) => b.updatedAtMs.compareTo(a.updatedAtMs));
  }

  /// 从当前消息生成可归档快照（去掉空的流式气泡）
  List<AiChatMessage> _snapshotMessages() {
    return _messages
        .where((m) => !m.isStreaming || m.content.isNotEmpty)
        .map((m) => AiChatMessage(id: m.id, role: m.role, content: m.content))
        .where((m) => m.content.isNotEmpty || m.role == AiChatRole.user)
        .toList();
  }

  String _titleFromMessages(List<AiChatMessage> msgs) {
    for (final m in msgs) {
      if (m.role == AiChatRole.user && m.content.trim().isNotEmpty) {
        final t = m.content.trim();
        return t.length > 28 ? '${t.substring(0, 28)}…' : t;
      }
    }
    return '新会话';
  }

  /// 将当前有内容的会话写入历史列表（新建或更新）
  Future<void> _upsertActiveSession() async {
    final snapshot = _snapshotMessages();
    if (snapshot.isEmpty) {
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final id = _activeSessionId ?? 's_${now}_$_idSeq';
    _activeSessionId = id;
    final session = AiChatSession(
      id: id,
      title: _titleFromMessages(snapshot),
      messages: snapshot,
      updatedAtMs: now,
    );
    final i = _sessions.indexWhere((e) => e.id == id);
    if (i >= 0) {
      _sessions[i] = session;
    } else {
      _sessions.insert(0, session);
    }
    _sortSessions();
    await _persistSessions();
  }

  /// 开启新会话：归档当前上下文后清空，后续发送不再携带历史
  Future<void> newSession() async {
    if (isStreaming) {
      stop();
    }
    await _upsertActiveSession();
    _activeSessionId = null;
    _messages.clear();
    _errorMessage = null;
    notifyListeners();
  }

  /// 打开历史会话：先归档当前，再载入目标（不携带其它会话上下文）
  Future<void> openSession(String id) async {
    if (isStreaming) {
      stop();
    }
    if (id == _activeSessionId && _messages.isNotEmpty) {
      return;
    }

    await _upsertActiveSession();
    final i = _sessions.indexWhere((e) => e.id == id);
    if (i < 0) {
      return;
    }

    final target = _sessions[i];
    _activeSessionId = target.id;
    _messages
      ..clear()
      ..addAll(
        target.messages.map(
          (m) => AiChatMessage(id: m.id, role: m.role, content: m.content),
        ),
      );
    _errorMessage = null;
    notifyListeners();
  }

  /// 删除历史会话；若删的是当前会话则清空消息
  Future<void> deleteSession(String id) async {
    _sessions.removeWhere((e) => e.id == id);
    if (_activeSessionId == id) {
      _activeSessionId = null;
      if (isStreaming) {
        stop();
      }
      _messages.clear();
      _errorMessage = null;
    }
    await _persistSessions();
    notifyListeners();
  }

  /// 打开历史抽屉前调用：把当前对话同步进列表
  Future<void> syncActiveSessionToHistory() => _upsertActiveSession();

  /// 发送用户消息并开始流式回复（流式中再次调用会被忽略）
  Future<void> send(String text) async {
    final prompt = text.trim();
    if (prompt.isEmpty || isStreaming || !mounted) {
      return;
    }

    // 发送前强制对齐 remote，避免切换 provider 后仍打到旧 URL / model
    _ensureModelInList();
    _syncActiveRemote();

    if (!_source.useMock && currentConfig.apiKey.trim().isEmpty) {
      _errorMessage = '未配置 API Key，请在 .env 中填写或改用 Mock';
      notifyListeners();
      return;
    }

    _session++;
    _phase = AiReplyPhase.streaming;
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
    _typeQueue.clear();
    notifyListeners();

    final apiMessages = _buildApiMessages();
    _cancelToken = CancelToken();
    _startTypewriter();
    await _subscription?.cancel();
    if (!mounted) {
      // dispose 发生在 cancel 之后：收尾助手气泡，避免卡在 streaming
      _finishAssistant(emptyHint: '（已取消）');
      return;
    }
    _subscription = _source.start(messages: apiMessages, cancelToken: _cancelToken).listen(
      _onStreamEvent,
      onError: (Object e) {
        if (AiChatError.isCancel(e)) {
          return;
        }
        _fail(AiChatError.format(e));
      },
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
        .map((m) => {'role': m.role.name, 'content': m.content})
        .toList();
  }

  /// 取消 HTTP / 订阅并冲刷打字缓冲（不改变 phase；由调用方收尾）
  void _abortActiveStream(String cancelReason) {
    _session++;
    _cancelToken?.cancel(cancelReason);
    _subscription?.cancel();
    _subscription = null;
    _flushTypewriter();
  }

  /// 用户手动停止：取消请求、冲刷缓冲、标记结束
  void stop() {
    _abortActiveStream('user_stop');
    _finishAssistant(emptyHint: '（已停止）');
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }
    _errorMessage = null;
    notifyListeners();
  }

  /// 清空当前消息；若正在流式则先 stop（不归档，归档请用 [newSession]）
  void clearMessages() {
    if (isStreaming) {
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
        _typeQueue.addAll(delta.runes.map(String.fromCharCode));
      case AiStreamEventKind.error:
        _fail(event.message ?? '未知错误');
      case AiStreamEventKind.done:
        _requestEnd();
    }
  }

  /// 流结束：等打字队列排空后再收尾（避免最后几字被截断）
  void _requestEnd() {
    // 仅 streaming→draining；已在 draining / idle 则忽略（防 done 与 onDone 重复）
    if (_phase != AiReplyPhase.streaming || !mounted) {
      return;
    }
    _phase = AiReplyPhase.draining;
    final session = _session;
    Future<void>(() async {
      while (_typeQueue.isNotEmpty && session == _session && mounted) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      if (session == _session && _phase != AiReplyPhase.idle && mounted) {
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
    _abortActiveStream('fail');
    _errorMessage = message;
    // 链接中断时用更明确的空气泡提示；已有部分正文则保留
    final emptyHint =
        AiChatError.isConnectionIssue(message) ? '（链接中断）' : '（出错）';
    _finishAssistant(emptyHint: emptyHint);
  }

  /// 结束当前助手消息：停定时器、清流式标记
  void _finishAssistant({String? emptyHint}) {
    if (_phase == AiReplyPhase.idle) {
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
    _phase = AiReplyPhase.idle;
    _cancelToken = null;
    notifyListeners();
    // 流结束后把当前会话写入历史，便于侧栏展示
    unawaited(_upsertActiveSession());
  }

  String _nextId() => 'm_${++_idSeq}';

  @override
  void dispose() {
    _session++;
    _subscription?.cancel();
    _subscription = null;
    _cancelToken?.cancel('dispose');
    _cancelToken = null;
    if (_phase != AiReplyPhase.idle) {
      _flushTypewriter();
      _finishAssistant(emptyHint: '（已取消）');
    } else {
      _typeTimer?.cancel();
      _typeTimer = null;
    }
    // SafeChangeNotifierMixin 会将 mounted 置 false，再 dispose ChangeNotifier
    super.dispose();
  }
}
