//
//  MyPainter.dart
//  flutter_templet_project
//
//  Created by shang on 12/14/21 11:04 AM.
//  Copyright © 12/14/21 shang. All rights reserved.
//


import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  MyPainter({
    this.padding = const EdgeInsets.all(0),
    this.color = Colors.black,
  });

  final EdgeInsets padding;

  final Color color;

  @override
  bool hitTest(Offset point) => true;

  @override
  bool shouldRepaint(MyPainter oldPainter) {
    return oldPainter.padding != padding && oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = this.color
      ..style = PaintingStyle.fill;

    final point = Offset(size.width * 0.5 + (padding.left - padding.right) * 0.5, size.height * 0.5 + (padding.top - padding.bottom) * 0.5);
    canvas.drawCircle(point, min(size.width, size.height) * 0.5 - 20, paint);
  }
}

