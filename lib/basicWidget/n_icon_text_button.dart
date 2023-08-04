

import 'package:flutter/material.dart';

/// 图标文字按钮,支持水平和垂直显示
class NIconTextButton extends StatelessWidget {

  const NIconTextButton({
  	Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.direction = Axis.horizontal,
    this.color = Colors.white,
    this.borderColor = const Color(0xffE4E4E4),
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.radius = 4,
    this.iconTextGap = 6,
    this.isReverse = false,
    this.decoration,
    this.constraints,
  }) : super(key: key);

  final Widget text;
  final Widget icon;
  /// 标题图标方向
  final Axis direction;
  final VoidCallback onTap;
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


  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      icon,
      SizedBox(width: iconTextGap,),
      text,
    ];

    if (isReverse) {
      children = children.reversed.toList();
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: decoration ?? BoxDecoration(
          color: color,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(radius), //边角
        ),
        constraints: constraints,
        child: Flex(
          direction: direction,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

