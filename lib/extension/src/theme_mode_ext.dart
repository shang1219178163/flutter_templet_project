import 'package:flutter/material.dart';

extension ThemeModeExt on ThemeMode {
  /// 当期亮度模式
  Brightness get brightness => switch (this) {
        ThemeMode.light => Brightness.light,
        ThemeMode.dark => Brightness.dark,
        ThemeMode.system => WidgetsBinding.instance.platformDispatcher.platformBrightness,
      };
}
