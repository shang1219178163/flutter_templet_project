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

  // /// SizedBox 垂直间距
  // SizedBox get ph => SizedBox(height: toDouble());
  // /// SizedBox 水平间距
  // SizedBox get pw => SizedBox(width: toDouble());

}

extension DoubleExt on double{
  /// 2位小数
  double get fixed2 => double.parse(toStringAsFixed(2));
  /// 3位小数
  double get fixed3 => double.parse(toStringAsFixed(3));

  /// 转为百分比描述
  String toStringAsPercent(int fractionDigits) {
    if (this >= 1.0) {
      return "100%";
    }
    final result = toStringAsFixed(fractionDigits);
    var percentDes = "${result.replaceAll("0.", "")}%";
    if (percentDes.startsWith("0")) {
      percentDes = percentDes.substring(1);
    }
    return percentDes;
  }
}


extension IntExt on int{
  /// 随机数
  static int random({required int max, int min = 0}) {
    var result = Random().nextInt(max) + min;
    return result;
  }
}

extension IntFileExt on int{
  /// length 转为 MB 描述
  String get fileSize {
    final result = this/(1024 *1024);
    final desc = "${result.toStringAsFixed(2)}MB";
    return desc;
  }

  /// 压缩质量( )
  int get compressQuality {
    int length = this;
    // var quality = 100;
    const mb = 1024 * 1024;
    if (length > 10 * mb) {
      return 20;
    }

    if (length > 8 * mb) {
      return 30;
    }

    if (length > 6 * mb) {
      return 40;
    }

    if (length > 4 * mb) {
      return 50;
    }

    if (length > 2 * mb) {
      return 60;
    }
    return 90;
  }
}