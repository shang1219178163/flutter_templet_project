//
//  SizeExtension.dart
//  三翼鸟工作台
//
//  Created by shang on 9/23/22 12:48 PM.
//
//


import 'dart:math' as math;

import 'package:flutter/painting.dart';

extension SizeExt on Size {
  /// 等比缩放大小
  Size adjustToWidth(double width) {
    final scale = width / this.width;
    final heightNew = scale * this.height;
    // print("SizeExt:${heightNew}");
    return Size(width, heightNew);
  }
  /// 等比缩放大小
  Size adjustToHeight(double height) {
    final scale = height / this.height;
    final widthNew = scale * this.width;
    // print("SizeExt:${widthNew}");
    return Size(widthNew, height);
  }


  /// 获取雷达渐进色 radius
  radiusOfRadialGradient({
    Alignment alignment = Alignment.center,
  }) {
    final max = math.max(width, height);
    final min = math.min(width, height);
    double result = max/min;
    if (alignment.x != 0) {
      result *= 2.0;
    }
    return result;
  }
}


