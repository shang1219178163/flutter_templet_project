//
//  NFlipCard.dart
//  flutter_templet_project
//
//  Created by shang on 2026/3/25 12:06.
//  Copyright © 2026/3/25 shang. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 翻转组件
class NFlipCard extends StatefulWidget {
  const NFlipCard({
    super.key,
    this.axis = Axis.vertical,
    this.fontBuilder,
    this.backBuilder,
  });

  /// 翻转方向
  final Axis axis;
  final Widget Function(VoidCallback onToggle)? fontBuilder;
  final Widget Function(VoidCallback onToggle)? backBuilder;

  @override
  State<NFlipCard> createState() => _NFlipCardState();
}

class _NFlipCardState extends State<NFlipCard> {
  bool _flipped = false;

  void toggle() {
    _flipped = !_flipped;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant NFlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.axis != widget.axis ||
        oldWidget.fontBuilder?.call(toggle) != widget.fontBuilder?.call(toggle) ||
        oldWidget.backBuilder?.call(toggle) != widget.backBuilder?.call(toggle)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _flipped ? 1 : 0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        final angle = value * math.pi; // 0 → π
        final isBack = angle > math.pi / 2;

        final transformFront = Matrix4.identity()..setEntry(3, 2, 0.001) // 🔥 透视
            ;
        final transformBack = Matrix4.identity();

        if (widget.axis == Axis.horizontal) {
          transformFront.rotateY(angle);
          transformBack.rotateY(math.pi);
        } else {
          transformFront.rotateX(angle);
          transformBack.rotateX(math.pi);
        }

        return Transform(
          alignment: Alignment.center,
          transform: transformFront,
          child: isBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: transformBack,
                  child: buildBack(),
                )
              : buildFront(),
        );
      },
    );
  }

  Widget buildFront() {
    return widget.fontBuilder?.call(toggle) ??
        _card(
          width: 200,
          height: 100,
          color: Colors.blue,
          text: "Front",
        );
  }

  Widget buildBack() {
    return widget.backBuilder?.call(toggle) ??
        _card(
          width: 100,
          height: 200,
          color: Colors.red,
          text: "Back",
        );
  }

  Widget _card({
    double? width,
    double? height,
    required Color color,
    required String text,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
