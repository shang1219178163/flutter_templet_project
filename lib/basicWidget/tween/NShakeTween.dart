import 'dart:math';

import 'package:flutter/material.dart';

/// 左右抖动
class NShakeTween extends Animatable<Offset> {
  final Offset center;
  final double amplitude;

  NShakeTween({
    this.center = Offset.zero,
    required this.amplitude,
  });

  @override
  Offset transform(double t) {
    // 👉 高频振荡 + 衰减
    final dx = sin(t * 20) * amplitude * (1 - t);
    return center + Offset(dx, 0);
  }
}
