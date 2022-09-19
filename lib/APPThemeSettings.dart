//
//  APPThemeSettings.dart
//  flutter_templet_project
//
//  Created by shang on 7/14/21 2:18 PM.
//  Copyright © 7/14/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:flutter_templet_project/extensions/list_extension.dart';
import 'package:get/get.dart';

import 'extensions/widget_extension.dart';

class APPThemeSettings {
  static final APPThemeSettings _instance = APPThemeSettings._();

  APPThemeSettings._();

  factory APPThemeSettings() => _instance;

  static APPThemeSettings get instance => _instance;

  ThemeData themeData = ThemeData.light().copyWith(
    // primarySwatch: Colors.blue,
    // brightness: Brightness.dark,//设置明暗模式为暗色
    // accentColor: Colors.black,//(按钮）Widget前景色为黑色
    primaryColor: Colors.lightBlue, //主色调为青色
    indicatorColor: Colors.white,
    // splashColor: Colors.transparent, // 点击时的高亮效果设置为透明
    // highlightColor: Colors.transparent, // 长按时的扩散效果设置为透明
    // iconTheme: IconThemeData(color: Colors.yellow),//设置icon主题色为黄色
    // textTheme: ThemeData.light().textTheme.copyWith(
    //     button: TextStyle(color: Colors.red)
    // ),//设置文本颜色为红色
    // textButtonTheme: TextButtonThemeData(
    //   style: ButtonStyle(),
    // ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   // style: ButtonStyle()
    // ),
    // outlinedButtonTheme: OutlinedButtonThemeData(
    //     style: ButtonStyle()
    // ),
    // scaffoldBackgroundColor: Colors.red
  );

  // ThemeData? darkThemeData;
  ThemeData darkThemeData = ThemeData.dark().copyWith(
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
      // textButtonTheme: TextButtonThemeData(
      //   style: ButtonStyle(
      //     foregroundColor: MaterialStateProperty.all(Colors.tealAccent[200]!),
      //     textStyle: MaterialStateProperty.all(TextStyle(color: Colors.tealAccent[200]!)),
      //   ),
      // ),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ButtonStyle(
      //       backgroundColor: MaterialStateProperty.all(Colors.tealAccent[200]!),
      //     )
      // ),
      // outlinedButtonTheme: OutlinedButtonThemeData(
      //   style: ButtonStyle(
      //     foregroundColor: MaterialStateProperty.all(Colors.tealAccent[200]!),
      //     // textStyle: MaterialStateProperty.all(TextStyle(color: e)),
      //   ),
      // ),
      );

  late ScrollController? actionScrollController = ScrollController();

  void showThemePicker({
    required BuildContext context,
    required void Function() callback,
  }) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              actionScrollController: actionScrollController,
              title: Text("请选择主题色"),
              // message: Text(message),
              actions: _buildActions(context: context, callback: callback),
              cancelButton: CupertinoActionSheetAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ));
  }
  
  _buildActions({
    required BuildContext context,
    required void Function() callback,
  }) {
    return colors.map((e) {
      final text = "${e.toString()}"
          .replaceAll('MaterialColor(primary value:', '')
          .replaceAll('MaterialAccentColor(primary value:', '')
          .replaceAll('))', ')');

      return Container(
          color: e,
          child: Column(
            children: [
              SizedBox(
                height: 18,
              ),
              GestureDetector(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    backgroundColor: e,
                    decoration: TextDecoration.none,
                  ),
                ),
                onTap: () {
                  changeThemeLight(e);
                  Navigator.pop(context);
                  callback();
                },
              ),
              SizedBox(
                height: 18,
              ),
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
      // 长按时的扩散效果设置为透明
      accentColor: e,
      buttonColor: e,
      // scaffoldBackgroundColor: e,
      appBarTheme: ThemeData.light().appBarTheme.copyWith(color: e),
      colorScheme: ThemeData.light().colorScheme.copyWith(secondary: e),
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
                selectedLabelStyle: TextStyle(fontSize: 12),
                unselectedLabelStyle: TextStyle(fontSize: 12),
              ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: e,
        // textTheme:
        // primaryContrastingColor: Colors.red,
        // barBackgroundColor: Colors.red,
        // scaffoldBackgroundColor: Colors.red,
      ),
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

}
