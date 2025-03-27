//
//  NumExtension.dart
//  lib
//
//  Created by shang on 11/29/21 3:38 PM.
//  Copyright © 11/29/21 shang. All rights reserved.
//

import 'dart:math';

// import 'package:flutter/cupertino.dart';

extension NumExt on num {}

extension IntExt on int {
  static int random({int min = 0, required int max}) {
    return min + Random().nextInt(max - min);
  }

  String toHanzi() {
    if (this == 0) {
      return '零';
    }

    final chineseDigits = '零一二三四五六七八九'.split("").toList();
    final chineseUnits = '十百千万亿'.split("").toList();

    var result = '';
    var unitIndex = 0;
    var number = this;

    while (number > 0) {
      var digit = number % 10;
      result = (digit == 0 ? '' : chineseDigits[digit]) + chineseUnits[unitIndex] + result;
      unitIndex++;
      number ~/= 10;
    }

    // 处理连续的零
    result = result.replaceAllMapped(RegExp('零+'), (match) => '零').replaceAll(RegExp('^零|零\$'), '');

    return result;
  }

  /// 生成随机字符串
  String generateChars({
    String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    String Function(String e)? convert,
  }) {
    if (this == 0) {
      return "";
    }
    return generateList(items: chars.split("").toList(), convert: convert);
  }

  /// 生成随机字符串
  String generateList({
    required List<String> items,
    String Function(String e)? convert,
  }) {
    if (this == 0) {
      return "";
    }
    var length = this;
    var tmp = "";
    for (var i = 0; i < length; i++) {
      var randomIndex = IntExt.random(max: items.length);
      var randomChar = items[randomIndex];
      tmp += convert?.call(randomChar) ?? randomChar;
    }
    return tmp;
  }

// /// 数字格式化
// String numFormat([String? newPattern = '0,000', String? locale]) {
//   final fmt = NumberFormat(newPattern, locale);
//   return fmt.format(this);
// }
}

extension DoubleExt on double {
  /// 保留小数位数
  double fixed(int fractionDigits) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  /// 2位小数
  double get fixed2 => fixed(2);

  /// 3位小数
  double get fixed3 => fixed(3);

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
