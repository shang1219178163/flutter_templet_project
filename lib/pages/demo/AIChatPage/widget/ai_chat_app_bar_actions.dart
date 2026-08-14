import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/controller/ai_chat_controller.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';

/// AppBar 右侧操作：Mock/Remote 切换、设置、清空会话
class AiChatAppBarActions extends StatelessWidget {
  const AiChatAppBarActions({
    super.key,
    required this.controller,
  });

  /// 与聊天页共享的同一 controller（设置页也会接收此实例）
  final AiChatController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final mock = controller.useMock;
            return IconButton(
              tooltip: mock ? '当前 Mock，点击切 Remote' : '当前 Remote，点击切 Mock',
              onPressed: controller.isStreaming ? null : () => controller.setUseMock(!mock),
              icon: Icon(mock ? Icons.science_outlined : Icons.cloud_outlined),
            );
          },
        ),
        IconButton(
          tooltip: '设置',
          onPressed: () => Get.toNamed(
            AppRouter.aiChatSettingPage,
            arguments: controller,
          ),
          icon: const Icon(Icons.settings_outlined),
        ),
        IconButton(
          tooltip: '清空',
          onPressed: controller.clearMessages,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}
