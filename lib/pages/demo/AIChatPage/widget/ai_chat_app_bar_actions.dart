import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/AIChatSettingPage.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/controller/ai_chat_controller.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';

/// AppBar 右侧操作：Mock/Remote 切换、设置、新会话
class AiChatAppBarActions extends StatelessWidget {
  const AiChatAppBarActions({
    super.key,
    required this.controller,
  });

  /// 与聊天页共享的同一 controller（设置页也会接收此实例）
  final AiChatController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final streaming = controller.isStreaming;
        final mock = controller.useMock;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: mock ? '当前 Mock，点击切 Remote' : '当前 Remote，点击切 Mock',
              onPressed: streaming ? null : () => controller.setUseMock(!mock),
              icon: Icon(mock ? Icons.science_outlined : Icons.cloud_outlined),
            ),
            IconButton(
              tooltip: '设置',
              // 构造器传入 controller，勿放 Get.arguments（会被路由观察者 json 缓存）
              onPressed: () => Get.to(
                () => AIChatSettingPage(controller: controller),
                routeName: AppRouter.aiChatSettingPage,
              ),
              icon: const Icon(Icons.settings_outlined),
            ),
            // 新会话：清空消息，后续发送不再携带历史上下文
            IconButton(
              tooltip: '新会话',
              onPressed: streaming ? null : _onNewSession,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        );
      },
    );
  }

  void _onNewSession() {
    if (controller.messages.isEmpty) {
      SnackUtil.show('已是新会话');
      return;
    }
    controller.newSession();
    SnackUtil.show('已开启新会话');
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AiChatController>('controller', controller));
  }
}
