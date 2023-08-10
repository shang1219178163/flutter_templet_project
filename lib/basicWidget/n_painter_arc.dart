


import 'dart:math';

import 'package:flutter/material.dart';

class NPainterArc extends CustomPainter {
  NPainterArc({
    this.color = Colors.black,
    this.percent = 1.0,
  });

  final Color color;
  final double percent;

  @override
  bool hitTest(Offset position) => true;

  @override
  bool shouldRepaint(NPainterArc oldDelegate) {
    return oldDelegate.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = min(size.width, size.height);
    final rect = Rect.fromCircle(
      center: Offset(size.width/2, size.height/2),
      radius: radius/2,
    );

    canvas.drawArc(rect, 0.0, 2*pi*percent, false, paint);
  }
}