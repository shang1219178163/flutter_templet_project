import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/controller/ai_chat_controller.dart';

/// 顶部错误提示条；[AiChatController.errorMessage] 为 null 时不占位
class AiChatErrorBanner extends StatelessWidget {
  const AiChatErrorBanner({
    super.key,
    required this.controller,
  });

  final AiChatController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final err = controller.errorMessage;
        if (err == null) {
          return const SizedBox.shrink();
        }
        return MaterialBanner(
          content: Text(err, maxLines: 3, overflow: TextOverflow.ellipsis),
          leading: const Icon(Icons.error_outline, color: Colors.red),
          actions: [
            TextButton(
              onPressed: controller.clearError,
              child: const Text('关闭'),
            ),
          ],
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AiChatController>('controller', controller));
  }
}
