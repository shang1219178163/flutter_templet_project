// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';

class AppColor {
  /// 是否暗黑模式
  static bool get isDark => AppThemeService().isDark;

  /// 纯白
  static const Color white = Color(0xFFFFFFFF);

  /// 纯黑
  static const Color black = Color(0xFF000000);

  /// 透明
  static const Color transparent = Colors.transparent;

  /// 品牌主色
  static const Color primary = Colors.blueAccent;

  /// 错误/危险
  static const Color error = Color(0xFFD32F2F);

  /// 当前反色
  static Color get inverse => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);

  /// 当前主题页面背景
  static Color get page => isDark ? const Color(0xFF181818) : const Color(0xFFF6F6F6);

  /// 当前主题卡片/表面
  static Color get card => isDark ? const Color(0xFF242434) : const Color(0xFFFFFFFF);

  /// 当前主题主文本
  static Color get text => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);

  /// 当前主题次要文本
  static Color get textSecondary => isDark ? const Color(0x99FFFFFF) : const Color(0x99000000);

  /// 当前主题提示/占位
  static Color get textHint => isDark ? const Color(0x4cFFFFFF) : const Color(0x4c000000);

  /// 当前主题分割线
  static Color get divider => isDark ? const Color(0x0FFFFFFF) : const Color(0xFFE4E4E4);

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
