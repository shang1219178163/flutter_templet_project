//
//  AlignmentExtension.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/12 20:57.
//  Copyright © 2023/1/12 shang. All rights reserved.
//
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';


extension AlignmentExt on Alignment{
  /// 九个方位变量集合
  static const List<Alignment> allCases = [
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];

  /// 获取雷达渐进色 radius
  double? radiusOfRadialGradient({
    double? width = 0,
    double? height = 0,
  }) {
    if(width == null || height == null
        || width == 0 || height == 0) {
      return null;
    }

    final max = math.max(width, height);
    final min = math.min(width, height);
    double result = max/min;
    if (this.x != 0) {
      result *= 2.0;
    }
    return result;
  }
}