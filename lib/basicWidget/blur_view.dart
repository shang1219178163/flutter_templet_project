//
//  blur_view.dart
//  flutter_templet_project
//
//  Created by shang on 7/30/21 11:49 AM.
//  Copyright © 7/30/21 shang. All rights reserved.
//


import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// 高斯模糊
class BlurView extends StatelessWidget {

  const BlurView({
    this.margin, 
    this.radius = 10, 
    required this.child, 
    this.backdropFilter, 
    this.blur
  });

  final EdgeInsets? margin;

  final double? radius;
  final BackdropFilter? backdropFilter;
  final Widget child;

  final double? blur;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius!)),
        child: backdropFilter ?? BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: blur ?? 20,
            sigmaY: blur ?? 20,
          ),
          child: child,
        ),
      ),
    );
  }
}
