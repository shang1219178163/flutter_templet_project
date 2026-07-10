import 'package:flutter/material.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = context.watch<ThemeProvider>();
    final bottomSafePadding = MediaQuery.of(context).padding.bottom;
    final barBackgroundColor = themeProvider.isDark ? themeProvider.color242434OrWhite : Colors.white;
    final fieldBackgroundColor = themeProvider.isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF3F4F8);

    final countDesc = count > 99 ? "99+" : "$count";
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + bottomSafePadding),
      decoration: BoxDecoration(
        color: barBackgroundColor,
        // border: Border.all(color: Colors.blue),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, -1),
            color: Color(0x0D000000),
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
                  color: fieldBackgroundColor,
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
                        color: themeProvider.placeholderColor,
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
              color: themeProvider.titleColor,
            ),
          ),
        ],
      ),
    );
  }
}
