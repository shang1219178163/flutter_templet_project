//
//  nn_filter.dart
//  flutter_templet_project
//
//  Created by shang on 3/15/23 10:48 AM.
//  Copyright © 3/15/23 shang. All rights reserved.
//

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 组件前后滤镜
class NNFilter extends StatelessWidget {

  NNFilter({
    Key? key,
    this.title,
    this.borderRadius = BorderRadius.zero,
    this.clipper,
    this.clipBehavior = Clip.antiAlias,
    this.foregroundFilter,
    this.filter,
    this.child,
  }) : super(key: key);

  String? title;

  BorderRadius borderRadius;

  CustomClipper<RRect>? clipper;

  Clip clipBehavior ;

  ui.ImageFilter? foregroundFilter;

  ui.ImageFilter? filter;

  Widget? child;


  @override
  Widget build(BuildContext context) {
    if (foregroundFilter == null && filter == null) {
      return child ?? SizedBox();
    }

    return ClipRRect(
      borderRadius: borderRadius,
      clipper: clipper,
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: filter ?? ui.ImageFilter.blur(
          sigmaX: 0,
          sigmaY: 0,
        ),
        child: ImageFiltered(
          imageFilter: foregroundFilter ?? ui.ImageFilter.blur(
            sigmaX: 0,
            sigmaY: 0,
          ),
          child: child,
        ),
      ),
    );
  }
}
