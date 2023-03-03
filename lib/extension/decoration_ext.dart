//
//  BoxDecorationExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/25/21 2:01 PM.
//  Copyright © 10/25/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///默认 3D 阴影
const shadow3D = [
  const Shadow(
    offset: Offset(4.0, 4.0),
    blurRadius: 3.0,
    color: Color.fromARGB(99, 64, 64, 64),
  ),
  const Shadow(
    offset: Offset(1.0, 1.0),
    blurRadius: 8.0,
    color: Colors.grey,
  ),
];


/// 外观样式
enum IndicatorStyle{
  topLine,
  bottomLine,
  box
}

extension on BoxDecoration{

  // lineDecoration() {
  //   return BoxDecoration(
  //     // color: Colors.green,
  //     border: Border.all(
  //       color: Colors.red,
  //     ),
  //   );
  // }

}

extension BorderExt on Border{

  /// 扩展方法
  static Border create({
    required IndicatorStyle indicatorStyle,
    Color color = Colors.blue,
    double width = 2,
    BorderStyle style = BorderStyle.solid
  }) {

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

extension BorderRadiusExt on BorderRadius{

  //doule 转 BorderRadius
  static BorderRadius fromRadius({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  /// 根据函数转化
  BorderRadius convert(Radius Function(Radius value) cb) {
    return BorderRadius.only(
      topLeft: cb(this.topLeft),
      topRight: cb(this.topRight),
      bottomLeft: cb(this.bottomLeft),
      bottomRight: cb(this.bottomRight),
    );
  }
}

