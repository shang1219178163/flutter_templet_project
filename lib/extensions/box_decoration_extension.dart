//
//  BoxDecorationExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/25/21 2:01 PM.
//  Copyright © 10/25/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 外观样式
enum IndicatorStyle{
  topLine,
  bottomLine,
  box
}

extension BorderExt on Border{

  /// 扩展方法
  static Border create({
    required IndicatorStyle indicatorStyle,
    Color color = Colors.blue,
    double width = 2,
    BorderStyle style = BorderStyle.solid}) {

    final borderSide = BorderSide(
      color: color,
      width: width,
      style: style,
    );

    var box = Border(
      bottom: borderSide,
    );

    switch (indicatorStyle) {
      case IndicatorStyle.topLine:
        {
          box = Border(
            top: borderSide,
          );
        }
        break;
      case IndicatorStyle.box:
        {
          box = Border(
            top: borderSide,
            left: borderSide,
            right: borderSide,
            bottom: borderSide,
          );
        }
        break;
      default:
        break;
    }
    return box;
  }
}

extension on BoxDecoration{


}

