

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text_and_icon.dart';

/// 图标文字按钮,支持水平和垂直显示
class NTextButton extends StatelessWidget {

  const NTextButton({
  	Key? key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.direction = Axis.horizontal,
    this.color = Colors.white,
    // this.borderColor = const Color(0xffE4E4E4),
    this.borderColor = Colors.transparent,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.radius = 4,
    this.iconTextGap = 6,
    this.isReverse = false,
    this.decoration,
    this.constraints,
    this.child,
  }) : super(key: key);

  /// 文字
  final Widget text;
  /// 图标
  final Widget? icon;
  /// 标题图标方向
  final Axis direction;
  final VoidCallback onPressed;
  /// text 背景色, 默认 Colors.white
  final Color color;
  /// 边框线 默认 Color(0xffE4E4E4)
  final Color borderColor;
  /// 默认 EdgeInsets.zero
  final EdgeInsets? margin;
  /// 默认 EdgeInsets.symmetric(horizontal: 8, vertical: 4)
  final EdgeInsets? padding;
  /// 圆角
  final double radius;
  /// 图标标题间距
  final double iconTextGap;
  /// 标题图标翻转
  final bool isReverse;
  /// 装饰器
  final Decoration? decoration;
  /// 约束条件
  final BoxConstraints? constraints;
  /// 按钮显示自定义
  final Widget? child;


  @override
  Widget build(BuildContext context) {
    final content = NTextAndIcon(
      text: text,
      icon: icon,
      direction: direction,
      isReverse: isReverse,
    );

    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: decoration ?? BoxDecoration(
          color: color,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(radius), //边角
        ),
        constraints: constraints,
        child: child ?? content,
      ),
    );
  }
}


