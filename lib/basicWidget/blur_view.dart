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

  BlurView({
    super.key,
    this.borderRadius = BorderRadius.zero,
    this.clipper,
    this.clipBehavior = Clip.antiAlias,
    required this.child, 
    this.backdropFilter, 
    this.blur = 20,
  });

  final BorderRadiusGeometry borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip clipBehavior;

  final BackdropFilter? backdropFilter;
  final Widget child;

  final double blur;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      clipper: clipper,
      child: backdropFilter ?? BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: blur ?? 20,
          sigmaY: blur ?? 20,
        ),
        child: child,
      ),
    );
  }
}
