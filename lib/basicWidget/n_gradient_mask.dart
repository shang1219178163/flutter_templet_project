//
//  NGradientMask.dart
//  projects
//
//  Created by shang on 2025/9/19 10:35.
//  Copyright © 2025/9/19 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 渐进色浮层
class NGradientModel {
  NGradientModel({
    required this.color,
    required this.stop,
  });

  Color color;

  double stop;

  Map<String, dynamic> toJson() {
    return {
      "color": color,
      "stop": stop,
    };
  }
}

/// 渐进色浮层
class NGradientMask extends StatelessWidget {
  const NGradientMask({
    super.key,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.models,
    required this.child,
  });

  final AlignmentGeometry begin;

  final AlignmentGeometry end;

  final List<NGradientModel> models;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          // transform: const GradientRotation(65 * (pi / 180)),
          begin: begin,
          end: end,
          colors: models.map((e) => e.color).toList(),
          stops: models.map((e) => e.stop).toList(),
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
