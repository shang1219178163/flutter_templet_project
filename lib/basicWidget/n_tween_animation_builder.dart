//
//  TweenAnimationBuilder.dart
//  projects
//
//  Created by shang on 2026/3/2 15:15.
//  Copyright © 2026/3/2 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NTweenAnimationBuilder<T> extends StatelessWidget {
  const NTweenAnimationBuilder({
    super.key,
    required this.tween,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.onEnd,
    this.needScale = false,
    this.needFade = false,
    this.needRotation = false,
    required this.child,
  });

  final Tween<T> tween;

  final Duration duration;
  final Curve curve;
  final VoidCallback? onEnd;

  final bool needScale;
  final bool needFade;
  final bool needRotation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<T>(
      tween: tween,
      duration: duration,
      onEnd: onEnd,
      child: child,
      builder: (_, value, child) {
        var content = child ?? const SizedBox();
        if (needScale && value is double) {
          content = Transform.scale(
            scale: value,
            child: content,
          );
        }

        if (needRotation && value is double) {
          content = Transform.rotate(
            angle: value * 2 * 3.1415926, // 360°
            child: content,
          );
        }

        if (needFade && value is double) {
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Tween<T>>('tween', tween));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
    properties.add(DiagnosticsProperty<Curve>('curve', curve));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onEnd', onEnd));
    properties.add(DiagnosticsProperty<bool>('needScale', needScale));
    properties.add(DiagnosticsProperty<bool>('needFade', needFade));
    properties.add(DiagnosticsProperty<bool>('needRotation', needRotation));
  }
}
