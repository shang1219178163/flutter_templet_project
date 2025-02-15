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
import 'package:flutter_templet_project/basicWidget/theme/n_button_theme.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';

class APPThemeService {
  static final APPThemeService _instance = APPThemeService._();

  APPThemeService._();

  factory APPThemeService() => _instance;

  // static APPThemeSettings get instance => _instance;

  late ThemeData themeData = ThemeData.light(useMaterial3: false).copyWith(
    platform: TargetPlatform.iOS,
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent, // 点击时的高亮效果设置为透明
    highlightColor: Colors.transparent, // 长按时的扩散效果设置为透明
    // primaryColor: Colors.blue, //主色调为青色
    // indicatorColor: Colors.white,
    // iconTheme: IconThemeData(color: Colors.yellow),//设置icon主题色为黄色
    // textTheme: ThemeData.light().textTheme.copyWith(
    //     button: TextStyle(color: Colors.red)
    // ),//设置文本颜色为红色
    scaffoldBackgroundColor: bgColor,
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
      buttonColor: Colors.blue,
      focusColor: Colors.transparent,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: Colors.blue,
      ).merge(buildButtonStyle()),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: Colors.blue,
      ).merge(buildButtonStyle()),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: Colors.blue,
      ).merge(buildButtonStyle()),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: Colors.blue,
      ).merge(buildButtonStyle()),
    ),
    extensions: appThemeDataExtensions(),
  );

  // ThemeData? darkThemeData;
  ThemeData darkThemeData = ThemeData.dark(useMaterial3: false).copyWith(
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
    appBarTheme: const AppBarTheme(
      elevation: 0,
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
        fontWeight: FontWeight.bold,
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
    return ButtonStyle(elevation: MaterialStateProperty.resolveWith<double>((states) {
      if (states.contains(MaterialState.pressed)) {
        return 0; // 点击时阴影隐藏
      }
      return 0; // 正常时阴影隐藏
    }));
  }

  late ScrollController? actionScrollController = ScrollController();

  void showThemePicker({
    required BuildContext context,
    required void Function() cb,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actionScrollController: actionScrollController,
        title: const Text("请选择主题色"),
        // message: Text(message),
        actions: _buildActions(context: context, cb: cb),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
      ),
    );
  }

  _buildActions({
    required BuildContext context,
    required void Function() cb,
  }) {
    return colors.map((e) {
      final text = e
          .toString()
          .replaceAll('MaterialColor(primary value:', '')
          .replaceAll('MaterialAccentColor(primary value:', '')
          .replaceAll('))', ')');

      return Container(
        color: e,
        child: Column(
          children: [
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {
                changeThemeLight(e);
                Navigator.pop(context);
                cb();
              },
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  backgroundColor: e,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      );
    }).toList();
  }

  void changeTheme() {
    // Get.changeTheme(Get.isDarkMode? ThemeData.light() : ThemeData.dark());
    Get.changeTheme(Get.isDarkMode ? themeData : darkThemeData);
  }

  void changeThemeLight(Color e) {
    themeData = ThemeData.light().copyWith(
      primaryColor: e,
      splashColor: Colors.transparent,
      // 点击时的高亮效果设置为透明
      highlightColor: Colors.transparent,
      // scaffoldBackgroundColor: e,
      appBarTheme: ThemeData.light().appBarTheme.copyWith(color: e),
      indicatorColor: Colors.white,
      iconTheme: ThemeData.light().iconTheme.copyWith(
            color: e,
          ),
      textTheme: ThemeData.light().textTheme.apply(
            // bodyColor: Colors.pink,
            // displayColor: Colors.pink,
            decoration: TextDecoration.none,
          ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(e),
          // textStyle: MaterialStateProperty.all(TextStyle(color: Colors.red)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(e),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(e),
          // textStyle: MaterialStateProperty.all(TextStyle(color: e)),
        ),
      ),
      switchTheme: ThemeData.light().switchTheme.copyWith(
            // thumbColor: e,
            trackColor: MaterialStateProperty.all(e),
          ),
      bottomNavigationBarTheme: ThemeData.light().bottomNavigationBarTheme.copyWith(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: e,
            selectedIconTheme: IconThemeData(color: e),
            selectedLabelStyle: const TextStyle(fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
          ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: e,
        // textTheme:
        // primaryContrastingColor: Colors.red,
        // barBackgroundColor: Colors.red,
        // scaffoldBackgroundColor: Colors.red,
      ),
      colorScheme: ThemeData.light().colorScheme.copyWith(secondary: e),
    );
    Get.changeTheme(themeData);
  }

  final List<Color> colors = [
    ...Colors.primaries,
    ...Colors.accents,
  ];

  buildMaterial3Theme() {
    final color = Colors.blue;
    return ThemeData(
      ///用来适配 Theme.of(context).primaryColorLight 和 primaryColorDark 的颜色变化，不设置可能会是默认蓝色
      primarySwatch: color,

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
    Color? bgColor,
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
        bgColor: bgColor ?? this.bgColor,
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
    covariant NAppTheme other,
    double t,
  ) =>
      NAppTheme(
        primary: Color.lerp(primary, other.primary, t) ?? primary,
        primary2: Color.lerp(primary2, other.primary2, t) ?? primary2,
        bgColor: Color.lerp(bgColor, other.bgColor, t) ?? bgColor,
        fontColor: Color.lerp(fontColor, other.fontColor, t) ?? fontColor,
        titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t) ?? titleStyle,
        textStyle: TextStyle.lerp(textStyle, other.textStyle, t) ?? textStyle,
        cancelColor: Color.lerp(cancelColor, other.cancelColor, t) ?? cancelColor,
        lineColor: Color.lerp(lineColor, other.lineColor, t) ?? lineColor,
        borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
        disabledColor: Color.lerp(disabledColor, other.disabledColor, t) ?? disabledColor,
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
