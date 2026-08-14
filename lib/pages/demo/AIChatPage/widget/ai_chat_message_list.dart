import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/controller/ai_chat_controller.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/widget/ai_chat_message_bubble.dart';

/// 消息列表；空列表时展示引导文案
class AiChatMessageList extends StatelessWidget {
  const AiChatMessageList({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.onResend,
  });

  final AiChatController controller;

  /// 由页面持有，便于流式时自动滚底
  final ScrollController scrollController;
  final ValueChanged<String> onResend;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final list = controller.messages;
        if (list.isEmpty) {
          return Center(
            child: Text(
              '输入消息开始体验流式回复\n点右上角设置配置 API Key / 模型',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                height: 1.5,
              ),
            ),
          );
        }
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return AiChatMessageBubble(
              message: list[index],
              onResend: onResend,
            );
          },
        );
      },
    );
  }
}
