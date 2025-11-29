import 'package:flutter/material.dart';

/// 深/浅/跟随模式切换枚举值
enum AppThemeMode {
  system(ThemeMode.system, '跟随系统模式'),

  light(ThemeMode.light, '跑步'),

  dark(ThemeMode.dark, '攀登'),

  systemLight(ThemeMode.light, '跟随系统模式下的浅色'),

  systemDark(ThemeMode.dark, '跟随系统模式下的深色'),
  ;

  const AppThemeMode(
    this.value,
    this.desc,
  );

  /// 当前枚举值对应的 int 值(非 index)
  final ThemeMode value;

  /// 当前枚举对应的 描述文字
  final String desc;

  /// 跟随系统模式
  bool get isSystem => [AppThemeMode.system, AppThemeMode.systemLight, AppThemeMode.systemDark].contains(this);

  /// 相反主题
  AppThemeMode get inverse {
    var result = AppThemeMode.light;
    switch (this) {
      case AppThemeMode.system:
        {
          var isDarkSystem = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
          result = isDarkSystem ? AppThemeMode.systemLight : AppThemeMode.systemDark;
        }
        break;
      case AppThemeMode.systemLight:
      case AppThemeMode.light:
        {
          result = AppThemeMode.dark;
        }
        break;
      case AppThemeMode.systemDark:
      case AppThemeMode.dark:
        {
          result = AppThemeMode.light;
        }
        break;
      default:
        break;
    }
    return result;
  }

  @override
  String toString() {
    return '$desc is $value';
  }
}
