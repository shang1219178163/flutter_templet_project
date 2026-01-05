//
//  NTabbarDataModel.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/5 17:22.
//  Copyright © 2026/1/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// Tab 数据模型
class NTabbarDataModel {
  NTabbarDataModel({
    required this.title,
    required this.value,
    this.style,
    this.bg,
    this.bgColor,
  });

  String title;
  String value;

  /// 选中时的字体颜色
  TextStyle? style;

  /// 选中时图片背景
  AssetImage? bg;

  /// 选中时图片背景色
  Color? bgColor;

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "style": style,
      "value": value,
      "bg": bg,
      "bgColor": bgColor,
    };
  }

  @override
  String toString() {
    return "$runtimeType: ${toJson()}";
  }
}
