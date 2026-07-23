//
//  W3ThemeColor.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/23.
//  Copyright © 2026/7/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// W3 Schools 主题色
enum W3ThemeColor {
  /// 红色
  red(name: "red", desc: "#F44336", color: Color(0xFFF44336)),

  /// 粉色
  pink(name: "pink", desc: "#E91E63", color: Color(0xFFE91E63)),

  /// 紫色
  purple(name: "purple", desc: "#9C27B0", color: Color(0xFF9C27B0)),

  /// 深紫色
  deepPurple(name: "deep-purple", desc: "#673AB7", color: Color(0xFF673AB7)),

  /// 靛蓝色
  indigo(name: "indigo", desc: "#3F51B5", color: Color(0xFF3F51B5)),

  /// 蓝色
  blue(name: "blue", desc: "#2196F3", color: Color(0xFF2196F3)),

  /// 浅蓝色
  lightBlue(name: "light-blue", desc: "#87CEEB", color: Color(0xFF87CEEB)),

  /// 青色
  cyan(name: "cyan", desc: "#00BCD4", color: Color(0xFF00BCD4)),

  /// 蓝绿色
  teal(name: "teal", desc: "#009688", color: Color(0xFF009688)),

  /// 绿色
  green(name: "green", desc: "#4CAF50", color: Color(0xFF4CAF50)),

  /// 浅绿色
  lightGreen(name: "light-green", desc: "#8BC34A", color: Color(0xFF8BC34A)),

  /// 酸橙色
  lime(name: "lime", desc: "#CDDC39", color: Color(0xFFCDDC39)),

  /// 卡其色
  khaki(name: "khaki", desc: "#F0E68C", color: Color(0xFFF0E68C)),

  /// 黄色
  yellow(name: "yellow", desc: "#FFEB3B", color: Color(0xFFFFEB3B)),

  /// 琥珀色
  amber(name: "amber", desc: "#FFC107", color: Color(0xFFFFC107)),

  /// 橙色
  orange(name: "orange", desc: "#FF9800", color: Color(0xFFFF9800)),

  /// 深橙色
  deepOrange(name: "deep-orange", desc: "#FF5722", color: Color(0xFFFF5722)),

  /// 蓝灰色
  blueGrey(name: "blue-grey", desc: "#607D8B", color: Color(0xFF607D8B)),

  /// 棕色
  brown(name: "brown", desc: "#795548", color: Color(0xFF795548)),

  /// 灰色
  grey(name: "grey", desc: "#9E9E9E", color: Color(0xFF9E9E9E)),

  /// 深灰色
  darkGrey(name: "dark-grey", desc: "#616161", color: Color(0xFF616161));

  const W3ThemeColor({
    required this.name,
    required this.desc,
    required this.color,
  });

  /// 主题色名称
  final String name;

  /// 十六进制色值描述
  final String desc;

  /// 颜色值
  final Color color;

  /// 根据名称解析
  static W3ThemeColor? fromName(String? name) {
    if (name == null || name.isEmpty) {
      return null;
    }
    for (final e in W3ThemeColor.values) {
      if (e.name == name) {
        return e;
      }
    }
    return null;
  }
}
