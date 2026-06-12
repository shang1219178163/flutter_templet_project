
import 'package:flutter/material.dart';

// /// 比赛轮次按钮
// class GameRoundButton extends NStadiumButton {
//   GameRoundButton({
//     super.key,
//     required super.title,
//     super.color = AppColors.color00946D,
//   }) : super(
//     leading: Container(
//       margin: const EdgeInsets.only(left: 6, right: 2),
//       child: const Image(
//         image: AssetImage(Assets.worldCupIconWorldCupTrophy),
//         width: 12,
//       ),
//     ),
//   );
// }

/// 椭圆按钮
class NStadiumButton extends StatelessWidget {
  const NStadiumButton({
    super.key,
    this.leading,
    this.traing,
    required this.title,
    this.titlePadding,
    required this.color,
    this.onPressed,
  });

  final Widget? leading;
  final Widget? traing;

  /// 标题
  final String title;

  final EdgeInsets? titlePadding;

  /// 主色调
  final Color? color;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    /// 背景色
    final primary = themeData.colorScheme.primary;

    /// 文字颜色
    final onPrimary = themeData.colorScheme.onPrimary;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(color: primary),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) leading!,
              Container(
                padding: titlePadding,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: primary,
                  shape: StadiumBorder(),
                ),
                child: Text(
                  title,
                  style: TextStyle(color: onPrimary),
                ),
              ),
              if (traing != null) traing!,
            ],
          ),
        ),
      ),
    );
  }
}
