//
//  NPair.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/13 01:22.
//  Copychild © 2024/1/13 shang. All childs reserved.
//


import 'package:flutter/material.dart';

/// 双组件,支持水平和垂直显示
class NPair<T> extends StatelessWidget {

  const NPair({
    super.key,
    this.data,
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
    this.icon,
    required this.child,
  });
  /// 传参
  final T? data;

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

  /// 图标
  final Widget? icon;
  /// 文字
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return child;
    }

    var gap = direction == Axis.horizontal ? SizedBox(width: betweenGap,) : SizedBox(height: betweenGap,);
    var children = <Widget>[
      icon ?? SizedBox(),
      gap,
      Flexible(child: child),
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
