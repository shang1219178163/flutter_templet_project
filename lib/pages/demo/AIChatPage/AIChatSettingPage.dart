import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/pick/n_pick_one.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/controller/ai_chat_controller.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_chat_stream_source.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/deepseek_api_client.dart';
import 'package:get/get.dart';

/// AI 聊天设置页：API Key / 请求地址 / 连通性检查 / 模型列表与选择。
///
/// 从聊天页进入时通过 [Get.arguments] 共享 [AiChatController]，改动能立刻作用于对话。
class AIChatSettingPage extends StatefulWidget {
  const AIChatSettingPage({super.key, this.title});

  final String? title;

  @override
  State<AIChatSettingPage> createState() => _AIChatSettingPageState();
}

class _AIChatSettingPageState extends State<AIChatSettingPage> {
  /// 优先取聊天页传入的共享 controller；自建时由本页负责释放
  late final AiChatController _controller = (Get.arguments as AiChatController?) ?? AiChatController();
  late final bool _ownsController = Get.arguments == null;
  late final TextEditingController _apiKeyController = TextEditingController(text: _controller.apiKey);
  late final TextEditingController _urlController = TextEditingController(text: _controller.sseUrl);
  final _client = DeepseekApiClient();

  bool _checking = false;
  bool _checkOk = false;
  String? _checkResult;

  bool _loadingModels = false;

  /// API Key 是否密文显示
  bool _obscureApiKey = true;

  @override
  void initState() {
    super.initState();
    // 等异步缓存加载完成后再同步到输入框，避免打开时字段为空
    _syncFieldsAfterCache();
  }

  Future<void> _syncFieldsAfterCache() async {
    await _controller.loadConfigFromCache();
    if (!mounted) {
      return;
    }
    _apiKeyController.text = _controller.apiKey;
    _urlController.text = _controller.sseUrl;
    setState(() {});
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _urlController.dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? 'AI 设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildApiKeySection(context),
          const SizedBox(height: 16),
          _buildConnectionSection(context),
          const SizedBox(height: 16),
          _buildModelSection(context),
        ],
      ),
    );
  }

  Widget _buildApiKeySection(BuildContext context) {
    // Demo 明文存 SharedPreferences；hint 绝不展示真实 Key
    final keyHint = kAiDefaultApiKey.isEmpty
        ? '--dart-define=DEEPSEEK_API_KEY=sk-xxx'
        : '已通过 dart-define 注入（不在此显示）';

    return _SectionCard(
      title: 'API Key 配置',
      children: [
        TextField(
          controller: _apiKeyController,
          obscureText: _obscureApiKey,
          minLines: 1,
          // 隐藏 key 时 Flutter 要求 maxLines == 1，显示时才允许多行
          maxLines: _obscureApiKey ? 1 : 2,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'DeepSeek API Key',
            hintText: keyHint,
            helperText: 'Demo 本地明文缓存，正式环境请改用安全存储',
            border: const OutlineInputBorder(),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: _obscureApiKey ? '显示 Key' : '隐藏 Key',
                  onPressed: () {
                    setState(() {
                      _obscureApiKey = !_obscureApiKey;
                    });
                  },
                  icon: Icon(
                    _obscureApiKey ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  ),
                ),
                IconButton(
                  tooltip: '从剪切板粘贴',
                  onPressed: _pasteApiKey,
                  icon: const Icon(Icons.content_paste),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _urlController,
          minLines: 1,
          maxLines: 2,
          decoration: const InputDecoration(
            isDense: true,
            labelText: '请求地址',
            hintText: kAiDefaultBaseUrl,
            border: OutlineInputBorder(),
          ),
          onChanged: _controller.setSseUrl,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _onSave,
            child: const Text('保存'),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionSection(BuildContext context) {
    return _SectionCard(
      title: '检查请求链接',
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _checking ? null : _onCheckConnection,
            child: _checking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('检查请求链接'),
          ),
        ),
        if (_checkResult != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                _checkOk ? Icons.check_circle : Icons.error,
                color: _checkOk ? Colors.green : Colors.red,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _checkResult!,
                  style: TextStyle(
                    color: _checkOk ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildModelSection(BuildContext context) {
    return _SectionCard(
      title: '模型列表',
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _loadingModels ? null : _onFetchModels,
            child: _loadingModels
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('获取模型列表'),
          ),
        ),
        const SizedBox(height: 12),
        ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final models = _controller.models;
            return _buildItem(
              title: '当前模型',
              trailing: Text(
                _controller.model,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              onTap: models.isEmpty ? null : _onPickModel,
              subtitle: models.isEmpty ? '请先获取模型列表' : null,
            );
          },
        ),
      ],
    );
  }

  Future<void> _pasteApiKey() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? '';
    if (text.isEmpty) {
      if (!mounted) {
        return;
      }
      // iOS 模拟器剪贴板与 macOS 独立，Cmd+V 无法直接同步
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        _showSyncGuideDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('剪切板中没有文本')),
        );
      }
      return;
    }
    _apiKeyController.text = text;
  }

  void _showSyncGuideDialog() {
    const cmd = 'pbpaste | xcrun simctl pbcopy booted';
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('同步 macOS 剪贴板到模拟器'),
        content: const Text(
          'iOS 模拟器剪贴板与 macOS 相互独立，Cmd+V 无法直接同步。\n\n'
          '请在终端执行下面这条命令（它会把 macOS 剪贴板内容注入模拟器），'
          '再回到这里点“粘贴”按钮：',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: cmd));
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('复制命令'),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave() async {
    final key = _apiKeyController.text.trim();
    final cache = CacheService();
    await cache.init();
    await cache.setString(CacheKey.aiApiKey.name, key);
    await cache.setString(CacheKey.aiModelUrl.name, _urlController.text.trim());
    _controller.setApiKey(key);
    _controller.setSseUrl(_urlController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已保存')),
      );
    }
  }

  Future<void> _onCheckConnection() async {
    final key = _apiKeyController.text.trim();
    final url = _urlController.text.trim();
    // 与输入框保持一致，供检查后聊天页立即生效
    _controller.setApiKey(key);
    _controller.setSseUrl(url);
    setState(() {
      _checking = true;
      _checkResult = null;
    });
    final result = await _client.checkConnection(
      apiKey: key,
      chatCompletionsUrl: url,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _checking = false;
      _checkOk = result.ok;
      _checkResult = result.message;
    });
  }

  Future<void> _onFetchModels() async {
    setState(() {
      _loadingModels = true;
    });
    try {
      final url = _urlController.text.trim();
      _controller.setSseUrl(url);
      final models = await _client.fetchModels(
        apiKey: _apiKeyController.text.trim(),
        modelsUrl: resolveModelsUrl(url),
      );
      final cache = CacheService();
      await cache.init();
      await cache.setStringList(CacheKey.aiModelList.name, models);
      _controller.models = models;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('获取到 ${models.length} 个模型')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e is DioException ? _client.dioErrorText(e) : '获取失败：$e',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingModels = false;
        });
      }
    }
  }

  Future<void> _onPickModel() async {
    NPickOne.show<String>(
      context: context,
      items: _controller.models.toList(),
      initialItem: _controller.model,
      onSelected: (m) {
        _controller.setModel(m);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildItem({
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    String? subtitle,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: onTap == null
          ? trailing
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (trailing != null) trailing,
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
      onTap: onTap,
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  /// 区块标题
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
