// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const MaterialColor white = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

// ///主色调
// const MaterialColor primary = MaterialColor(
//   Colors.blueAccent,
//   <int, Color>{
//     50:  Colors.blueAccent.withOpacity(0.5), // 一般用于提交按钮的不可点击
//   },
// );

///背景色 #F3F3F3
const MaterialColor bgColor = MaterialColor(
  0xffF3F3F3,
  <int, Color>{
    10: Color(0xffF9F9F9),
    20: Color(0xffF0F0F0),
    30: Color(0xffBCBFC2),
    50: Color(0xff5B626B),
    100: Color(0xFF000000),
  },
);

///字体色 #181818
const MaterialColor fontColor = MaterialColor(
  0xff181818, // 主色
  <int, Color>{
    10: Color(0xffBCBFC2),
    15: Color(0xFFB3B3B3),
    20: Color(0xff777777), // 777
    30: Color(0xff999999), // placeHolder一类的字体色
    40: Color(0xff333333), // 333
    50: Color(0xff5B626B), // 中间色
    60: Color(0xff444444), // 444
    70: Color(0xff111111), // 111
    100: Color(0xFF000000),
  },
);

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
