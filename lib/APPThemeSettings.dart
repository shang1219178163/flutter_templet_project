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
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:get/get.dart';

class APPThemeService {
  static final APPThemeService _instance = APPThemeService._();

  APPThemeService._();

  factory APPThemeService() => _instance;

  // static APPThemeSettings get instance => _instance;

  late ThemeData themeData = ThemeData.light(useMaterial3: false).copyWith(
    platform: TargetPlatform.iOS,
    // scaffoldBackgroundColor: Colors.red
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent, // 点击时的高亮效果设置为透明
    highlightColor: Colors.transparent, // 长按时的扩散效果设置为透明
    // primaryColor: Colors.blue, //主色调为青色
    // indicatorColor: Colors.white,
    // iconTheme: IconThemeData(color: Colors.yellow),//设置icon主题色为黄色
    // textTheme: ThemeData.light().textTheme.copyWith(
    //     button: TextStyle(color: Colors.red)
    // ),//设置文本颜色为红色
    appBarTheme: const AppBarTheme(
      elevation: 0,
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
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 11,
      ),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      height: 60,
    ),
    chipTheme: ChipThemeData(
      pressElevation: 0,//不明原因未生效
      showCheckmark: false,
    ),
    buttonTheme: ButtonThemeData(
      splashColor: Colors.transparent,
      buttonColor: Colors.blue,
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
      pressElevation: 0,//不明原因未生效
      showCheckmark: false,
    ),
  );

  /// 自定义行为
  ButtonStyle buildButtonStyle() {
    return ButtonStyle(
      elevation: MaterialStateProperty.resolveWith<double>((states) {
        if (states.contains(MaterialState.pressed)) {
          return 0; // 点击时阴影隐藏
        }
        return 0; // 正常时阴影隐藏
      })
    );
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
      )
    );
  }
  
  _buildActions({
    required BuildContext context,
    required void Function() cb,
  }) {
    return colors.map((e) {
      final text = e.toString()
          .replaceAll('MaterialColor(primary value:', '')
          .replaceAll('MaterialAccentColor(primary value:', '')
          .replaceAll('))', ')');

      return Container(
          color: e,
          child: Column(
            children: [
              const SizedBox(height: 18,),
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
              const SizedBox(height: 18,),
            ],
          ));
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
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(e),
          // textStyle: MaterialStateProperty.all(TextStyle(color: e)),
        ),
      ),
      switchTheme: ThemeData.light().switchTheme.copyWith(
          // thumbColor: e,
          trackColor: MaterialStateProperty.all(e)),
      bottomNavigationBarTheme:
          ThemeData.light().bottomNavigationBarTheme.copyWith(
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
      ), colorScheme: ThemeData.light().colorScheme.copyWith(secondary: e).copyWith(secondary: e),
    );
    Get.changeTheme(themeData);
  }


  final List<Color> colors = [
    // Colors.black,
    // Colors.red,
    // Colors.teal,
    // Colors.pink,
    // Colors.amber,
    // Colors.orange,
    // Colors.green,
    // Colors.blue,
    // Colors.lightBlue,
    // Colors.purple,
    // Colors.deepPurple,
    // Colors.indigo,
    // Colors.cyan,
    // Colors.brown,
    // Colors.grey,
    // Colors.blueGrey,

    ...Colors.primaries,
    ...Colors.accents,
  ];

  
  buildMaterial3Theme() {
    final color = Colors.blue;
    return ThemeData(
      ///用来适配 Theme.of(context).primaryColorLight 和 primaryColorDark 的颜色变化，不设置可能会是默认蓝色
      primarySwatch: color as MaterialColor,

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
          shape: CircleBorder()
        ),
      );
  }
}
