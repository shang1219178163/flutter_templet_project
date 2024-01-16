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

extension NumExt on num {


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

  static int random({int min = 0, required int max}) {
    return min + Random().nextInt(max - min);
  }

  // /// 数字格式化
  // String numFormat([String? newPattern = '0,000', String? locale]) {
  //   final fmt = NumberFormat(newPattern, locale);
  //   return fmt.format(this);
  // }
}

