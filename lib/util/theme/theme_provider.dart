import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';

class ThemeProvider extends ChangeNotifier {
  static final ThemeProvider _instance = ThemeProvider._();
  ThemeProvider._() {
    init();
  }
  factory ThemeProvider() => _instance;
  static ThemeProvider get instance => _instance;

  static const themeKey = "themeModel"; // 存储 key

  init() {
    ThemeMode themeMode = ThemeMode.values[_loadThemeFromPreferences()];
    toggleTheme(themeMode);
  }

  // 当前主题索引
  late ThemeMode themeMode;

  bool get isDark => themeMode == ThemeMode.dark;

  /// 当前主题模型
  ThemeDataModel get themeDataModel => themeDataModels.firstWhere((e) => e.value == themeMode);

  /// 主题模型数据
  List<ThemeDataModel> themeDataModels = [
    ThemeDataModel(
      icon: "assets/images/ic_mode_day_black.png",
      example: "assets/images/ic_mode_dark_example.png",
      name: "深色",
      value: ThemeMode.dark,
    ),
    ThemeDataModel(
      icon: "assets/images/ic_mode_night_white.png",
      example: "assets/images/ic_mode_light_example.png",
      name: "浅色",
      value: ThemeMode.light,
    ),
    ThemeDataModel(
      icon: "assets/images/ic_mode_follow_black.png",
      example: "assets/images/ic_mode_follow_example.png",
      name: "跟随系统",
      value: ThemeMode.system,
    ),
  ];

  /// 修改主题
  void toggleTheme(ThemeMode themeModel) {
    themeMode = themeModel;
    notifyListeners();
    CacheService().setInt(themeKey, themeMode.index);
    _setCurrentSystemChrome();
  }

  /// 切换主题
  void exchangeTheme(BuildContext context) {
    // debugPrint("主题切换");
    switch (themeMode) {
      case ThemeMode.system:
        {
          bool isDark = Theme.of(context).brightness == Brightness.dark;
          final model = isDark ? ThemeMode.light : ThemeMode.dark;
          toggleTheme(model);
        }
        break;
      case ThemeMode.light:
        {
          toggleTheme(ThemeMode.dark);
        }
        break;
      case ThemeMode.dark:
        {
          toggleTheme(ThemeMode.light);
        }
        break;
      default:
        break;
    }
  }

  // 获取当前主题
  int _loadThemeFromPreferences() {
    final themeModelIndex = CacheService().getInt(themeKey) ?? 2;
    return themeModelIndex;
  }

  void _setCurrentSystemChrome() {
    if (themeMode == ThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); //home Indicator一直显示
  }

  /// 背景色
  Color get itemBgColor => isDark ? Colors.white.withOpacity(0.05) : Colors.white;

  /// 标题
  Color get titleColor => isDark ? Colors.white.withOpacity(0.9) : Color(0xFF313135);

  /// 副标题
  Color get subtitleColor => isDark ? Colors.white.withOpacity(0.6) : Color(0xFF7C7C85);

  /// 输入框占位颜色
  Color get placeholderColor => isDark ? Colors.white.withOpacity(0.4) : Color(0xFFA7A7AE);

  /// 箭头颜色
  Color get arrowColor => isDark ? Colors.white.withOpacity(0.5) : Color(0xFFA7A7AE);

  /// 分割线颜色
  Color get lineColor => isDark ? Colors.white.withOpacity(0.05) : Color(0xFFDEDEDE);

  /// 边框线
  Color get borderColor => isDark ? Colors.white.withOpacity(0.04) : Colors.transparent;

  /// 兼容老样式
  Color get color181829OrF6F6F6 => isDark ? Color(0xFF181829) : Color(0xFFF6F6F6);

  /// 兼容老样式
  Color get color242434OrWhite => isDark ? Color(0xFF242434) : Colors.white;

  /// 反色, isDark ? Colors.white : Colors.black;
  Color get inverseColor => isDark ? Colors.white : Colors.black;
}

/// 主题模型
class ThemeDataModel {
  ThemeDataModel({
    required this.icon,
    required this.example,
    required this.name,
    required this.value,
  });

  /// 我的页面切换icon
  String icon;

  /// 设置页面弹窗主题设置示意图
  String example;

  /// 文字描述
  String name;

  /// 主题枚举值
  ThemeMode value;

  Map<String, dynamic> toJson() {
    return {
      "color": icon,
      "stop": example,
      "name": name,
      "value": value,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
