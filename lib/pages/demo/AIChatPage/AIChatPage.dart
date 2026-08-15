import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_dialog.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/controller/ai_chat_controller.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/widget/ai_chat_app_bar_actions.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/widget/ai_chat_error_banner.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/widget/ai_chat_history_drawer.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/widget/ai_chat_input_bar.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/widget/ai_chat_message_list.dart';

/// AI 流式对话 Demo 页：SSE / ChangeNotifier / 打字效果。
///
/// 职责仅做 UI 编排；业务状态见 [AiChatController]。
class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key, this.title});

  final String? title;

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  late final AiChatController _controller = AiChatController();
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  /// 合并同一帧内多次 notify，避免反复 jumpTo 导致抖动
  bool _scrollScheduled = false;

  /// 仅当用户停留在底部附近时跟随滚动（上滑阅读时不强制吸底）
  bool _stickToBottom = true;

  static const double _stickThreshold = 80;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _scrollController.addListener(_onUserScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _scrollController.removeListener(_onUserScroll);
    _controller.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onUserScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final pos = _scrollController.position;
    _stickToBottom = pos.maxScrollExtent - pos.pixels <= _stickThreshold;
  }

  /// 内容变化时，若仍贴底则滚到底（每帧最多一次）
  void _onControllerChanged() {
    if (_scrollScheduled) {
      return;
    }
    _scrollScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollScheduled = false;
      if (!mounted || !_scrollController.hasClients || !_stickToBottom) {
        return;
      }
      final pos = _scrollController.position;
      if ((pos.pixels - pos.maxScrollExtent).abs() >= 2) {
        _scrollController.jumpTo(pos.maxScrollExtent);
      }
    });
  }

  /// 流式中点发送键 = 停止；否则发送
  Future<void> _onSendOrStop() async {
    if (_controller.isStreaming) {
      _controller.stop();
      return;
    }
    // 新消息默认重新跟随底部
    _stickToBottom = true;
    final text = _inputController.text;
    _inputController.clear();
    await _controller.send(text);
  }

  /// 用户气泡「重发」：仅填入输入框，不自动发送
  void _onResend(String content) {
    _inputController.text = content;
    _inputController.selection = TextSelection.collapsed(offset: content.length);
    _focusNode.requestFocus();
  }

  /// 左侧 more_horiz：从左向右滑出历史会话抽屉
  Future<void> _openHistoryDrawer() async {
    await _controller.syncActiveSessionToHistory();
    if (!mounted) {
      return;
    }
    NOverlayDialog.drawer(
      context,
      from: Alignment.centerLeft,
      widthFactor: 0.82,
      child: AiChatHistoryDrawer(controller: _controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title ?? 'AIChat';
    return Scaffold(
      appBar: AppBar(
        // 用 more_horiz 替换系统返回，打开历史会话
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: '历史会话',
          style: IconButton.styleFrom(shape: const CircleBorder()),
          onPressed: _openHistoryDrawer,
          icon: const Icon(Icons.more_horiz),
        ),
        title: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Text('$title · ${_controller.provider.label}');
          },
        ),
        actions: [
          AiChatAppBarActions(controller: _controller),
        ],
      ),
      body: Column(
        children: [
          AiChatErrorBanner(controller: _controller),
          Expanded(
            child: AiChatMessageList(
              controller: _controller,
              scrollController: _scrollController,
              onResend: _onResend,
            ),
          ),
          SafeArea(
            top: false,
            child: AiChatInputBar(
              controller: _controller,
              inputController: _inputController,
              focusNode: _focusNode,
              onSendOrStop: _onSendOrStop,
            ),
          ),
        ],
      ),
    );
  }
}
