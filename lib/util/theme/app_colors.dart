// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/// 应用色板：Light/Dark token。页面请用 [Theme.of] `colorScheme`。
///
/// [brightness] 由 [AppThemeService] 写入。
class AppColors {
  static Brightness brightness = Brightness.light;

  static bool get isDark => brightness == Brightness.dark;

  // —— Brand ——

  /// 品牌主色（seed 默认）
  static const Color primary = Colors.blueAccent;

  // —— 基础 ——

  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // —— Surface（页面 / Scaffold）——
  // Dark 对照 One Dark Modern colors: chrome / overlay / elevated

  /// surface 浅色：页面底 #F6F6F6
  static const Color surfaceLight = Color(0xFFF6F6F6);

  /// surface 深色：chrome #21252B
  static const Color surfaceDark = Color(0xFF21252B);

  /// surfaceBright 浅色：最亮表面（白卡）
  static const Color surfaceBrightLight = Color(0xFFFFFFFF);

  /// surfaceBright 深色：elevated #2C313C
  static const Color surfaceBrightDark = Color(0xFF2C313C);

  /// surfaceDim 浅色：最暗表面 #EEEEEE
  static const Color surfaceDimLight = Color(0xFFEEEEEE);

  /// surfaceDim 深色：overlay #1D1F23
  static const Color surfaceDimDark = Color(0xFF1D1F23);

  // —— Surface containers ——
  // Light：Card→Low（白）；输入→Container
  // Dark 单调：Lowest < Low(input) < Container(editor/Card) < High < Highest

  /// surfaceContainerLowest 浅色
  static const Color surfaceContainerLowestLight = Color(0xFFFFFFFF);

  /// surfaceContainerLowest 深色：overlay #1D1F23
  static const Color surfaceContainerLowestDark = Color(0xFF1D1F23);

  /// surfaceContainerLow 浅色：Card
  static const Color surfaceContainerLowLight = Color(0xFFFFFFFF);

  /// surfaceContainerLow 深色：input #252931（低于 Container，输入井）
  static const Color surfaceContainerLowDark = Color(0xFF252931);

  /// surfaceContainer 浅色：默认容器 / 输入底 #F5F5F5
  static const Color surfaceContainerLight = Color(0xFFF5F5F5);

  /// surfaceContainer 深色：editor #282C34（Card）
  static const Color surfaceContainerDark = Color(0xFF282C34);

  /// surfaceContainerHigh 浅色：Dialog / Chip #F0F0F0
  static const Color surfaceContainerHighLight = Color(0xFFF0F0F0);

  /// surfaceContainerHigh 深色：elevated #2C313C（Dialog / 选中底）
  static const Color surfaceContainerHighDark = Color(0xFF2C313C);

  /// surfaceContainerHighest 浅色 #EEEEEE
  static const Color surfaceContainerHighestLight = Color(0xFFEEEEEE);

  /// surfaceContainerHighest 深色：selectionInactive #323842
  static const Color surfaceContainerHighestDark = Color(0xFF323842);

  // —— On surface ——
  // Dark：textBright / text / inactiveForeground / infoForeground

  /// onSurface 浅色：主文字 #1A1A1A
  static const Color onSurfaceLight = Color(0xFF1A1A1A);

  /// onSurface 深色：textBright #D7DAE0
  static const Color onSurfaceDark = Color(0xFFD7DAE0);

  /// 正文（略软于 onSurface）
  static const Color onSurfaceBodyLight = Color(0xFF313135);

  /// 正文深色：text #ABB2BF
  static const Color onSurfaceBodyDark = Color(0xFFABB2BF);

  /// onSurfaceVariant 浅色：次要 #737373
  static const Color onSurfaceVariantLight = Color(0xFF737373);

  /// onSurfaceVariant 深色：inactiveForeground #8B919D
  static const Color onSurfaceVariantDark = Color(0xFF8B919D);

  /// info / Placeholder 浅色（略淡于 onSurfaceVariant）
  static const Color infoLight = Color(0xFF8C8C8C);

  /// info / Placeholder 深色：infoForeground #6F7784
  static const Color infoDark = Color(0xFF6F7784);

  // —— Outline ——
  // Dark：Component.borderColor / separatorColor

  /// outline 浅色：边框（与 divider 拉开）
  static const Color outlineLight = Color(0xFFD0D0D0);

  /// outline 深色：border #3E4452
  static const Color outlineDark = Color(0xFF3E4452);

  /// outlineVariant 浅色：分割线 #E4E4E4
  static const Color outlineVariantLight = Color(0xFFE4E4E4);

  /// outlineVariant 深色：separator #2E323A
  static const Color outlineVariantDark = Color(0xFF2E323A);

  // —— Brand / Focus（One Dark UI）——

  /// 暗色默认强调（Button.default）#3A72D6
  static const Color accentDark = Color(0xFF3A72D6);

  /// 暗色焦点环 / Tab 下划线 #528BFF
  static const Color focusDark = Color(0xFF528BFF);

  // —— Error ——

  /// error 浅色
  static const Color errorLight = Color(0xFFD32F2F);

  /// error 深色：Actions.Red #E06C75
  static const Color errorDark = Color(0xFFE06C75);

  // —— 当前模式 getters（对齐 ColorScheme 角色）——

  static Color get surface => isDark ? surfaceDark : surfaceLight;
  static Color get surfaceBright => isDark ? surfaceBrightDark : surfaceBrightLight;
  static Color get surfaceDim => isDark ? surfaceDimDark : surfaceDimLight;

  static Color get surfaceContainerLowest => isDark ? surfaceContainerLowestDark : surfaceContainerLowestLight;
  static Color get surfaceContainerLow => isDark ? surfaceContainerLowDark : surfaceContainerLowLight;
  static Color get surfaceContainer => isDark ? surfaceContainerDark : surfaceContainerLight;
  static Color get surfaceContainerHigh => isDark ? surfaceContainerHighDark : surfaceContainerHighLight;
  static Color get surfaceContainerHighest => isDark ? surfaceContainerHighestDark : surfaceContainerHighestLight;

  static Color get onSurface => isDark ? onSurfaceDark : onSurfaceLight;
  static Color get onSurfaceBody => isDark ? onSurfaceBodyDark : onSurfaceBodyLight;
  static Color get onSurfaceVariant => isDark ? onSurfaceVariantDark : onSurfaceVariantLight;

  /// Placeholder / infoForeground
  static Color get info => isDark ? infoDark : infoLight;

  static Color get outline => isDark ? outlineDark : outlineLight;
  static Color get outlineVariant => isDark ? outlineVariantDark : outlineVariantLight;

  static Color get error => isDark ? errorDark : errorLight;

  static Color get inverseColor => isDark ? Colors.white : Colors.black;

  // —— 仍在用的旧名 ——
  /// 浅色白卡 / 暗色 editor
  static Color get card => isDark ? surfaceContainer : surfaceContainerLow;
  static Color get divider => outlineVariant;

  // —— 历史硬编码色（业务遗留）——

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

  static const Color bg = Color(0xffF3F3F3);
  static const Color bgEDEDED = Color(0xffEDEDED);
  static const Color bgF3F3F3 = Color(0xffF3F3F3);
  static const Color bgF7F7F7 = Color(0xFFF7F7F7);
  static const Color bgF9F9F9 = Color(0xffF9F9F9);
  static const Color bg000000 = Color(0xFF000000);

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
}
