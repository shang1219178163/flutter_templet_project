//
//  color_ext.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 2:08 PM.
//  Copyright © 7/16/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExt on Color {
  /// 颜色字典
  static final colorsMap = <Color, String>{
    Colors.white: "white",
    Colors.black: "black",
    Colors.pink: "pink",
    Colors.purple: "purple",
    Colors.deepPurple: "deepPurple",
    Colors.indigo: "indigo",
    Colors.blue: "blue",
    Colors.lightBlue: "lightBlue",
    Colors.cyan: "cyan",
    Colors.teal: "teal",
    Colors.green: "green",
    Colors.lightGreen: "lightGreen",
    Colors.lime: "lime",
    Colors.yellow: "yellow",
    Colors.amber: "amber",
    Colors.orange: "orange",
    Colors.deepOrange: "deepOrange",
    Colors.brown: "brown",
    Colors.grey: "grey",
    Colors.blueGrey: "blueGrey",
    Colors.redAccent: "redAccent",
    Colors.pinkAccent: "pinkAccent",
    Colors.purpleAccent: "purpleAccent",
    Colors.deepPurpleAccent: "deepPurpleAccent",
    Colors.indigoAccent: "indigoAccent",
    Colors.blueAccent: "blueAccent",
    Colors.lightBlueAccent: "lightBlueAccent",
    Colors.cyanAccent: "cyanAccent",
    Colors.tealAccent: "tealAccent",
    Colors.greenAccent: "greenAccent",
    Colors.lightGreenAccent: "lightGreenAccent",
    Colors.limeAccent: "limeAccent",
    Colors.yellowAccent: "yellowAccent",
    Colors.amberAccent: "amberAccent",
    Colors.orangeAccent: "orangeAccent",
    Colors.deepOrangeAccent: "deepOrangeAccent",
  };

  ///随机颜色
  static Color get random {
    return Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1,
    );
  }

  /// 十六进制转颜色
  /// alpha, 透明度 [0.0,1.0]
  static Color? fromHex(String? val, {double alpha = 1}) {
    if (val == null || val.isEmpty == true) {
      return null;
    }
    val = val.toUpperCase();
    val = val.replaceAll("#", '');
    val = val.replaceAll("0x", '');
    final result = int.tryParse(val, radix: 16);
    if (result == null) {
      return null;
    }
    return Color(result).withValues(alpha: alpha);
  }

  ///rgba 颜色字符串转 Color
  static Color? fromRGBA(String? val) {
    if (val == null || val == "") {
      return null;
    }
    val = val.replaceAll(")", "");
    val = val.replaceAll("rgba(", "");
    var list = val.split(",");
    if (list.length != 4) {
      return null;
    }
    return Color.fromRGBO(
      int.parse(list[0]),
      int.parse(list[1]),
      int.parse(list[2]),
      double.parse(list[3]),
    );
  }

  /// 是否为纯黑色（包含透明度）
  bool get isPureBlack {
    return r == 0 && g == 0 && b == 0 && a == 0;
  }

  /// 是否为纯白色
  bool get isPureWhite {
    return r == 255 && g == 255 && b == 255 && a == 0;
  }

  /// 当前背景色上显示的文字颜色
  Color textColor({
    Color textColorLight = Colors.black,
    Color textColorDark = Colors.white,
  }) {
    var brightness = ThemeData.estimateBrightnessForColor(this);
    var textColor = brightness == Brightness.dark ? textColorDark : textColorLight;
    if (isPureWhite) {
      textColor = textColorDark;
    } else if (isPureBlack) {
      textColor = textColorLight;
    }
    return textColor;
  }

  // /// 颜色名称描述
  // String get toRadixString {
  //   final result = "#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
  //   return result;
  // }

  /// ARGB 整型色值
  int get argbInt {
    return ((a * 255).round() << 24) |
        ((r * 255).round() << 16) |
        ((g * 255).round() << 8) |
        (b * 255).round();
  }

  String toHex({String prefix = '#'}) {
    final argb = argbInt;
    return '$prefix${argb.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  ///转渐进色
  Gradient? toGradient() => LinearGradient(colors: [this, this], stops: const [0.0, 1]);

  Color randomOpacity() {
    return withValues(alpha: Random().nextInt(100) / 100);
  }

  /// 颜色名称描述
  String get nameDes {
    if (colorsMap.keys.contains(this)) {
      return colorsMap[this] ?? "";
    }
    return toString();
  }
}
