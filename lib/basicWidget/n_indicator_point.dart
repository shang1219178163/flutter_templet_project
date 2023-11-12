

import 'package:flutter/material.dart';

/// 嵌套原点指示器组件
class NIndicatorPoint extends StatelessWidget {

  const NIndicatorPoint({
  	Key? key,
  	this.color = Colors.blue,
    this.size = 12,
  }) : super(key: key);

  final Color color;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Container(
        width: (size*0.5),
        height: (size*0.5),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}


class NIndicatorPointNew extends StatelessWidget {

  const NIndicatorPointNew({
    Key? key,
    this.color = Colors.blue,
    this.innerColor = Colors.blue,
    this.size = 12,
    this.innerSize = 6,
  }) : super(key: key);

  final Color color;

  final Color innerColor;

  final double size;

  final double innerSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: color),
        shape: BoxShape.circle,
      ),
      child: Container(
        width: innerSize,
        height: innerSize,
        decoration: BoxDecoration(
          color: innerColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}