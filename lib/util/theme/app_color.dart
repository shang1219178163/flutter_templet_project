// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';

class AppColor {
  /// 是否暗黑模式
  static bool get isDark => AppThemeService().isDark;

  /// 品牌主色
  static const Color primary = Colors.blueAccent;

  /// 透明
  static const Color transparent = Colors.transparent;

  /// 纯白
  static const Color white = Color(0xFFFFFFFF);

  /// 纯黑
  static const Color black = Color(0xFF000000);

  /// 页面底（浅色）#F6F6F6
  static const Color backgroundLight = Color(0xFFF6F6F6);

  /// 页面底（深色）#181818
  static const Color backgroundDark = Color(0xFF181818);

  /// 卡片底（浅色）纯白
  static const Color cardLight = Color(0xFFFFFFFF);

  /// 卡片底（深色）#242434
  static const Color cardDark = Color(0xFF242434);

  /// 主文字（浅色）纯黑
  static const Color textLight = Color(0xFF000000);

  /// 主文字（深色）纯白
  static const Color textDark = Color(0xFFFFFFFF);

  /// 次要文字（浅色）60% 黑
  static const Color textSecondaryLight = Color(0x99000000);

  /// 次要文字（深色）60% 白
  static const Color textSecondaryDark = Color(0x99FFFFFF);

  /// 提示文字（浅色）30% 黑
  static const Color textHintLight = Color(0x4c000000);

  /// 提示文字（深色）30% 白
  static const Color textHintDark = Color(0x4cFFFFFF);

  /// 分割线（浅色）#E4E4E4
  static const Color dividerLight = Color(0xFFE4E4E4);

  /// 分割线（深色）6% 白
  static const Color dividerDark = Color(0x0FFFFFFF);

  /// 错误/危险
  static const Color error = Color(0xFFD32F2F);

  /// 反色, isDark ? Colors.white : Colors.black;
  static Color get inverseColor => isDark ? Colors.white : Colors.black;

  /// 当前页面底色
  static Color get background => isDark ? backgroundDark : backgroundLight;

  /// 当前卡片底色
  static Color get card => isDark ? cardDark : cardLight;

  /// 当前主文字色
  static Color get text => isDark ? textDark : textLight;

  /// 当前次要文字色
  static Color get textSecondary => isDark ? textSecondaryDark : textSecondaryLight;

  /// 当前提示文字色
  static Color get textHint => isDark ? textHintDark : textHintLight;

  /// 当前分割线色
  static Color get divider => isDark ? dividerDark : dividerLight;

  /// 默认字体色 #1A1A1A
  static const Color font = Color(0xFF1A1A1A);

  /// 字体色 #181818
  static const Color font181818 = Color(0xff181818);

  /// 字体色 #BCBFC2
  static const Color fontBCBFC2 = Color(0xffBCBFC2);

  /// 字体色 #333333
  static const Color font333333 = Color(0xff333333);

  /// 字体色 #5D6D7E
  static const Color font5D6D7E = Color(0xff5D6D7E);

  /// 字体色 #666666
  static const Color font666666 = Color(0xff666666);

  /// 字体色 #737373
  static const Color font737373 = Color(0xff737373);

  /// 字体色 #777777
  static const Color font777777 = Color(0xff777777);

  /// 字体色 #999999
  static const Color font999999 = Color(0xff999999);

  /// 字体色 #B3B3B3
  static const Color fontB3B3B3 = Color(0xffB3B3B3);

  /// 字体色 #F9F9F9
  static const Color fontF9F9F9 = Color(0xffF9F9F9);

  /// 默认背景 #F3F3F3
  static const Color bg = Color(0xffF3F3F3);

  /// 背景 #EDEDED
  static const Color bgEDEDED = Color(0xffEDEDED);

  /// 背景 #F3F3F3
  static const Color bgF3F3F3 = Color(0xffF3F3F3);

  /// 背景 #F7F7F7
  static const Color bgF7F7F7 = Color(0xFFF7F7F7);

  /// 背景 #F9F9F9
  static const Color bgF9F9F9 = Color(0xffF9F9F9);

  /// 背景纯黑
  static const Color bg000000 = Color(0xFF000000);

  /// 阴影（3% 黑）
  static const Color shadow = Color(0x08000000);

  /// 效果展示页色点，null 表示主题默认
  static const colorOptions = <Color?>[
    null,
    Colors.white,
    Colors.black,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.red,
    Colors.pink,
    Colors.deepPurple,
  ];

// static const Color primary = Color(0xFF1565C0);
// static const Color primaryLight = Color(0xFF1E88E5);
// static const Color primaryDark = Color(0xFF0D47A1);
// static const Color secondary = Color(0xFFFF6F00);
// static const Color surface = Color(0xFFF5F5F5);
// static const Color background = Color(0xFFFFFFFF);
// static const Color textPrimary = Color(0xFF212121);
// static const Color textSecondary = Color(0xFF757575);
// static const Color textHint = Color(0xFFBDBDBD);
// static const Color error = Color(0xFFD32F2F);
// static const Color success = Color(0xFF2E7D32);
// static const Color divider = Color(0xFFE4E4E4);
}
