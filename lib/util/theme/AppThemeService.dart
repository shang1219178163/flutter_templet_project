//
//  APPThemeSettings.dart
//  flutter_templet_project
//
//  Created by shang on 7/14/21 2:18 PM.
//  Copyright © 7/14/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/button/AppButtonTheme.dart';
import 'package:flutter_templet_project/basicWidget/n_seed_color_box.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/extension/src/theme_mode_ext.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/NAppTheme.dart';
import 'package:flutter_templet_project/util/theme/NDialogTheme.dart';
import 'package:flutter_templet_project/util/theme/app_colors.dart';
import 'package:get/get.dart';

class AppThemeService {
  AppThemeService._() {
    _init();
  }
  factory AppThemeService() => _instance;
  static final AppThemeService _instance = AppThemeService._();

  VoidCallback? onThemeChanged;
  static const _legacyThemeModeKey = "themeModel";
  static const _noElevation = WidgetStatePropertyAll<double>(0);
  static const _seedColors = <Color>[
    AppColors.primary,
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

  Color seedColor = AppColors.primary;
  Brightness brightness = Brightness.light;
  ThemeMode _themeMode = ThemeMode.system;

  bool get isDark => brightness == Brightness.dark;

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    if (_themeMode == value) {
      return;
    }
    _bind(value);
    _syncToGet();
    Get.changeThemeMode(_themeMode);
    _save();
  }

  SystemUiOverlayStyle get overlayStyle {
    return (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: isDark ? AppColors.surfaceDark : AppColors.white,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );
  }

  void _bind(ThemeMode mode) {
    _themeMode = mode;
    brightness = mode.brightness;
    AppColors.brightness = brightness;
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  }

  /// Flutter 3.44+ ListTile 会断言祖先 ColoredBox 挡住水波纹。
  /// 本主题已全局 [NoSplash]，该 debug 断言对 UI 无实际影响。
  static bool ignoreFlutterError(FlutterErrorDetails details) {
    return details.exceptionAsString().contains(
      'ListTile background color or ink splashes may be invisible',
    );
  }

  void _init() {
    final cacheColorStr = CacheService().getString(CacheKey.seedColor.name);
    if (cacheColorStr != null) {
      seedColor = ColorExt.fromHex(cacheColorStr) ?? AppColors.primary;
    }
    _bind(_loadThemeMode());
    DLog.d([this, cacheColorStr, seedColor, brightness, themeMode].asMap());
  }

  ThemeMode _loadThemeMode() {
    final modeName = CacheService().getString(CacheKey.themeMode.name);
    final byName = ThemeMode.values.where((e) => e.name == modeName).firstOrNull;
    if (modeName != null && byName != null) {
      return byName;
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
    CacheService().setString(CacheKey.seedColor.name, seedColor.hex);
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

  /// 构建 light/dark Theme 时临时切换 [AppColors.brightness]，保证 getter 与目标模式一致。
  T runWithBrightness<T>(Brightness target, T Function() fn) {
    final prev = AppColors.brightness;
    AppColors.brightness = target;
    try {
      return fn();
    } finally {
      AppColors.brightness = prev;
    }
  }

  ColorScheme buildColorScheme([Brightness? target]) {
    final b = target ?? brightness;
    return runWithBrightness(b, () => _buildColorScheme(b));
  }

  ColorScheme _buildColorScheme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final base = ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
    final onPrimary = seedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final errorContainer = Color.alphaBlend(
      AppColors.error.withValues(alpha: dark ? 0.28 : 0.12),
      AppColors.surfaceContainer,
    );

    return base.copyWith(
      primary: seedColor,
      onPrimary: onPrimary,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: errorContainer,
      onErrorContainer: AppColors.onSurface,
      inversePrimary: seedColor,
      inverseSurface: AppColors.onSurface,
      onInverseSurface: AppColors.surface,
      surface: AppColors.surface,
      surfaceBright: AppColors.surfaceBright,
      surfaceDim: AppColors.surfaceDim,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      surfaceTint: Colors.transparent,
      scrim: Colors.black.withValues(alpha: dark ? 0.6 : 0.32),
      shadow: Colors.black,
    );
  }

  ThemeData buildTheme(Brightness target) => runWithBrightness(target, () => _buildTheme(target));

  CupertinoTextThemeData _cupertinoTextTheme(ColorScheme cs) {
    const t = CupertinoTextThemeData();
    final onSurface = cs.onSurface;
    return CupertinoTextThemeData(
      primaryColor: cs.primary,
      textStyle: t.textStyle.copyWith(color: onSurface),
      tabLabelTextStyle: t.tabLabelTextStyle.copyWith(color: cs.onSurfaceVariant),
      navTitleTextStyle: t.navTitleTextStyle.copyWith(color: onSurface),
      navLargeTitleTextStyle: t.navLargeTitleTextStyle.copyWith(color: onSurface),
      pickerTextStyle: t.pickerTextStyle.copyWith(color: onSurface),
      dateTimePickerTextStyle: t.dateTimePickerTextStyle.copyWith(color: onSurface),
    );
  }

  OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(width: 1, color: color),
  );

  ButtonStyle _flatButton({
    Color? foreground,
    Color? background,
    BorderSide? side,
  }) {
    return ButtonStyle(
      elevation: _noElevation,
      splashFactory: NoSplash.splashFactory,
      foregroundColor: foreground == null ? null : WidgetStatePropertyAll(foreground),
      backgroundColor: background == null ? null : WidgetStatePropertyAll(background),
      side: side == null ? null : WidgetStatePropertyAll(side),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final cs = _buildColorScheme(brightness);
    final dark = brightness == Brightness.dark;
    final onPrimary = cs.onPrimary;
    final hint = TextStyle(fontSize: 14, color: AppColors.info);

    return ThemeData(
      platform: TargetPlatform.iOS,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.surface,
      cardColor: cs.surfaceContainer,
      canvasColor: cs.surface,
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: cs.primary,
        primaryContrastingColor: onPrimary,
        scaffoldBackgroundColor: cs.surface,
        barBackgroundColor: cs.surfaceContainer,
        applyThemeToAll: true,
        textTheme: _cupertinoTextTheme(cs),
      ),
      hintColor: AppColors.info,
      dividerTheme: DividerThemeData(color: cs.outlineVariant, space: 0.5, thickness: 1),
      tabBarTheme: TabBarThemeData(
        indicatorColor: cs.primary,
        labelColor: cs.primary,
        unselectedLabelColor: cs.onSurfaceVariant,
        dividerColor: Colors.transparent,
      ),
      appBarTheme: AppBarThemeData(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: cs.primary,
        foregroundColor: onPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: onPrimary),
        toolbarTextStyle: TextStyle(fontSize: 16, color: onPrimary),
        iconTheme: IconThemeData(color: onPrimary, size: 24),
        actionsIconTheme: IconThemeData(color: onPrimary, size: 24, opacity: 0.8),
      ),
      badgeTheme: const BadgeThemeData(
        offset: Offset(-1, -4),
        largeSize: 20,
        smallSize: 20,
        textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(surfaceTintColor: Colors.transparent),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surfaceContainer,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        indicatorColor: cs.primaryContainer,
        labelTextStyle: WidgetStatePropertyExt.stateValue(
          value: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          selected: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary),
        ),
        iconTheme: WidgetStatePropertyExt.stateValue(
          value: IconThemeData(size: 24, color: cs.onSurfaceVariant),
          selected: IconThemeData(size: 24, color: cs.primary),
        ),
      ),
      chipTheme: ChipThemeData(
        pressElevation: 0,
        elevation: 0,
        showCheckmark: false,
        side: BorderSide.none,
        backgroundColor: cs.surfaceContainerHigh,
        selectedColor: cs.secondaryContainer,
        labelStyle: TextStyle(color: cs.onSurface),
        secondaryLabelStyle: TextStyle(color: cs.onSurfaceVariant),
        deleteIconColor: cs.onSurfaceVariant,
      ),
      textButtonTheme: TextButtonThemeData(style: _flatButton(foreground: cs.primary)),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _flatButton(
          foreground: cs.primary,
          side: BorderSide(color: cs.primary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _flatButton(foreground: onPrimary, background: cs.primary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _flatButton(foreground: onPrimary, background: cs.primary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: CircleBorder(),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: cs.primary.withValues(alpha: dark ? 0.35 : 0.3),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface),
        contentTextStyle: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
        iconColor: cs.onSurface,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surfaceContainerHigh,
        modalBackgroundColor: cs.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        modalElevation: 12,
        shadowColor: Colors.black.withValues(alpha: dark ? 0.7 : 0.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        dragHandleColor: cs.onSurfaceVariant,
        dragHandleSize: const Size(40, 6),
      ),
      sliderTheme: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyExt.stateValue(value: cs.onSurfaceVariant, selected: onPrimary),
        trackColor: WidgetStatePropertyExt.stateValue(value: cs.surfaceContainerHigh, selected: cs.primary),
        trackOutlineColor: WidgetStatePropertyAll(cs.outlineVariant),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: cs.surfaceContainerLow,
        focusColor: cs.surfaceContainerLow,
        hoverColor: cs.surfaceContainerLow,
        hintStyle: hint,
        labelStyle: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
        floatingLabelStyle: TextStyle(fontSize: 14, color: cs.primary),
        prefixIconColor: AppColors.info,
        suffixIconColor: AppColors.info,
        border: _inputBorder(cs.outline),
        enabledBorder: _inputBorder(cs.outline),
        focusedBorder: _inputBorder(cs.primary),
        disabledBorder: _inputBorder(cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: cs.onSurfaceVariant,
        textColor: cs.onSurface,
        subtitleTextStyle: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
        tileColor: Colors.transparent,
        selectedTileColor: Colors.transparent,
      ),
      iconTheme: IconThemeData(color: cs.onSurfaceVariant),
      primaryIconTheme: IconThemeData(color: onPrimary),
      extensions: [
        ..._extensions(),
        AppButtonTheme(
          bgColor: cs.primary,
          bgColorDisabled: cs.surfaceContainerHighest,
          fgColor: onPrimary,
          fgColorDisabled: cs.onSurfaceVariant,
          outlinedColor: cs.primary,
          outlinedColorDisabled: cs.onSurfaceVariant,
        ),
      ],
    );
  }

  List<ThemeExtension<dynamic>> _extensions() {
    return [
      NAppTheme(
        primary: seedColor,
        primary2: seedColor.withValues(alpha: 0.8),
        bgColor: AppColors.surface,
        fontColor: AppColors.onSurface,
        titleStyle: TextStyle(
          color: AppColors.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none,
        ),
        textStyle: TextStyle(
          color: AppColors.onSurfaceBody,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.none,
        ),
        cancelColor: AppColors.error,
        lineColor: AppColors.outlineVariant,
        borderColor: AppColors.outline,
        disabledColor: AppColors.onSurfaceVariant,
      ),
      NDialogTheme(
        width: 368,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        titleStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
          decoration: TextDecoration.none,
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant,
          decoration: TextDecoration.none,
        ),
      ),
    ];
  }

  Future showSeedColorPicker({
    required BuildContext context,
    ValueChanged<Color>? onColorChanged,
    ValueChanged<Brightness>? onBrightnessChanged,
    bool dismiss = true,
  }) {
    void close() {
      if (dismiss) {
        Navigator.of(context).pop();
      }
    }

    final index = _seedColors.indexWhere((c) => c == seedColor).clamp(0, _seedColors.length - 1);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(minHeight: 200, maxHeight: 500),
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: NSeedColorBox(
          items: _seedColors,
          index: index,
          brightness: brightness,
          onColorChanged: (v) {
            close();
            onColorChanged?.call(v);
            applySeedColor(v);
          },
          onBrightnessChanged: (v) {
            close();
            onBrightnessChanged?.call(v);
            themeMode = v == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
          },
        ),
      ),
    );
  }
}
