//
//  BoxDecorationExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/25/21 2:01 PM.
//  Copyright © 10/25/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension BoxDecorationExt on BoxDecoration {
  /// 合并
  BoxDecoration merge(BoxDecoration? decoration) {
    if (decoration == null) {
      return this;
    }
    return copyWith(
      color: decoration.color,
      image: decoration.image,
      border: decoration.border,
      borderRadius: decoration.borderRadius,
      boxShadow: decoration.boxShadow,
      gradient: decoration.gradient,
      backgroundBlendMode: decoration.backgroundBlendMode,
      shape: decoration.shape,
    );
  }
}

extension BorderExt on Border {}

extension BorderRadiusExt on BorderRadius {
  /// 根据函数转化
  BorderRadius convert(Radius Function(Radius value) cb) {
    return BorderRadius.only(
      topLeft: cb(topLeft),
      topRight: cb(topRight),
      bottomLeft: cb(bottomLeft),
      bottomRight: cb(bottomRight),
    );
  }
}
