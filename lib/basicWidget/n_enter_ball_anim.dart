import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// 进球闪烁动画
class NEnterBallAnim extends StatelessWidget {
  const NEnterBallAnim({
    super.key,
    required this.valueListenable,
    this.textAlign,
    this.backgroundColorBuilder,
    this.styleBuilder,
    required this.child,
  });

  final ValueNotifier<bool> valueListenable;
  final TextAlign? textAlign;
  final Color Function(bool isEnter)? backgroundColorBuilder;
  final TextStyle Function(bool isEnter)? styleBuilder;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final fontColor = isDark ? AppColor.white : AppColor.fontColor;

    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, value, _) {
        final bgColorDefault = value ? AppColor.cancelColor : Colors.transparent;
        final bgColor = backgroundColorBuilder?.call(value) ?? bgColorDefault;
        final style = styleBuilder?.call(value) ??
            TextStyle(
              color: value ? Colors.white : fontColor,
              fontSize: 16,
              fontFamily: 'DingTalk',
            );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: DefaultTextStyle(
            textAlign: textAlign,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: style,
            child: child,
          ),
        );
      },
    );
  }
}
