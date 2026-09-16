import 'package:flutter/material.dart';
import 'package:flutter_templet_project/generated/assets.dart';

/// 资讯详情底部评论输入栏
class NewsDetailBottomBar extends StatelessWidget {
  const NewsDetailBottomBar({
    super.key,
    this.onTap,
    this.count = 0,
  });

  final VoidCallback? onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomSafePadding = MediaQuery.of(context).padding.bottom;

    final countDesc = count > 99 ? "99+" : "$count";
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + bottomSafePadding),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            color: cs.shadow.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 34,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    const Image(
                      image: AssetImage(Assets.inputBarIcEdit),
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '我来说几句',
                      style: TextStyle(
                        fontSize: 12,
                        height: 28 / 12,
                        letterSpacing: 1.2,
                        color: cs.onSurfaceVariant,
                        fontFamily: 'PingFang SC',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Badge(
            label: Text(countDesc),
            offset: Offset(0, -6),
            isLabelVisible: count > 0,
            child: Image(
              image: AssetImage(Assets.inputBarIcNotice),
              width: 28,
              height: 28,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
