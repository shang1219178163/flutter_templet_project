//
//  CirclePainter.dart
//  flutter_templet_project
//
//  Created by shang on 12/14/21 11:04 AM.
//  Copyright © 12/14/21 shang. All rights reserved.
//


import 'dart:math';

import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter({
    this.color = Colors.black,
  });

  final Color color;

  @override
  bool hitTest(Offset position) => true;

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final point = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawCircle(point, min(size.width, size.height) * 0.5, paint);
  }
}



