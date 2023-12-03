

import 'package:flutter/cupertino.dart';

/// 渐进色边框
class GradientBorderPainter extends CustomPainter {

  const GradientBorderPainter({
    this.strokeWidth = 1.0,
    this.topLeft = const Radius.circular(8),
    this.topRight = const Radius.circular(8),
    this.bottomRight = const Radius.circular(8),
    this.bottomLeft = const Radius.circular(8),
    this.gradient,
    required this.colors,
  });
  /// 绘制线宽
  final double strokeWidth;

  final Radius topLeft;
  final Radius topRight;
  final Radius bottomRight;
  final Radius bottomLeft;
  /// 渐变色
  final Gradient? gradient;
  /// 默认渐变色颜色
  final List<Color> colors;


  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset(0, 0) & size;
    // debugPrint("size: $size, rect: $rect");

    var rRect = RRect.fromRectAndCorners(rect,
      topLeft: topLeft,
      topRight: topRight,
      bottomRight: bottomRight,
      bottomLeft: bottomLeft,
    );

    final paint = Paint()
      ..shader = (gradient ?? LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: colors,
      )).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBorderPainter oldDelegate) {
    return oldDelegate.colors != colors
        || oldDelegate.gradient != gradient
        || oldDelegate.strokeWidth != strokeWidth
        || oldDelegate.topLeft != topLeft
        || oldDelegate.topRight != topRight
        || oldDelegate.bottomRight != bottomRight
        || oldDelegate.bottomLeft != bottomLeft;
  }
}
