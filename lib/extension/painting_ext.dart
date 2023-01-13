//
//  PaintingExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/13 22:49.
//  Copyright © 2023/1/13 shang. All rights reserved.
//


// import 'dart:ui' as ui;
import 'package:flutter/painting.dart';

extension BlendModeExt on BlendMode {

  /// BlendMode 集合
  static const allCases = <BlendMode>[
    BlendMode.clear,
    BlendMode.src,
    BlendMode.dst,
    BlendMode.srcOver,
    BlendMode.dstOver,
    BlendMode.srcIn,
    BlendMode.dstIn,
    BlendMode.srcOut,
    BlendMode.dstOut,
    BlendMode.srcATop,
    BlendMode.dstATop,
    BlendMode.xor,
    BlendMode.plus,
    BlendMode.modulate,
    BlendMode.screen,
    BlendMode.overlay,
    BlendMode.darken,
    BlendMode.lighten,
    BlendMode.colorDodge,
    BlendMode.colorBurn,
    BlendMode.hardLight,
    BlendMode.softLight,
    BlendMode.difference,
    BlendMode.exclusion,
    BlendMode.multiply,
    BlendMode.hue,
    BlendMode.saturation,
    BlendMode.color,
    BlendMode.luminosity,
  ];

}

extension TileModeExt on TileMode {
  /// TileMode 集合
  static const allCases = <TileMode>[
    TileMode.clamp,
    TileMode.repeated,
    TileMode.mirror,
    TileMode.decal,
  ];

}