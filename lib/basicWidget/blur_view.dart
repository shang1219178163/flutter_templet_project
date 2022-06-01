//
//  blur_view.dart
//  flutter_templet_project
//
//  Created by shang on 7/30/21 11:49 AM.
//  Copyright © 7/30/21 shang. All rights reserved.
//


import 'dart:ui';
import 'package:flutter/material.dart';

/// 高斯模糊
class BlurView extends StatelessWidget {
  final EdgeInsets? margin;

  final double? radius;
  final BackdropFilter? backdropFilter;
  final Widget child;

  final double? sigma;

  const BlurView({this.margin, this.radius = 10, required this.child, this.backdropFilter, this.sigma});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius!)),
        child: backdropFilter ?? BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: this.sigma ?? 20,
            sigmaY: this.sigma ?? 20,
          ),
          child: child,
        ),
      ),
    );
  }
}
