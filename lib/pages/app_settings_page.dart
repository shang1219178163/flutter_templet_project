//
//  AppAppSettingsPage.dart
//  flutter_templet_project
//
//  Created by shang on 5/20/21 4:54 PM.
//  Copyright © 5/20/21 shang. All rights reserved.
//

// 设置
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/NSystemThemeTab.dart';
import 'package:flutter_templet_project/pages/app_tab_bar_controller.dart';
import 'package:flutter_templet_project/provider/theme_provider.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  _AppSettingsPageState createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  final appController = Get.find<AppTabBarController>();

  late final items = <Tuple3<String, IconData, VoidCallback>>[
    Tuple3("用户信息", Icons.mail, onPressed),
    Tuple3("手机号", Icons.share, onPressed),
    Tuple3("微信号", Icons.save, onPressed),
    Tuple3("应用信息", Icons.date_range, onPressed),
    Tuple3("清除缓存", Icons.scanner, onPressed),
    Tuple3("设置主题", Icons.table_chart, onThemeChange),
    Tuple3("语言切换", Icons.language, onPressed),
    Tuple3("历史记录", Icons.history, onPressed),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        actions: [
          TextButton(
              onPressed: () {
                APPThemeService().showThemePicker(
                    context: context,
                    cb: () {
                      Navigator.of(context).pop();
                    });
              },
              child: Text(
                "主题色",
              )),
        ],
      ),
      body: ListView(children: [
        buildBom(),
      ]),
    );
  }

  Widget buildBom() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: items
            .map((e) => Container(
                  child: Column(
                    children: [
                      ListTile(
                        dense: true,
                        leading: Icon(
                          e.item2,
                        ),
                        title: Text(e.item1, style: TextStyle(fontSize: 16.0)),
                        trailing: Icon(Icons.chevron_right),
                        onTap: e.item3,
                      ),
                      if (e != items.last)
                        Divider(
                          height: 1,
                          indent: 0,
                          endIndent: 0,
                        ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  onPressed() {
    if (appController.packageInfo == null) {
      return;
    }
    showAboutDialog(
      context: context,
      applicationName: appController.packageInfo?.appName,
      applicationVersion: appController.packageInfo?.version,
      applicationIcon: Image.asset(
        'assets/images/icon_hi.png',
        width: 100,
      ),
      applicationLegalese: '© 2024 Shange. All rights reserved.',
    );
  }

  void onThemeChange() {
    // /// 主题 provider
    // ThemeProvider themeProvider = context.read<ThemeProvider>();
    BottomSheetHelper.showCustom(
      context: context,
      child: Container(
        child: NSystemThemeTab(
          mode: ThemeProvider().themeMode,
          onChanged: (v) {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

class BottomSheetHelper {
  /// 展示自定义UI
  static void showCustom({
    required BuildContext context,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xff181829) : Colors.white;
    final barrierColor = isDark ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.3);
    final borderColor = isDark ? Colors.black : Colors.white;

    final titleColor = isDark ? Colors.white : Color(0xff313135);
    final subtitleColor = isDark ? Colors.white.withOpacity(0.8) : Color(0xff7C7C85);

    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      elevation: 0,
      builder: (context) {
        return Scrollbar(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 500,
              minHeight: 200,
            ),
            child: SingleChildScrollView(
              child: Material(
                color: backgroundColor,
                // elevation: 0,
                // shadowColor: backgroundColor,
                // shape: RoundedRectangleBorder(
                //   side: BorderSide(color: Colors.red),
                // ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
