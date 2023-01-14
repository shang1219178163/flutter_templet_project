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
    required double? width,
    required double? height,
    bool isGreed = false,
  }) {
    if(width == null || height == null
        || width == 0 || height == 0) {
      return null;
    }

    final max = math.max(width, height);
    final min = math.min(width, height);
    double result = 0.5;

    if([
      Alignment.center,
    ].contains(this)){
      result = isGreed == true ? max/min * 0.5 : 0.5;

    } else if ([
      Alignment.topCenter,
      Alignment.bottomCenter,
    ].contains(this)) {
      result = isGreed == true ? max/min : 0.5;

    } else if ([
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight
    ].contains(this)) {
      final tmp = math.sqrt(math.pow(max, 2) + math.pow(min, 2)).ceil();
      print("tmp:$tmp");
      result = tmp/min;

    } else if ([
      Alignment.centerLeft,
      Alignment.centerRight,
    ].contains(this)) {
      result = isGreed == true ? 1 : max/min * 0.5;
    }
    return result;
  }
}