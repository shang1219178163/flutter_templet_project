//
//  InputBorder.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/30 09:53.
//  Copyright © 2026/4/30 shang. All rights reserved.
//

import 'package:flutter/material.dart';

extension InputBorderExt on InputBorder {
  /// 创建边框圆角
  static outline({Color color = const Color(0xffDEDEDE), double width = 1, double radius = 4}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(
        color: color, //边线颜色为白色
        width: 1, //边线宽度为1
      ),
    );
  }
}
