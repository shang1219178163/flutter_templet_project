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
    required this.color,
  });

  final Widget? leading;
  final Widget? traing;

  /// 标题
  final String title;

  /// 主色调
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorNew = color ?? Theme.of(context).colorScheme.primary;

    Widget titleWidget = Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: ShapeDecoration(
        color: color,
        shape: StadiumBorder(),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    if (leading == null && traing == null) {
      return titleWidget;
    }
    return Container(
      decoration: ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(color: colorNew),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) leading!,
          // Container(
          //   margin: EdgeInsets.only(left: 6, right: 2),
          //   child: const Image(
          //     image: AssetImage(Assets.worldCupIconWorldCupTrophy),
          //     width: 12,
          //   ),
          // ),
          titleWidget,
          if (traing != null) traing!,
        ],
      ),
    );
  }
}
