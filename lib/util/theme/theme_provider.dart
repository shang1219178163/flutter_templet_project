import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider._() {
    AppThemeService().onThemeChanged = notifyListeners;
  }
  factory ThemeProvider() => _instance;
  static final ThemeProvider _instance = ThemeProvider._();
  static ThemeProvider get instance => _instance;

  AppThemeService get _theme => AppThemeService();

  ThemeMode get themeMode => _theme.themeMode;
  set themeMode(ThemeMode v) => _theme.themeMode = v;

  /// 指定 [mode] 时切到该模式；省略则在 light/dark 间切换。
  void toggleTheme([ThemeMode? mode]) {
    themeMode = mode ?? (isDark ? ThemeMode.light : ThemeMode.dark);
  }
  bool get isDark => _theme.isDark;
  Color get primary => _theme.seedColor;

  Color get itemBgColor => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
  Color get titleColor => isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF313135);
  Color get subtitleColor => isDark ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF7C7C85);
  Color get placeholderColor => isDark ? Colors.white.withValues(alpha: 0.4) : const Color(0xFFA7A7AE);
  Color get arrowColor => isDark ? Colors.white.withValues(alpha: 0.5) : const Color(0xFFA7A7AE);
  Color get lineColor => isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFDEDEDE);
  Color get borderColor => isDark ? Colors.white.withValues(alpha: 0.04) : Colors.transparent;
  Color get color181829OrF6F6F6 => isDark ? const Color(0xFF181829) : const Color(0xFFF6F6F6);
  Color get color242434OrF6F6F6 => isDark ? const Color(0xFF242434) : const Color(0xFFF6F6F6);
  Color get color242434OrWhite => isDark ? const Color(0xFF242434) : Colors.white;
}
