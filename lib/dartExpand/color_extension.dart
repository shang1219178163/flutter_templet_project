//
//  color_extension.dart
//  fluttertemplet
//
//  Created by shang on 7/16/21 2:08 PM.
//  Copyright © 7/16/21 shang. All rights reserved.
//


import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

extension ColorExt on Color{

  static Color random() {
    return Color.fromRGBO(
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256), 1);
  }

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
