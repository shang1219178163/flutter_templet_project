//
//  color_ext.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 2:08 PM.
//  Copyright © 7/16/21 shang. All rights reserved.
//

import 'dart:math';
import 'dart:ui';

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
        Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);
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
    return Color(result).withOpacity(alpha);
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

  ///转渐进色
  Gradient? toGradient() => LinearGradient(colors: [
        this,
        this,
      ], stops: const [
        0.0,
        1
      ]);

  Color randomOpacity() {
    return withOpacity(Random().nextInt(100) / 100);
  }

  /// 颜色名称描述
  String get nameDes {
    if (colorsMap.keys.contains(this)) {
      return colorsMap[this] ?? "";
    }
    return toString();
  }
}
