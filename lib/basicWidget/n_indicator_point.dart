import 'package:flutter/material.dart';

/// 嵌套原点指示器组件
class NIndicatorPoint extends StatelessWidget {
  const NIndicatorPoint({
    super.key,
    this.color = Colors.blue,
    this.size = 12,
  });

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
        width: (size * 0.5),
        height: (size * 0.5),
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
    super.key,
    this.color = Colors.blue,
    this.innerColor,
    this.size = 12,
    this.innerSize = 6,
  });

  final Color color;

  final Color? innerColor;

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
          color: innerColor ?? color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// 原点指示器组件
class NIndicatorCircle extends StatelessWidget {
  const NIndicatorCircle({
    super.key,
    this.size = 14,
    this.color = const Color(0xffE5E5E5),
    this.colorSelected = Colors.blue,
    this.borderWidth = 1,
    this.borderWidthSelected = 4,
    this.isSelected = false,
  });

  final double size;

  /// 默认线宽
  final double borderWidth;

  /// 选中线宽
  final double borderWidthSelected;

  /// 默认颜色
  final Color color;

  /// 选中颜色
  final Color colorSelected;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final currentColor = isSelected ? colorSelected : color;
    final currentWidth = isSelected ? borderWidthSelected : borderWidth;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: currentColor, width: currentWidth),
        shape: BoxShape.circle,
      ),
    );
  }
}

class NIndicatorDoubleCirlce extends StatelessWidget {
  const NIndicatorDoubleCirlce({
    super.key,
    this.color = Colors.blue,
    this.innerColor = Colors.blue,
    this.size = 12,
    this.innerSize = 6,
  });

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
