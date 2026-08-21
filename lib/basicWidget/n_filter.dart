//
//  n_filter.dart
//  flutter_templet_project
//
//  Created by shang on 3/15/23 10:48 AM.
//  Copyright © 3/15/23 shang. All rights reserved.
//

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 自定义滤镜组件, 支持前后滤镜
class NFilter extends StatelessWidget {
  const NFilter({
    super.key,
    this.borderRadius = BorderRadius.zero,
    this.clipper,
    this.clipBehavior = Clip.antiAlias,
    this.fgFilter,
    this.filter,
    this.child,
  });

  final BorderRadius borderRadius;

  final CustomClipper<RRect>? clipper;

  final Clip clipBehavior;

  /// 前景滤镜
  final ui.ImageFilter? fgFilter;

  /// 背景滤镜
  final ui.ImageFilter? filter;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if ([fgFilter, filter].every((e) => e == null)) {
      return child ?? SizedBox();
    }

    return ClipRRect(
      borderRadius: borderRadius,
      clipper: clipper,
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: filter ?? ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: ImageFiltered(
          imageFilter: fgFilter ?? ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: child,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<CustomClipper<ui.RRect>?>('clipper', clipper));
    properties.add(EnumProperty<ui.Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<ui.ImageFilter?>('fgFilter', fgFilter));
    properties.add(DiagnosticsProperty<ui.ImageFilter?>('filter', filter));
  }
}
