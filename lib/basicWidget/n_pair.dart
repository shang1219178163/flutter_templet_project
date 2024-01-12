//
//  NPair.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/13 01:22.
//  Copychild © 2024/1/13 shang. All childs reserved.
//


import 'package:flutter/material.dart';

/// 双组件,支持水平和垂直显示
class NPair extends StatelessWidget {

  const NPair({
    super.key,
    required this.child,
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
  });

  /// 文字
  final Widget child;
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

  
  @override
  Widget build(BuildContext context) {
    var gap = SizedBox();
    if (icon != null) {
      gap = direction == Axis.horizontal ? SizedBox(width: betweenGap,) : SizedBox(height: betweenGap,);
    }

    var children = <Widget>[
      if (icon != null)...[icon!, gap],
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
