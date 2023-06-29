//
//  NumExtension.dart
//  lib
//
//  Created by shang on 11/29/21 3:38 PM.
//  Copyright © 11/29/21 shang. All rights reserved.
//


import 'dart:math';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

int randomInt({required int min, required int max}) {
  return min + Random().nextInt(max - min);
}

extension NumExt on num {
  // /// [ScreenUtil.setWidth]
  // double get w => ScreenUtil().setWidth(this);
  //
  // /// [ScreenUtil.setHeight]
  // double get h => ScreenUtil().setHeight(this);
  //
  // /// [ScreenUtil.setSp]
  // double get sp => ScreenUtil().setSp(this);
  //
  // /// 屏幕宽度的倍数
  // double get sw => ScreenUtil().screenWidth * this;
  //
  // /// 屏幕高度的倍数
  // double get sh => ScreenUtil().screenHeight * this;

  /// SizedBox 垂直间距
  SizedBox get ph => SizedBox(height: toDouble());
  /// SizedBox 水平间距
  SizedBox get pw => SizedBox(width: toDouble());

}

extension DoubleExt on double{
  /// 转为百分比描述
  String toStringAsPercent(int fractionDigits) {
    if (this >= 1.0) {
      return "100%";
    }
    final result = toStringAsFixed(fractionDigits);
    return "${result.replaceAll("0.", "")}%";
  }
}


extension IntExt on int{
  /// 转为百分比描述
  static int random({required int max, int min = 0}) {
    var result = Random().nextInt(max) + min;
    return result;
  }
}
