//
//  TweenAnimationBuilder.dart
//  projects
//
//  Created by shang on 2026/3/2 15:15.
//  Copyright © 2026/3/2 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NTweenAnimationBuilder extends StatelessWidget {
  const NTweenAnimationBuilder({
    super.key,
    this.begin = 0.3,
    this.end = 1.0,
    this.duration = const Duration(milliseconds: 300),
    required this.needScale,
    required this.needFade,
    required this.needRotation,
    required this.child,
  });

  final double begin;
  final double end;

  final Duration duration;
  final bool needScale;
  final bool needFade;
  final bool needRotation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      child: child,
      builder: (_, value, child) {
        Widget content = child ?? const SizedBox();
        if (needScale) {
          content = Transform.scale(
            scale: value,
            child: content,
          );
        }

        if (needRotation) {
          content = Transform.rotate(
            angle: value * 2 * 3.1415926, // 360°
            child: content,
          );
        }

        if (needFade) {
          return AnimatedOpacity(
            duration: duration,
            opacity: value,
            child: content,
          );
        }
        return content;
      },
    );
  }
}
