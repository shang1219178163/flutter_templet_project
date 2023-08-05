

import 'package:flutter/material.dart';

/// 图标文字,支持水平和垂直显示
class NTextAndIcon<T> extends StatelessWidget {

  const NTextAndIcon({
    Key? key,
    required this.text,
    this.icon,
    this.direction = Axis.horizontal,
    this.betweenGap = 6,
    this.isReverse = false,
    this.padding = const EdgeInsets.all(8),
    this.data,
  }) : super(key: key);

  /// 文字
  final Widget text;
  /// 图标
  final Widget? icon;
  /// 标题图标方向
  final Axis direction;
  /// 图标标题间距
  final double betweenGap;
  /// 标题图标翻转
  final bool isReverse;

  final EdgeInsets padding;

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
      text,
    ];

    if (isReverse) {
      children = children.reversed.toList();
    }

    return Padding(
      padding: padding,
      child: Flex(
        // mainAxisSize: MainAxisSize.min,
        direction: direction,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
