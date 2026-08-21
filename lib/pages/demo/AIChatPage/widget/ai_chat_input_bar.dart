import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/controller/ai_chat_controller.dart';

/// 底部输入区：多行输入 + 模型菜单 + 发送/停止
class AiChatInputBar extends StatelessWidget {
  const AiChatInputBar({
    super.key,
    required this.controller,
    required this.inputController,
    required this.focusNode,
    required this.onSendOrStop,
  });

  final AiChatController controller;
  final TextEditingController inputController;
  final FocusNode focusNode;

  /// 流式中为停止，否则为发送
  final VoidCallback onSendOrStop;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final hint = Theme.of(context).hintColor;

    return Material(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Stack(
                children: [
                  TextField(
                    controller: inputController,
                    focusNode: focusNode,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    decoration: const InputDecoration(
                      hintText: '说点什么…',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(12, 6, 12, 32),
                    ),
                    onSubmitted: (_) => onSendOrStop(),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    // 叠在输入框右下角的模型选择
                    child: ListenableBuilder(
                      listenable: controller,
                      builder: (context, _) {
                        final current = controller.model;
                        final short = current.length > 16 ? '${current.substring(0, 16)}…' : current;
                        return NMenuAnchor<String>(
                          key: ValueKey('${controller.provider.name}_$current'),
                          values: controller.selectableModels,
                          initialItem: current,
                          equal: (a, b) => a == b,
                          cbName: (e) => e ?? '选择模型',
                          onChanged: (e) {
                            if (!controller.isStreaming) {
                              controller.setModel(e);
                            }
                          },
                          constraints: const BoxConstraints(maxHeight: 240, minWidth: 160, maxWidth: 280),
                          builder: (menu, _) => InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: controller.isStreaming
                                ? null
                                : () => menu.isOpen ? menu.close() : menu.open(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.smart_toy_outlined, size: 14, color: hint),
                                  const SizedBox(width: 2),
                                  Text(short.isEmpty ? '选择模型' : short, style: TextStyle(fontSize: 12, color: hint)),
                                  Icon(Icons.arrow_drop_down, size: 16, color: hint),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                final streaming = controller.isStreaming;
                return IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: streaming ? Colors.redAccent : primary,
                  ),
                  onPressed: onSendOrStop,
                  icon: Icon(streaming ? Icons.stop : Icons.send),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
