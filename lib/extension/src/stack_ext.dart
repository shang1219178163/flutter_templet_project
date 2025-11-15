//
//  StackExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:18.
//  Copyright © 2023/8/29 shang. All rights reserved.
//

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

extension StackExt on Stack {
  /// 创建高斯模糊
  static Widget createBlurView({
    required Widget child,
    required double? blur,
    BorderRadius? borderRadius = BorderRadius.zero,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
    TileMode tileMode = TileMode.clamp,
  }) {
    if (blur == null || blur <= 0.0) {
      return child;
    }

    return Stack(
      // fit: StackFit.expand,
      children: [
        child,
        Positioned.fill(
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            clipper: clipper,
            clipBehavior: clipBehavior,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: blur,
                sigmaY: blur,
                tileMode: tileMode,
              ),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
        )
      ],
    );
  }
}

extension PositionedExt on Positioned {}
