//
//  APPThemeSettings.dart
//  flutter_templet_project
//
//  Created by shang on 7/14/21 2:18 PM.
//  Copyright © 7/14/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/button/AppButtonTheme.dart';
import 'package:flutter_templet_project/basicWidget/n_seed_color_box.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/NAppTheme.dart';
import 'package:flutter_templet_project/util/theme/NDialogTheme.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class AppThemeService {
  AppThemeService._() {
    _init();
  }
  factory AppThemeService() => _instance;
  static final AppThemeService _instance = AppThemeService._();

  VoidCallback? onThemeChanged;
  static const _legacyThemeModeKey = "themeModel";

  Color seedColor = AppColor.primary;
  Brightness brightness = Brightness.light;
  ThemeMode _themeMode = ThemeMode.system;

  bool get isDark => brightness == Brightness.dark;

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    if (_themeMode == value) {
      return;
    }
    _themeMode = value;
    brightness = _brightnessOf(_themeMode);
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    _syncToGet();
    Get.changeThemeMode(_themeMode);
    _save();
  }

  SystemUiOverlayStyle get overlayStyle {
    // light 预设 = 浅色图标（深色/品牌色顶栏）；dark 预设 = 深色图标（浅色顶栏）
    return (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: isDark ? AppColor.backgroundDark : AppColor.white,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );
  }

  void _init() {
    final cacheColorStr = CacheService().getString(CacheKey.seedColor.name);
    if (cacheColorStr != null) {
      seedColor = ColorExt.fromHex(cacheColorStr) ?? Colors.blue;
    }
    _themeMode = _loadThemeMode();
    brightness = _brightnessOf(_themeMode);
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    DLog.d([this, cacheColorStr, seedColor, brightness, themeMode].asMap());
  }

  Brightness _brightnessOf(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  ThemeMode _loadThemeMode() {
    final modeName = CacheService().getString(CacheKey.themeMode.name);
    final target = ThemeMode.values.where((e) => e.name == modeName).firstOrNull;
    if (modeName != null && target != null) {
      return target;
    }
    final oldIndex = CacheService().getInt(_legacyThemeModeKey);
    if (oldIndex != null && oldIndex >= 0 && oldIndex < ThemeMode.values.length) {
      return ThemeMode.values[oldIndex];
    }
    final cacheBrightness = CacheService().getString(CacheKey.brightness.name);
    if (cacheBrightness != null) {
      return cacheBrightness.contains("light") ? ThemeMode.light : ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  void _save() {
    CacheService().setString(CacheKey.seedColor.name, seedColor.toHex());
    CacheService().setString(CacheKey.brightness.name, brightness.toString());
    CacheService().setString(CacheKey.themeMode.name, _themeMode.name);
  }

  void _syncToGet() {
    final controller = Get.rootController;
    controller.theme = lightTheme;
    controller.darkTheme = darkTheme;
    controller.update();
    onThemeChanged?.call();
  }

  void applySeedColor(Color color) {
    seedColor = color;
    _syncToGet();
    _save();
  }

  void toggleTheme() {
    themeMode = Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  ThemeData get lightTheme => buildTheme(Brightness.light);

  ThemeData get darkTheme => buildTheme(Brightness.dark);

  /// Material 3 配色源：组件优先读 [ColorScheme]，再覆盖组件 Theme。
  ///
  /// - 以 [ColorScheme.fromSeed] 生成完整 M3 色板
  /// - 强制品牌 [seedColor] 为 primary/secondary，避免 fromSeed 偏紫/暗色提亮
  /// - [surfaceTint] 置透明，避免 Card/AppBar 等叠加色调
  ColorScheme buildColorScheme(Brightness brightness) {
    // 基于种子颜色和亮度生成配色方案
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    // 暗色 surface 用中性灰 0xFF242424（R=G=B），避免旧值 0xFF242434 发紫。
    final isDark = brightness == Brightness.dark;
    final surfaceBase = isDark ? AppColor.cardDark : AppColor.cardLight;
    final primaryContainer = Color.alphaBlend(
      seedColor.withValues(alpha: isDark ? 0.24 : 0.12),
      surfaceBase,
    );
    if (isDark) {
      // surface* 全部中性化：M3 BottomNavigationBar 默认用 surfaceContainer，fromSeed 蓝色会偏紫
      return baseScheme.copyWith(
        primary: seedColor,
        onPrimary: Colors.white,
        primaryContainer: primaryContainer,
        onPrimaryContainer: Colors.white,
        secondary: seedColor,
        onSecondary: Colors.white,
        secondaryContainer: seedColor.withValues(alpha: 0.2),
        onSecondaryContainer: seedColor,
        tertiary: seedColor,
        onTertiary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        inversePrimary: seedColor,
        surface: surfaceBase,
        onSurface: Colors.white,
        onSurfaceVariant: Colors.white.withValues(alpha: 0.6),
        surfaceBright: const Color(0xFF2C2C2C),
        surfaceDim: const Color(0xFF1A1A1A),
        surfaceContainerLowest: const Color(0xFF1A1A1A),
        surfaceContainerLow: surfaceBase,
        surfaceContainer: surfaceBase,
        surfaceContainerHigh: const Color(0xFF2C2C2C),
        surfaceContainerHighest: const Color(0xFF333333),
        outline: Colors.white.withValues(alpha: 0.12),
        outlineVariant: Colors.white.withValues(alpha: 0.08),
        surfaceTint: Colors.transparent,
      );
    }

    return baseScheme.copyWith(
      primary: seedColor,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: seedColor,
      secondary: seedColor,
      onSecondary: Colors.white,
      secondaryContainer: seedColor.withValues(alpha: 0.2),
      onSecondaryContainer: seedColor,
      tertiary: seedColor,
      onTertiary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      inversePrimary: seedColor,
      surface: surfaceBase,
      onSurface: Colors.black,
      onSurfaceVariant: Colors.black.withValues(alpha: 0.6),
      surfaceBright: surfaceBase,
      surfaceDim: const Color(0xFFF6F6F6),
      surfaceContainerLowest: surfaceBase,
      surfaceContainerLow: surfaceBase,
      surfaceContainer: surfaceBase,
      surfaceContainerHigh: const Color(0xFFF6F6F6),
      surfaceContainerHighest: const Color(0xFFF7F7F7),
      outline: const Color(0xFFE4E4E4),
      outlineVariant: const Color(0xFFE4E4E4),
      surfaceTint: Colors.transparent,
    );
  }

  /// 基于 [buildColorScheme] 构建主题；组件 Theme 仅做结构/交互次级覆盖。
  ThemeData buildTheme(Brightness brightness) {
    final colorScheme = buildColorScheme(brightness);
    final isLight = brightness == Brightness.light;
    final onPrimary = colorScheme.onPrimary;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      platform: TargetPlatform.iOS,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      scaffoldBackgroundColor: isLight ? AppColor.backgroundLight : AppColor.backgroundDark,
      cardColor: isLight ? AppColor.cardLight : AppColor.cardDark,
      // —— 组件 Theme（次级）：颜色尽量取自 colorScheme ——
      indicatorColor: onPrimary,
      dividerColor: colorScheme.outlineVariant,
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: 0.5,
        thickness: 1,
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: onPrimary,
        labelColor: onPrimary,
        unselectedLabelColor: onPrimary.withValues(alpha: 0.7),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: onPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: onPrimary,
        ),
        toolbarTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onPrimary,
        ),
        iconTheme: IconThemeData(color: onPrimary, size: 24.0),
        actionsIconTheme: IconThemeData(
          color: onPrimary,
          size: 24.0,
          opacity: 0.8,
        ),
      ),
      badgeTheme: BadgeThemeData(
        offset: const Offset(-1, -4),
        largeSize: 20,
        smallSize: 20,
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
        textStyle: TextStyle(
          fontWeight: isLight ? FontWeight.w500 : FontWeight.w600,
          color: colorScheme.onError,
          fontSize: 11,
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        height: isLight ? null : 60,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        indicatorColor: colorScheme.primaryContainer,
      ),
      canvasColor: colorScheme.surface,
      chipTheme: ChipThemeData(
        pressElevation: 0,
        elevation: 0,
        showCheckmark: false,
        side: BorderSide.none,
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.secondaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurface),
      ),
      // 按钮色交给 colorScheme；仅关闭水波纹与 elevation
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
        ).merge(buildButtonStyle()),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
        ).merge(buildButtonStyle()),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
        ).merge(buildButtonStyle()),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
        ).merge(buildButtonStyle()),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: const CircleBorder(),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withValues(alpha: 0.3),
        selectionHandleColor: colorScheme.primary,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isLight ? const Color(0xFF313135) : colorScheme.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: isLight ? const Color(0xFF313135) : colorScheme.onSurface,
        ),
        iconColor: isLight ? const Color(0xFF313135) : colorScheme.onSurface,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isLight ? colorScheme.surface : const Color(0xFF212121),
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        modalBackgroundColor: isLight ? colorScheme.surface : const Color(0xFF212121),
        modalElevation: 12,
        shadowColor: Colors.black.withValues(alpha: isLight ? 0.2 : 0.7),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        showDragHandle: false,
        dragHandleColor: colorScheme.primary,
        dragHandleSize: const Size(40, 6),
        clipBehavior: Clip.none,
        constraints: const BoxConstraints(
          minHeight: 100,
          maxHeight: 400,
          minWidth: double.infinity,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        thumbColor: colorScheme.primary,
        overlayColor: Colors.grey,
        overlayShape: SliderComponentShape.noOverlay,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        focusColor: colorScheme.surfaceContainerHighest,
        hoverColor: colorScheme.surfaceContainerHighest,
        hintStyle: TextStyle(
          fontSize: 14,
          color: colorScheme.onSurface.withValues(alpha: 0.4),
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
          fontSize: 14,
          color: colorScheme.error.withValues(alpha: 0.9),
          fontWeight: FontWeight.w400,
        ),
        prefixIconColor: const Color(0xFF7C7C85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 1,
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 1,
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 1,
            color: colorScheme.primary.withValues(alpha: 0.4),
          ),
        ),
      ),
      extensions: [
        if (isLight) ...?appThemeDataExtensions(),
        AppButtonTheme(
          bgColor: Colors.green,
          bgColorDisabled: isLight ? Colors.black.withValues(alpha: 0.1) : const Color(0xFF1F1F1F),
          fgColor: isLight ? Colors.white : const Color(0xFF0a3723),
          fgColorDisabled: isLight ? Colors.grey : const Color(0xFF6c6c6c),
        ),
      ],
    );
  }

  /// 初始化配置
  Iterable<ThemeExtension<dynamic>>? appThemeDataExtensions() {
    final appTheme = NAppTheme(
      primary: const Color(0xFF00B451),
      primary2: const Color(0xFF00B451).withValues(alpha: 0.8),
      bgColor: const Color(0xFFF3F3F3),
      fontColor: const Color(0xFF1A1A1A),
      titleStyle: const TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 18,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none,
      ),
      textStyle: const TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.none,
      ),
      cancelColor: const Color(0xFFE65F55),
      lineColor: const Color(0xffE4E4E4),
      borderColor: const Color(0xFFE5E5E5),
      disabledColor: const Color(0xffB3B3B3),
    );
    return [
      appTheme,
      NDialogTheme(
        width: 368,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        titleStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: appTheme.fontColor,
          decoration: TextDecoration.none,
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: appTheme.fontColor,
          decoration: TextDecoration.none,
        ),
      ),
    ];
  }

  /// 自定义行为
  ButtonStyle buildButtonStyle() {
    return ButtonStyle(elevation: WidgetStateProperty.resolveWith<double>((states) {
      if (states.contains(WidgetState.pressed)) {
        return 0; // 点击时阴影隐藏
      }
      return 0; // 正常时阴影隐藏
    }));
  }

  /// 选择主题
  Future showSeedColorPicker({
    required BuildContext context,
    ValueChanged<Color>? onColorChanged,
    ValueChanged<Brightness>? onBrightnessChanged,
    bool dismiss = true,
  }) {
    final colors = <Color>[
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
      Colors.deepPurple,
      Colors.lime,
      Colors.amber,
    ];
    final primary = Theme.of(context).colorScheme.primary;
    final currIndex = colors.indexOf(primary).clamp(0, colors.length - 1);
    // DLog.d(currIndex);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minHeight: 200,
        maxHeight: 500,
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                NSeedColorBox(
                  items: colors,
                  index: currIndex,
                  onColorChanged: (v) async {
                    if (dismiss) {
                      Navigator.of(context).pop();
                    }
                    onColorChanged?.call(v);
                    applySeedColor(v);
                  },
                  brightness: brightness,
                  onBrightnessChanged: (v) async {
                    if (dismiss) {
                      Navigator.of(context).pop();
                    }
                    onBrightnessChanged?.call(v);
                    toggleTheme();
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
