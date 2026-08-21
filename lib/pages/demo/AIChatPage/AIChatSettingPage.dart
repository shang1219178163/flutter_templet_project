import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/pick/n_pick_one.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/controller/ai_chat_controller.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/enum/ai_provider.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/ai_chat_error.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/parser/api_client.dart';
import 'package:flutter_templet_project/util/snack_util.dart';

/// AI 设置：提供商 / API Key（只读）/ 模型列表。
///
/// 优先使用构造传入的共享 [AiChatController]（聊天页 Get.to 传入）。
class AIChatSettingPage extends StatefulWidget {
  const AIChatSettingPage({super.key, this.title, this.controller});

  final String? title;
  final AiChatController? controller;

  @override
  State<AIChatSettingPage> createState() => _AIChatSettingPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(DiagnosticsProperty<AiChatController?>('controller', controller));
  }
}

class _AIChatSettingPageState extends State<AIChatSettingPage> {
  /// 优先取聊天页传入的共享 controller；自建时由本页负责释放
  late final AiChatController _controller = widget.controller ?? AiChatController();
  late final bool _ownsController = widget.controller == null;

  final _client = ApiClient();

  bool _loadingModels = false;

  /// API Key 是否密文显示
  bool _obscureApiKey = true;

  @override
  void initState() {
    super.initState();
    // 仅自建 controller 时需要再读缓存；共享实例聊天页已加载过，避免并发 load 覆盖刚切换的 provider
    if (_ownsController) {
      _controller.loadConfigFromCache().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
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
          _buildProviderPicker(context),
          const SizedBox(height: 16),
          _buildApiKeySection(context),
          const SizedBox(height: 16),
          _buildModelSection(context),
        ],
      ),
    );
  }

  Widget _buildProviderPicker(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final scheme = Theme.of(context).colorScheme;
        return Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            title: Text(
              '模型提供商',
              style: TextStyle(fontWeight: FontWeight.bold, color: scheme.primary),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _controller.provider.label,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
            onTap: _controller.isStreaming
                ? () => SnackUtil.warn('生成中，请先停止再切换提供商')
                : _onPickProvider,
          ),
        );
      },
    );
  }

  Future<void> _onPickProvider() async {
    NPickOne.show<AiProvider>(
      context: context,
      items: AiProvider.values.toList(),
      initialItem: _controller.provider,
      onSelected: (p) async {
        await _controller.setProvider(p);
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
        // 切换后刷新展示，并自动拉取该 provider 的模型列表
        setState(() {});
        await _onFetchModels(showSuccessToast: false);
      },
    );
  }

  Widget _buildApiKeySection(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final provider = _controller.provider;
        final apiKey = _controller.apiKey;
        final displayKey = apiKey.isEmpty
            ? '未配置'
            : (_obscureApiKey ? '•' * min(apiKey.length, 24) : apiKey);

        return _SectionCard(
          title: 'API Key 配置',
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text('${provider.label} API Key'),
              subtitle: Text(displayKey),
              trailing: IconButton(
                tooltip: _obscureApiKey ? '显示 Key' : '隐藏 Key',
                onPressed: apiKey.isEmpty
                    ? null
                    : () => setState(() => _obscureApiKey = !_obscureApiKey),
                icon: Icon(
                  _obscureApiKey ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('请求地址'),
              subtitle: SelectableText(
                _controller.sseUrl,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Key / 地址由 .env 或 dart-define 注入，不可在此修改',
                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModelSection(BuildContext context) {
    return _SectionCard(
      title: '模型列表',
      trailing: IconButton(
        tooltip: '刷新模型列表',
        onPressed: _loadingModels ? null : () => _onFetchModels(),
        icon: _loadingModels
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh),
      ),
      children: [
        ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final models = _controller.models;
            final current = _controller.model;
            if (models.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '暂无模型，点击右上角刷新获取',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              );
            }
            return Column(
              children: [
                for (var i = 0; i < models.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    minVerticalPadding: 0,
                    contentPadding: EdgeInsets.zero,
                    title: Text(models[i], style: const TextStyle(fontSize: 14)),
                    trailing: current == models[i]
                        ? Icon(
                            Icons.check,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () => _controller.setModel(models[i]),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _onFetchModels({bool showSuccessToast = true}) async {
    // 捕获发起时的 provider，避免 await 期间切换导致写错配置
    final forProvider = _controller.provider;
    final apiKey = _controller.apiKey.trim();
    final modelsUrl = _controller.modelsUrl;
    setState(() => _loadingModels = true);
    try {
      final models = await _client.fetchModels(
        apiKey: apiKey,
        modelsUrl: modelsUrl,
      );
      if (!mounted) {
        return;
      }
      await _controller.setModelsFor(forProvider, models);
      if (showSuccessToast) {
        SnackUtil.show('获取到 ${models.length} 个模型');
      }
    } catch (e) {
      final msg = e is FormatException
          ? (e.message.isNotEmpty ? e.message : '模型列表响应格式错误')
          : AiChatError.format(e);
      SnackUtil.error(msg);
    } finally {
      if (mounted) {
        setState(() => _loadingModels = false);
      }
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final Widget? trailing;
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: scheme.primary),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}
