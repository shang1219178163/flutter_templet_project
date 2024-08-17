//
//  CirclePainter.dart
//  flutter_templet_project
//
//  Created by shang on 12/14/21 11:04 AM.
//  Copyright © 12/14/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  CurvePainter({
    this.color = Colors.black,
    this.radius = 12,
  });

  final Color color;
  final double radius;

  @override
  bool hitTest(Offset position) => true;

  @override
  bool shouldRepaint(CurvePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    var startPoint = Offset(0, size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 3);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
    var endPoint = Offset(size.width, size.height / 2);

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    // path.addRRect(RRect.fromLTRBXY(
    //   0, 0, size.width, size.height, radius, radius,
    // ));
    canvas.drawPath(path, paint);
  }
}
