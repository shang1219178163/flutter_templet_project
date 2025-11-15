//
//  APPUserCenterPage.dart
//  flutter_templet_project
//
//  Created by shang on 5/20/21 4:57 PM.
//  Copyright © 5/20/21 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/basicWidget/n_pair.dart';

import 'package:flutter_templet_project/mixin/bottom_sheet_image_mixin.dart';
import 'package:flutter_templet_project/pages/app_tab_page.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class APPUserCenterPage extends StatefulWidget {
  const APPUserCenterPage({Key? key}) : super(key: key);

  @override
  _APPUserCenterPageState createState() => _APPUserCenterPageState();
}

class _APPUserCenterPageState extends State<APPUserCenterPage> with BottomSheetImageMixin {
  // 我的 列表菜单
  final services = <Tuple2<String, IconData>>[
    Tuple2('京豆', Icons.adjust),
    Tuple2('白条', Icons.content_paste),
    Tuple2('优惠券', Icons.card_giftcard),
    Tuple2('购物车', Icons.shopping_cart),
  ];

  final items = [
    Tuple2("我的消息", Icons.mail),
    Tuple2("分享应用", Icons.share),
    Tuple2("我的收藏", Icons.save),
    Tuple2("我的点评", Icons.date_range),
    Tuple2("我的书架", Icons.scanner),
    Tuple2("设置主题", Icons.table_chart),
    Tuple2("语言切换", Icons.language),
    Tuple2("历史记录", Icons.history),
  ];

  final avatarVN = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white), //修改返回按钮颜色
        centerTitle: true,
        title: Text('设置', style: TextStyle(color: Colors.white)),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu, color: Colors.white), //自定义图标
            onPressed: () {
              // Scaffold.of(context).openDrawer();
              kScaffoldKey.currentState?.openDrawer();
            },
          );
        }),
        actions: [
          IconButton(
            icon: Icon(Icons.change_circle_outlined),
            color: Colors.white,
            onPressed: () {
              AppThemeService().toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              // AppRouter.push(context, AppRouter.settingsPage, args: "setting",);
              Get.toNamed(AppRouter.settingsPage, arguments: "setting");
            },
          ),
        ],
        shadowColor: Colors.transparent,
      ),
      // drawer: APPDrawerMenuPage(),
      body: ListView(
        children: <Widget>[
          buildTop(),
          buildMid(),
          SizedBox(
            height: 15,
          ),
          // Container(height: 15, color: Get.isDarkMode ? Colors.black45 : Color(0xfff2f2f2)),
          buildBom(),
        ],
      ),
    );
  }

  // 头部
  Widget buildTop() {
    return Container(
      height: 160,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Expanded(
            child: InkWell(
              onTap: () async {
                chooseImagesByWechatPicker(
                  maxCount: 1,
                  needCropp: true,
                  onChanged: (File val) {
                    debugPrint("value: $val");
                    avatarVN.value = val.path;
                  },
                );
                // updateAvatar(
                //   needCropp: true,
                //   onChanged: (File val) {
                //     debugPrint("updateAvatar: $val");
                //     avatarVN.value = val.path;
                //   },
                // );
              },
              child: ValueListenableBuilder<String>(
                  valueListenable: avatarVN,
                  builder: (context, value, child) {
                    if (value.isEmpty) {
                      return Hero(
                        tag: 'avatar',
                        child: Image.asset('avatar.png'.toPath(), width: 90),
                        // child: Image.asset('bg.png'.toPng(), width:90),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Image.file(
                          File(value),
                          fit: BoxFit.fill,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  // AppRouter.push(context, 'login');
                  // Get.toNamed(AppRouter.loginPage, arguments: "login");
                  Get.toNamed(AppRouter.loginPageOne, arguments: "login");
                },
                child: Text('登录', style: TextStyle(fontSize: 16.0, color: Colors.white)),
              ),
              Text('/', style: TextStyle(fontSize: 20.0, color: Colors.white)),
              TextButton(
                onPressed: () {
                  // AppRouter.push(context, 'register');
                  Get.toNamed(AppRouter.signinPage, arguments: "signin");
                },
                child: Text('注册', style: TextStyle(fontSize: 16.0, color: Colors.white)),
              )
            ],
          )
        ],
      ),
    );
  }

  // 中间
  Widget buildMid() {
    return Container(
      height: 100.0,
      padding: EdgeInsets.only(top: 8),
      color: Theme.of(context).colorScheme.surface,
      alignment: Alignment.center,
      child: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        physics: NeverScrollableScrollPhysics(),
        children: services
            .map((e) => Container(
                  child: InkWell(
                    onTap: () {
                      debugPrint("value: $e");
                    },
                    child: NPair(
                      icon: Icon(
                        e.item2,
                        size: 25,
                        color: Colors.lightBlue,
                      ),
                      direction: Axis.vertical,
                      child: Text(
                        e.item1,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget buildBom() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: items
            .map((e) => Container(
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          e.item2,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(e.item1, style: TextStyle(fontSize: 16.0)),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          debugPrint(e.item1);
                        },
                      ),
                      if (e != items.last)
                        Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
