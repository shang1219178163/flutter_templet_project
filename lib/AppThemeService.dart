//
//  APPThemeSettings.dart
//  flutter_templet_project
//
//  Created by shang on 7/14/21 2:18 PM.
//  Copyright © 7/14/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_seed_color_box.dart';
import 'package:flutter_templet_project/basicWidget/theme/n_button_theme.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/util/app_color.dart';
import 'package:get/get.dart';

class AppThemeService {
  static final AppThemeService _instance = AppThemeService._();
  factory AppThemeService() => _instance;

  AppThemeService._() {
    _init();
  }

  _init() {
    final cacheColorStr = CacheService().getString(CacheKey.seedColor.name);
    if (cacheColorStr != null) {
      seedColor = ColorExt.fromHex(cacheColorStr) ?? Colors.blue;
    }

    final cacheBrightness = CacheService().getString(CacheKey.brightness.name);
    if (cacheBrightness != null) {
      brightness = cacheBrightness.contains("light") == true ? Brightness.light : Brightness.dark;
      themeMode = brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
    }
    DLog.d([this, cacheColorStr, seedColor, brightness, themeMode].asMap());
  }

  Future<void> _cacheTheme({required ThemeData result}) async {
    themeMode = result.brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
    await CacheService().setString(CacheKey.seedColor.name, result.colorScheme.primary.toHex());
    await CacheService().setString(CacheKey.brightness.name, result.colorScheme.brightness.toString());
    // _init();
  }

  var themeMode = ThemeMode.system;
  // ThemeMode get themeMode => brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;

  Color seedColor = Colors.blue;
  Brightness brightness = Brightness.light;

  // 基于种子颜色和亮度生成配色方案
  ColorScheme get colorScheme => ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      );

  void changeTheme(ThemeData theme) {
    // Get.changeTheme(Get.isDarkMode ? lightTheme : darkTheme);
    DLog.d("changeTheme $theme");
    Get.changeTheme(theme);
    _cacheTheme(result: theme);
  }

  void toggleTheme() {
    final result = Get.isDarkMode ? lightTheme : darkTheme;
    Get.changeTheme(result);
    _cacheTheme(result: result);
  }

  ThemeData get lightTheme => ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: seedColor, // 主色
          // onPrimary: Colors.black, // 主色上的文字
          // secondary: Color(0xFF03DAC6), // 辅助色
          // onSecondary: Colors.black,
          // error: Color(0xFFCF6679), // 错误色
          // onError: Colors.black,
          // surface: Color(0xFF1E1E1E), // 卡片/底部区域
          // onSurface: Colors.white,
        ),
        platform: TargetPlatform.iOS,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent, // 点击时的高亮效果设置为透明
        highlightColor: Colors.transparent, // 长按时的扩散效果设置为透明
        // primaryColor: seedColor, //主色调为青色
        // indicatorColor: Colors.white,
        // iconTheme: IconThemeData(color: Colors.yellow),//设置icon主题色为黄色
        // textTheme: ThemeData.light().textTheme.copyWith(
        //     button: TextStyle(color: Colors.red)
        // ),//设置文本颜色为红色
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          toolbarTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white, // 图标颜色
            size: 24.0, // 图标大小
            opacity: 0.8, // 图标透明度
          ),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE4E4E4),
          space: 0.5,
          thickness: 1,
        ),
        badgeTheme: const BadgeThemeData(
          offset: Offset(-1, -4),
          largeSize: 20,
          smallSize: 20,
          textColor: Colors.white,
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 11,
          ),
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          surfaceTintColor: Color(0xFFFFFFFF),
          color: Color(0xFFFFFFFF),
        ),
        chipTheme: ChipThemeData(
          pressElevation: 0,
          elevation: 0,
          showCheckmark: false,
          side: BorderSide.none,
        ),
        buttonTheme: ButtonThemeData(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          buttonColor: seedColor,
          focusColor: Colors.transparent,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: seedColor,
          ).merge(buildButtonStyle()),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: seedColor,
          ).merge(buildButtonStyle()),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: seedColor,
          ).merge(buildButtonStyle()),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: seedColor,
          ).merge(buildButtonStyle()),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.black, // 普通文字颜色
              displayColor: Colors.black, // 标题文字颜色
            ),
        // textTheme: const TextTheme(
        //   displayLarge: TextStyle(color: Colors.black, fontSize: 96.0, fontWeight: FontWeight.w300),
        //   displayMedium: TextStyle(color: Colors.black, fontSize: 60.0, fontWeight: FontWeight.w300),
        //   displaySmall: TextStyle(color: Colors.black, fontSize: 48.0, fontWeight: FontWeight.w400),
        //   headlineMedium: TextStyle(color: Colors.black, fontSize: 34.0, fontWeight: FontWeight.w400),
        //   headlineSmall: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w400),
        //   titleLarge: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500),
        //   titleMedium: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),
        //   titleSmall: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
        //   bodyLarge: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),
        //   bodyMedium: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w400),
        //   bodySmall: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w400),
        //   labelLarge: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
        //   labelSmall: TextStyle(color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        // ),
        dialogBackgroundColor: Colors.white,
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          // shadowColor: AppColors.color_242434,
          // elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF313135),
          ),
          contentTextStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xFF313135),
          ),
          iconColor: Color(0xFF313135),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Color(0xFFE3F2FD),
          elevation: 8,
          modalBackgroundColor: Colors.white,
          modalElevation: 12,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          showDragHandle: true,
          dragHandleColor: seedColor,
          dragHandleSize: const Size(40, 6),
          clipBehavior: Clip.antiAlias,
          constraints: const BoxConstraints(
            minHeight: 100,
            maxHeight: 400,
            minWidth: double.infinity,
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: seedColor,
          thumbColor: seedColor,
          overlayColor: Colors.grey,
        ),
        inputDecorationTheme: InputDecorationTheme(
          // isCollapsed: true,
          // contentPadding: const EdgeInsets.symmetric(vertical: 11),
          filled: true,
          fillColor: AppColor.bgColor,
          focusColor: AppColor.bgColor,
          hoverColor: AppColor.bgColor,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.4),
            fontWeight: FontWeight.w400,
          ),
          labelStyle: TextStyle(
            fontSize: 14,
            color: Colors.red.withOpacity(0.9),
            fontWeight: FontWeight.w400,
          ),
          prefixIconColor: Color(0xFF7C7C85),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1,
              color: const Color(0xFFA79AF8).withOpacity(0.1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1,
              color: const Color(0xFFA79AF8).withOpacity(0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1,
              color: const Color(0xFFA79AF8).withOpacity(0.1),
            ),
          ),
        ),
        extensions: appThemeDataExtensions(),
      );

  // ThemeData? darkThemeData;
  ThemeData get darkTheme => ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: seedColor, // 主色
          // onPrimary: Colors.black,      // 主色上的文字
          // secondary: Color(0xFF03DAC6), // 辅助色
          // onSecondary: Colors.black,
          // error: Color(0xFFCF6679),     // 错误色
          // onError: Colors.black,
          // surface: Color(0xFF1E1E1E),   // 卡片/底部区域
          // onSurface: Colors.white,
        ),
        platform: TargetPlatform.iOS,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent, // 点击时的高亮效果设置为透明
        highlightColor: Colors.transparent, // 长按时的扩散效果设置为透明
        // primaryColor: Colors.greenAccent, //主色调为青色
        // indicatorColor: Colors.white,
        // accentColor: Colors.tealAccent[200]!,
        // brightness: Brightness.dark,//设置明暗模式为暗色
        // accentColor: Colors.grey[900]!,//(按钮）Widget前景色为黑色
        // primaryColor: Colors.white,//主色调为青色
        // splashColor: Colors.transparent, // 点击时的高亮效果设置为透明
        // highlightColor: Colors.transparent, // 长按时的扩散效果设置为透明
        // iconTheme: IconThemeData(color: Colors.white54),//设置icon主题色为黄色
        // // textTheme: TextTheme(body1: TextStyle(color: Colors.red))//设置文本颜色为红色
        // buttonColor: Colors.tealAccent[200]!,
        // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
        // appBarTheme: ThemeData.dark().appBarTheme.copyWith(
        //   color: Colors.black54,
        // ),
        // indicatorColor: Colors.white,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          toolbarTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white, // 图标颜色
            size: 24.0, // 图标大小
            opacity: 0.8, // 图标透明度
          ),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        dividerTheme: const DividerThemeData(
          space: 0.5,
          thickness: 1,
        ),
        badgeTheme: const BadgeThemeData(
          offset: Offset(-1, -4),
          largeSize: 20,
          smallSize: 20,
          textColor: Colors.white,
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 11,
          ),
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          height: 60,
        ),
        chipTheme: ChipThemeData(
          pressElevation: 0, //不明原因未生效
          showCheckmark: false,
        ),
        dialogBackgroundColor: Color(0xFF242434),
        dialogTheme: DialogTheme(
          backgroundColor: Color(0xFF242434),
          // elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          contentTextStyle: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          iconColor: Colors.white,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Color(0xFF212121),
          surfaceTintColor: Color(0xFF424242),
          modalBackgroundColor: Color(0xFF212121),
          shadowColor: Colors.black.withOpacity(0.7),
          elevation: 8,
          modalElevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          showDragHandle: true,
          dragHandleColor: Colors.tealAccent,
          dragHandleSize: const Size(40, 6),
          clipBehavior: Clip.antiAlias,
          constraints: const BoxConstraints(
            minHeight: 100,
            maxHeight: 400,
            minWidth: double.infinity,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          // isCollapsed: true,
          // contentPadding: const EdgeInsets.symmetric(vertical: 11),
          filled: true,
          fillColor: Colors.black.withOpacity(0.5),
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.4),
            fontWeight: FontWeight.w400,
          ),
          labelStyle: TextStyle(
            fontSize: 14,
            color: Colors.red.withOpacity(0.9),
            fontWeight: FontWeight.w400,
          ),
          prefixIconColor: Color(0xFF7C7C85),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1,
              color: const Color(0xFFA79AF8).withOpacity(0.1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1,
              color: const Color(0xFFA79AF8).withOpacity(0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1,
              color: const Color(0xFFA79AF8).withOpacity(0.1),
            ),
          ),
        ),
      );

  /// 初始化配置
  Iterable<ThemeExtension<dynamic>>? appThemeDataExtensions() {
    final appTheme = NAppTheme(
      primary: const Color(0xFF00B451),
      primary2: const Color(0xFF00B451).withOpacity(0.8),
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
      NButtonTheme(
        primary: const Color(0xFF00B451),
      ),
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

  late ScrollController? actionScrollController = ScrollController();

  /// 选择主题
  Future showSeedColorPicker({
    required BuildContext context,
    ValueChanged<Color>? onColorChanged,
    ValueChanged<Brightness>? onBrightnessChanged,
    bool dismiss = true,
  }) {
    final colors = [
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
                  colorOptions: colors,
                  onColorChanged: (v) {
                    if (dismiss) {
                      Navigator.of(context).pop();
                    }
                    onColorChanged?.call(v);
                    seedColor = v;
                    changeTheme(lightTheme);
                  },
                  brightness: Get.isDarkMode ? Brightness.dark : Brightness.light,
                  onBrightnessChanged: (v) {
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

  buildMaterial3Theme() {
    final color = seedColor;
    return ThemeData(
      ///用来适配 Theme.of(context).primaryColorLight 和 primaryColorDark 的颜色变化，不设置可能会是默认蓝色
      // primarySwatch: color,

      /// Card 在 M3 下，会有 apply Overlay
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        primary: color,
        brightness: Brightness.light,

        ///影响 card 的表色，因为 M3 下是  applySurfaceTint ，在 Material 里
        surfaceTint: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 24.0,
        ),
        backgroundColor: color,
        titleTextStyle: Typography.dense2014.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      /// 受到 iconThemeData.isConcrete 的印象，需要全参数才不会进入 fallback
      iconTheme: IconThemeData(
        size: 24.0,
        fill: 0.0,
        weight: 400.0,
        grade: 0.0,
        opticalSize: 48.0,
        color: Colors.white,
        opacity: 0.8,
      ),

      ///修改 FloatingActionButton的默认主题行为
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: CircleBorder(),
      ),
    );
  }

  final inputDecorationThemeDark = InputDecorationTheme(
    isCollapsed: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 11),
    filled: true,
    fillColor: Colors.white.withOpacity(0.05),
    hintStyle: TextStyle(
      fontSize: 14,
      color: Colors.white.withOpacity(0.4),
      fontWeight: FontWeight.w400,
    ),
    labelStyle: TextStyle(
      fontSize: 14,
      color: Colors.red.withOpacity(0.9),
      fontWeight: FontWeight.w400,
    ),
    prefixIconColor: Color(0xFF7C7C85),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: const Color(0xFFA79AF8).withOpacity(0.1),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: const Color(0xFFA79AF8).withOpacity(0.1),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: const Color(0xFFA79AF8).withOpacity(0.1),
      ),
    ),
  );

  final inputDecorationThemeLight = InputDecorationTheme(
    isCollapsed: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 11),
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(
      fontSize: 14,
      color: Color(0xFFA7A7AE),
      fontWeight: FontWeight.w400,
    ),
    labelStyle: const TextStyle(
      fontSize: 14,
      color: Colors.red,
      fontWeight: FontWeight.w400,
    ),
    floatingLabelStyle: TextStyle(color: Colors.red, fontSize: 12),
    prefixIconColor: Color(0xFF7C7C85),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: Colors.white,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(width: 1, color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: Colors.white,
      ),
    ),
  );
}

/// App 自定义主题
class NAppTheme extends ThemeExtension<NAppTheme> {
  /// App 自定义主题
  NAppTheme({
    this.primary = const Color(0xFF007DBF),
    this.primary2 = const Color(0xFF359EEB),
    this.bgColor = const Color(0xFFF3F3F3),
    this.fontColor = const Color(0xFF1A1A1A),
    this.titleStyle = const TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 18,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    ),
    this.textStyle = const TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    ),
    this.cancelColor = const Color(0xFFE65F55),
    this.lineColor = const Color(0xFFE5E5E5),
    this.borderColor = const Color(0xFFE5E5E5),
    this.disabledColor = const Color(0xffB3B3B3),
  });

  /// 字体颜色
  final Color primary;

  /// 主色调辅助色(用于渐进色)
  final Color primary2;

  /// 背景色
  final Color bgColor;

  /// 标题字体样式
  final Color fontColor;

  /// 标题字体样式
  final TextStyle titleStyle;

  /// 字体样式
  final TextStyle textStyle;

  /// 取消按钮的那种深红色 cancel 0xFFE65F55
  final Color cancelColor;

  /// 线条 #E5E5E5
  final Color lineColor;

  /// 边框线条 #E5E5E5
  final Color borderColor;

  /// 禁用状态的颜色 #B3B3B3
  final Color disabledColor;

  @override
  ThemeExtension<NAppTheme> copyWith({
    Color? primary,
    Color? primary2,
    Color? AppColor.bgColor,
    Color? fontColor,
    TextStyle? titleStyle,
    TextStyle? textStyle,
    Color? cancelColor,
    Color? lineColor,
    Color? borderColor,
    Color? disabledColor,
  }) =>
      NAppTheme(
        primary: primary ?? this.primary,
        primary2: primary2 ?? this.primary2,
        bgColor: AppColor.bgColor, ?? this.bgColor,
        fontColor: fontColor ?? this.fontColor,
        titleStyle: titleStyle ?? this.titleStyle,
        textStyle: textStyle ?? this.textStyle,
        cancelColor: cancelColor ?? this.cancelColor,
        lineColor: lineColor ?? this.lineColor,
        borderColor: borderColor ?? this.borderColor,
        disabledColor: disabledColor ?? this.disabledColor,
      );

  @override
  ThemeExtension<NAppTheme> lerp(
    covariant NAppTheme? other,
    double t,
  ) =>
      NAppTheme(
        primary: Color.lerp(primary, other?.primary, t) ?? primary,
        primary2: Color.lerp(primary2, other?.primary2, t) ?? primary2,
        bgColor: Color.lerp(bgColor, other?.bgColor, t) ?? AppColor.bgColor,
        fontColor: Color.lerp(fontColor, other?.fontColor, t) ?? fontColor,
        titleStyle: TextStyle.lerp(titleStyle, other?.titleStyle, t) ?? titleStyle,
        textStyle: TextStyle.lerp(textStyle, other?.textStyle, t) ?? textStyle,
        cancelColor: Color.lerp(cancelColor, other?.cancelColor, t) ?? cancelColor,
        lineColor: Color.lerp(lineColor, other?.lineColor, t) ?? lineColor,
        borderColor: Color.lerp(borderColor, other?.borderColor, t) ?? borderColor,
        disabledColor: Color.lerp(disabledColor, other?.disabledColor, t) ?? disabledColor,
      );
}

/// 弹窗 主题文件
class NDialogTheme extends ThemeExtension<NDialogTheme> {
  /// App 默认主题
  const NDialogTheme({
    this.width = 315,
    this.padding = const EdgeInsets.all(20),
    this.raidus = 16,
    this.titleStyle = const TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 24,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    ),
    this.textStyle = const TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
    ),
  });

  /// 宽
  final double? width;

  /// 内边距
  final EdgeInsets? padding;

  /// 圆角
  final double? raidus;

  /// 标题字体样式
  final TextStyle? titleStyle;

  /// 字体样式
  final TextStyle? textStyle;

  @override
  ThemeExtension<NDialogTheme> copyWith({
    double? width,
    EdgeInsets? padding,
    double? raidus,
    TextStyle? titleStyle,
    TextStyle? textStyle,
  }) =>
      NDialogTheme(
        width: width ?? this.width,
        padding: padding ?? this.padding,
        raidus: raidus ?? this.raidus,
        titleStyle: titleStyle ?? this.titleStyle,
        textStyle: textStyle ?? this.textStyle,
      );

  @override
  ThemeExtension<NDialogTheme> lerp(
    covariant NDialogTheme? other,
    double t,
  ) =>
      NDialogTheme(
        padding: EdgeInsets.lerp(padding, other?.padding, t),
        titleStyle: TextStyle.lerp(titleStyle, other?.titleStyle, t),
        textStyle: TextStyle.lerp(textStyle, other?.textStyle, t),
      );
}
