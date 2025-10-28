import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

class NEnterBallAnim extends StatelessWidget {
  const NEnterBallAnim({
    super.key,
    required this.valueListenable,
    this.textAlign,
    required this.child,
  });

  final ValueNotifier<bool> valueListenable;
  final TextAlign? textAlign;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final fontColor = isDark ? AppColor.white : AppColor.fontColor;

    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, value, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: value ? AppColor.cancelColor : Colors.transparent,
            borderRadius: BorderRadius.circular(3),
          ),
          child: DefaultTextStyle(
            textAlign: textAlign,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: value ? Colors.white : fontColor,
              fontSize: 16,
              fontFamily: 'DingTalk',
            ),
            child: child,
          ),
        );
      },
    );
  }
}
