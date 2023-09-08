//
//  APPUserCenterPage.dart
//  flutter_templet_project
//
//  Created by shang on 5/20/21 4:57 PM.
//  Copyright © 5/20/21 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/n_label_and_icon.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/main.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/navigator_ext.dart';
import 'package:flutter_templet_project/extension/dialog_ext.dart';
import 'package:flutter_templet_project/mixin/bottom_sheet_avatar_mixin.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';

import 'package:get/get.dart';
import 'package:flutter_templet_project/pages/APPDrawerMenuPage.dart';
import 'package:tuple/tuple.dart';


class APPUserCenterPage extends StatefulWidget{
  const APPUserCenterPage({Key? key}) : super(key: key);

  @override
  _APPUserCenterPageState createState() => _APPUserCenterPageState();
}

class _APPUserCenterPageState extends State<APPUserCenterPage> with BottomSheetAvatarMixin{

  // 我的 列表菜单
  final services = <Tuple2<String, IconData>>[
    Tuple2('京豆', Icons.adjust,),
    Tuple2('白条', Icons.content_paste,),
    Tuple2('优惠券', Icons.card_giftcard,),
    Tuple2('购物车', Icons.shopping_cart,),
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
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),//修改返回按钮颜色
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
            IconButton(icon: Icon(Icons.change_circle_outlined),
              color: Colors.white,
              onPressed: (){
                APPThemeService().changeTheme();
              },
            ),
            IconButton(icon: Icon(Icons.settings),
              color: Colors.white,
              onPressed: (){
                // APPRouter.push(context, APPRouter.settingsPage, args: "setting",);
                Get.toNamed(APPRouter.settingsPage, arguments: "setting");
              },
            ),
          ],
          shadowColor: Colors.transparent,
        ),
      // drawer: APPDrawerMenuPage(),
      body: Center(
          child: ListView(
            children: <Widget>[
              buildTop(),
              buildMid(),
              Container(height: 15, color: Get.isDarkMode ? Colors.black45 : Color(0xfff2f2f2)),
              buildBom(),
            ],
          ),
        ),
    );
  }

  // 头部
  Widget buildTop() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 160.0,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          InkWell(
            onTap: (){
              updateAvatar(
                cb: (val){
                  if (val == null) {
                    return;
                  }
                  debugPrint("updateAvatar: $val");
                  avatarVN.value = val;
                }
              );
            },
            child: ValueListenableBuilder<String>(
              valueListenable: avatarVN,
              builder: (context,  value, child){

                if (value.isEmpty) {
                  return Hero(
                    tag: 'avatar',
                    child: Image.asset('avatar.png'.toPath(), width:90),
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
              }
            ),
          ),
          // Container(child: Image.asset('icon_appbar_back.png'.toPng(), width:90),),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextButton(
                onPressed: (){
                  // APPRouter.push(context, 'login');
                  // Get.toNamed(APPRouter.loginPage, arguments: "login");
                  Get.toNamed(APPRouter.loginPageOne, arguments: "login");
                },
                child: Text('登录', style: TextStyle(fontSize: 20.0, color: Colors.white)),
              ),
              Text('/', style: TextStyle(fontSize: 20.0, color: Colors.white)),
              TextButton(
                onPressed: (){
                  // APPRouter.push(context, 'register');
                  Get.toNamed(APPRouter.signinPage, arguments: "signin");
                },
                child: Text('注册', style: TextStyle(fontSize: 20.0, color: Colors.white)),
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
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8),
      child: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        children: services.map((e) => Container(
          child: InkWell(
            onTap: (){
              debugPrint("value: $e");
            },
            child: NLabelAndIcon(
              label: Text(e.item1,
                style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                ),
              ),
              icon: Icon(
                e.item2,
                size: 25,
                color: Colors.lightBlue,
              ),
              direction: Axis.vertical,
           ),
          ),
        )).toList(),
      ),
    );
  }


  Widget buildBom() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:10, vertical:8),
      child: Column(
        children: items.map((e) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
            )
          ),
          child: ListTile(
            leading: Icon(e.item2, color: Theme.of(context).primaryColor,),
            title: Text(e.item1, style: TextStyle(fontSize: 16.0)),
            trailing: Icon(Icons.chevron_right),
            onTap: (){ debugPrint("${e.item1}"); },
          ),
        )
        ).toList(),
      ),
    );
  }
}

