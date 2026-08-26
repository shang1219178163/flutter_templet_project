// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';

class AppColor {
  /// 方便浅色主题适配
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  ///主色调
  static const Color primary = Colors.blueAccent;
  static const Color pageLight = Color(0xFFF6F6F6);
  static const Color pageDark = Color(0xFF181818);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF242434);
  static const Color textLight = Color(0xFF000000);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0x99000000);
  static const Color textSecondaryDark = Color(0x99FFFFFF);
  static const Color textHintLight = Color(0x4c000000);
  static const Color textHintDark = Color(0x4cFFFFFF);
  static const Color dividerLight = Color(0xFFE4E4E4);
  static const Color dividerDark = Color(0x0FFFFFFF);
  static const Color error = Color(0xFFD32F2F);

  static Color page = AppThemeService().isDark ? pageDark : pageLight;
  static Color card = AppThemeService().isDark ? cardDark : cardLight;
  static Color text = AppThemeService().isDark ? textDark : textLight;
  static Color textSecondary = AppThemeService().isDark ? textSecondaryDark : textSecondaryLight;
  static Color textHint = AppThemeService().isDark ? textHintDark : textHintLight;
  static Color divider = AppThemeService().isDark ? dividerDark : dividerLight;

  /// 默认字体颜色 #1A1A1A
  static const Color font = Color(0xFF1A1A1A);
  static const Color font181818 = Color(0xff181818);
  static const Color fontBCBFC2 = Color(0xffBCBFC2);
  static const Color font333333 = Color(0xff333333);
  static const Color font5D6D7E = Color(0xff5D6D7E);
  static const Color font666666 = Color(0xff666666);
  static const Color font737373 = Color(0xff737373);
  static const Color font777777 = Color(0xff777777);
  static const Color font999999 = Color(0xff999999);
  static const Color fontB3B3B3 = Color(0xffB3B3B3);
  static const Color fontF9F9F9 = Color(0xffF9F9F9);

  ///背景色 #F3F3F3
  static const Color bg = Color(0xffF3F3F3);
  static const Color bgEDEDED = Color(0xffEDEDED);
  static const Color bgF3F3F3 = Color(0xffF3F3F3);
  static const Color bgF7F7F7 = Color(0xFFF7F7F7);
  static const Color bgF9F9F9 = Color(0xffF9F9F9);
  static const Color bg000000 = Color(0xFF000000);

  /// 阴影 #B5B5B5
  static const Color shadow = Color(0x08000000);

  /// 效果展示页色点，含 null 表示主题默认
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
