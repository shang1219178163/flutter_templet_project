//
//  MyPainter.dart
//  flutter_templet_project
//
//  Created by shang on 12/14/21 11:04 AM.
//  Copyright © 12/14/21 shang. All rights reserved.
//


import 'dart:math';

import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  MyPainter({
    this.padding = const EdgeInsets.all(0),
    this.color = Colors.black,
  });

  final EdgeInsets padding;

  final Color color;

  @override
  bool hitTest(Offset position) => true;

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return oldDelegate.padding != padding && oldDelegate.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final point = Offset(size.width * 0.5 + (padding.left - padding.right) * 0.5, size.height * 0.5 + (padding.top - padding.bottom) * 0.5);
    canvas.drawCircle(point, min(size.width, size.height) * 0.5 - 20, paint);
  }
}

