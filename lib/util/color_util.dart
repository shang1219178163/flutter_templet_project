// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const white = Color(0xFFFFFFFF);

// ///主色调
// const MaterialColor primary = Colors.blueAccent;

/// 默认字体颜色 #1A1A1A
const fontColor = Color(0xFF1A1A1A);
const fontColor181818 = Color(0xff181818);
const fontColorBCBFC2 = Color(0xffBCBFC2);
const fontColor333333 = Color(0xff333333);
const fontColor5D6D7E = Color(0xff5D6D7E);
const fontColor737373 = Color(0xff737373);
const fontColor777777 = Color(0xff777777);
const fontColor999999 = Color(0xff999999);
const fontColorB3B3B3 = Color(0xffB3B3B3);
const fontColorF9F9F9 = Color(0xffF9F9F9);

///背景色 #F3F3F3
const bgColor = Color(0xffF3F3F3);
const bgColorEDEDED = Color(0xffEDEDED);
const bgColorF3F3F3 = Color(0xffF3F3F3);
const bgColorF7F7F7 = Color(0xFFF7F7F7);
const bgColorF9F9F9 = Color(0xffF9F9F9);
const bgColor000000 = Color(0xFF000000);

///线条 #EEEEEE
const MaterialColor lineColor = MaterialColor(
  // 0xffEEEEEE,
  0xffF3F3F3,
  <int, Color>{},
);

///阴影 #B5B5B5
const MaterialColor shadowColor = MaterialColor(
  0x1AB5B5B5,
  <int, Color>{
    10: Color(0xffDBDBDB),
    20: Color(0xff999999), // 不可编辑
    50: Color(0xff5B626B), // 中间色
    100: Color(0xFF000000),
  },
);

class HiColor {
  static const Color red = Color(0xFFFF4759);
  static const Color dark_red = Color(0xFFE03E4E);
  static const Color dark_bg = Color(0xFF18191A);
  static const Color status_stay = Color(0xFFF57B25);
  static const Color status_stay_bg = Color(0xFFFFF9F0);
  static const Color status_in = Color(0xFF40B31B);
  static const Color status_in_bg = Color(0xFFEBF7E8);
  static const Color status_err = Color(0xFFF23041);
  static const Color status_err_bg = Color(0xFFFDEAEC);
  static const Color status_normal = Color(0xFF1D7AFF);
  static const Color status_normal_bg = Color(0xFFE8F1FF);

  /// 女性图标颜色
  static const Color femaleColor = Color(0xFFFF7E6E);
}
