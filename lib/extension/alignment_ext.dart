//
//  AlignmentExtension.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/12 20:57.
//  Copyright © 2023/1/12 shang. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

extension AlignmentExt on Alignment {
  /// 九个方位变量集合
  static const allCases = <Alignment>[
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
  /// isGreed 是否贪婪模式(贪婪模式用大半径,否则小半径)
  /// isDiagonal 四角是否使用对角线(为 true 则 isGreed 参数无效)
  double? radiusOfRadialGradient({
    required double? width,
    required double? height,
    bool isGreed = true,
    bool isDiagonal = true,
  }) {
    if (width == null || height == null || width <= 0 || height <= 0) {
      return null;
    }

    final max = math.max(width, height);
    final min = math.min(width, height);
    var result = 0.5;

    if ([
      Alignment.center,
    ].contains(this)) {
      result = isGreed == true ? max / min * 0.5 : 0.5;
    } else if ([
      Alignment.topCenter,
      Alignment.bottomCenter,
    ].contains(this)) {
      result = isGreed == true ? max / min : 0.5;
    } else if ([
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight
    ].contains(this)) {
      if (isDiagonal) {
        final tmp = math.sqrt(math.pow(max, 2) + math.pow(min, 2)).ceil();
        // result = isGreed == true ? tmp/min : max/min;
        result = tmp / min;
      } else {
        result = isGreed == true ? max / min : 1;
      }
    } else if ([
      Alignment.centerLeft,
      Alignment.centerRight,
    ].contains(this)) {
      result = isGreed == true ? 1 : max / min * 0.5;
    }
    return result;
  }
}
