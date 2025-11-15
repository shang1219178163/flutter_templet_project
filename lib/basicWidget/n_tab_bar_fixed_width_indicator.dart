//
//  NTabBarFixedWidthIndicator.dart
//  flutter_templet_project
//
//  Created by shang on 2025/9/20 09:37.
//  Copyright © 2025/9/20 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NTabBarFixedWidthIndicator extends Decoration {
  final Color? color;
  final Gradient? gradient;
  final double width;
  final double height;
  final double topMargin;
  final double borderRadius;

  const NTabBarFixedWidthIndicator({
    this.color,
    this.gradient,
    required this.width,
    this.height = 4.0,
    this.topMargin = 0.0,
    this.borderRadius = 8.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedPainter(
      color: color,
      gradient: gradient,
      width: width,
      height: height,
      topMargin: topMargin,
      borderRadius: borderRadius,
    );
  }
}

class _RoundedPainter extends BoxPainter {
  final Color? color;
  final Gradient? gradient;
  final double width;
  final double height;
  final double topMargin;
  final double borderRadius;

  _RoundedPainter({
    this.color,
    this.gradient,
    required this.width,
    required this.height,
    required this.topMargin,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final startX = offset.dx + (configuration.size!.width - width) / 2;
    final endX = startX + width;
    final topY = configuration.size!.height - height - topMargin;

    final indicatorRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(startX, topY, width, height),
      Radius.circular(borderRadius),
    );

    final paint = Paint()..style = PaintingStyle.fill;

    if (gradient != null) {
      paint.shader = gradient!.createShader(indicatorRect.outerRect);
    } else {
      paint.color = color ?? Colors.transparent;
    }

    canvas.drawRRect(indicatorRect, paint);
  }
}
