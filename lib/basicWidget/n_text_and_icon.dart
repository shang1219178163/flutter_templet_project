

import 'package:flutter/material.dart';

/// 图标文字,支持水平和垂直显示
class NTextAndIcon<T> extends StatelessWidget {

  const NTextAndIcon({
    Key? key,
    required this.text,
    this.icon,
    this.isReverse = false,
    this.betweenGap = 6,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    this.clipBehavior = Clip.none,
    this.data,
  }) : super(key: key);

  /// 文字
  final Widget text;
  /// 图标
  final Widget? icon;
  /// 标题图标翻转
  final bool isReverse;
  /// 图标标题间距
  final double betweenGap;
  /// 标题图标方向
  final Axis direction;

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final Clip clipBehavior;

  final T? data;

  @override
  Widget build(BuildContext context) {

    var gap = SizedBox();
    if (icon != null) {
      gap = direction == Axis.horizontal ? SizedBox(width: betweenGap,) : SizedBox(height: betweenGap,);
    }

    var children = <Widget>[
      if (icon != null)icon!,
      gap,
      Flexible(child: text),
    ];

    if (isReverse) {
      children = children.reversed.toList();
    }

    return Flex(
      direction: direction,
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}
