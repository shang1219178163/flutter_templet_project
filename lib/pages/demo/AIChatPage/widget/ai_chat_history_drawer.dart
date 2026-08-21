import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_dialog.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/controller/ai_chat_controller.dart';
import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_chat_models.dart';

/// 历史会话侧栏内容（由 [NOverlayDialog.drawer] 从左侧滑入）
class AiChatHistoryDrawer extends StatelessWidget {
  const AiChatHistoryDrawer({
    super.key,
    required this.controller,
  });

  final AiChatController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '历史会话',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => NOverlayDialog.dismiss(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  final list = controller.sessions;
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        '暂无历史会话\n发送消息后会出现在这里',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).hintColor, height: 1.5),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final s = list[index];
                      return _SessionTile(
                        session: s,
                        selected: s.id == controller.activeSessionId,
                        onTap: () async {
                          await controller.openSession(s.id);
                          await NOverlayDialog.dismiss();
                        },
                        onDelete: () async {
                          await controller.deleteSession(s.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.session,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  final AiChatSession session;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final time = DateTime.fromMillisecondsSinceEpoch(session.updatedAtMs);
    final timeText =
        '${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return ListTile(
      selected: selected,
      selectedTileColor: scheme.primaryContainer.withValues(alpha: 0.35),
      title: Text(session.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '$timeText · ${session.messages.length} 条',
        style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
      ),
      trailing: IconButton(
        tooltip: '删除',
        visualDensity: VisualDensity.compact,
        onPressed: onDelete,
        icon: Icon(Icons.delete_outline, color: Theme.of(context).hintColor),
      ),
      onTap: onTap,
    );
  }
}
