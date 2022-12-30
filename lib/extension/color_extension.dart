//
//  color_extension.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 2:08 PM.
//  Copyright © 7/16/21 shang. All rights reserved.
//


import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

extension ColorExt on Color{

  ///随机颜色
  static Color get random {
    return Color.fromRGBO(
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256), 1);
  }

  /// 十六进制转颜色
  /// alpha, 透明度 [0.0,1.0]
  static Color? fromHex(String val, {double alpha = 1}) {
    val = val.toUpperCase().replaceAll("#", '');
    val = val.toUpperCase().replaceAll("0x", '');
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
    List<String> list = val.split(",");
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
  Gradient? toGradient() => LinearGradient(colors:[this, this,], stops:[0.0, 1]);

  Color randomOpacity() {
    return this.withOpacity(Random().nextInt(100)/100);
  }

  String get nameDes{
    if (this == Colors.white) {
      return "white";
    }
    if (this == Colors.black) {
      return "black";
    }
    if (this == Colors.pink) {
      return "pink";
    }
    if (this == Colors.purple) {
      return "purple";
    }
    if (this == Colors.deepPurple) {
      return "deepPurple";
    }
    if (this == Colors.indigo) {
      return "indigo";
    }
    if (this == Colors.blue) {
      return "blue";
    }
    if (this == Colors.lightBlue) {
      return "lightBlue";
    }
    if (this == Colors.cyan) {
      return "cyan";
    }
    if (this == Colors.teal) {
      return "teal";
    }
    if (this == Colors.green) {
      return "green";
    }
    if (this == Colors.lightGreen) {
      return "lightGreen";
    }
    if (this == Colors.lime) {
      return "lime";
    }
    if (this == Colors.yellow) {
      return "yellow";
    }
    if (this == Colors.amber) {
      return "amber";
    }
    if (this == Colors.orange) {
      return "orange";
    }
    if (this == Colors.deepOrange) {
      return "deepOrange";
    }
    if (this == Colors.brown) {
      return "brown";
    }
    if (this == Colors.grey) {
      return "grey";
    }
    if (this == Colors.blueGrey) {
      return "blueGrey";
    }
    if (this == Colors.redAccent) {
      return "redAccent";
    }
    if (this == Colors.pinkAccent) {
      return "pinkAccent";
    }
    if (this == Colors.purpleAccent) {
      return "purpleAccent";
    }
    if (this == Colors.deepPurpleAccent) {
      return "deepPurpleAccent";
    }
    if (this == Colors.indigoAccent) {
      return "indigoAccent";
    }
    if (this == Colors.blueAccent) {
      return "blueAccent";
    }
    if (this == Colors.lightBlueAccent) {
      return "lightBlueAccent";
    }
    if (this == Colors.cyanAccent) {
      return "cyanAccent";
    }
    if (this == Colors.tealAccent) {
      return "tealAccent";
    }
    if (this == Colors.greenAccent) {
      return "greenAccent";
    }
    if (this == Colors.lightGreenAccent) {
      return "lightGreenAccent";
    }
    if (this == Colors.limeAccent) {
      return "limeAccent";
    }
    if (this == Colors.yellowAccent) {
      return "yellowAccent";
    }
    if (this == Colors.amberAccent) {
      return "amberAccent";
    }
    if (this == Colors.orangeAccent) {
      return "orangeAccent";
    }
    if (this == Colors.deepOrangeAccent) {
      return "deepOrangeAccent";
    }
    return this.toString();
  }

}
