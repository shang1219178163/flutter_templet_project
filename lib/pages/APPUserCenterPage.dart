//
//  APPUserCenterPage.dart
//  flutter_templet_project
//
//  Created by shang on 5/20/21 4:57 PM.
//  Copyright © 5/20/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/main.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/navigator_ext.dart';
import 'package:flutter_templet_project/extension/dialog_ext.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';

import 'package:get/get.dart';
import 'package:flutter_templet_project/pages/APPDrawerMenuPage.dart';
import 'package:tuple/tuple.dart';


class APPUserCenterPage extends StatefulWidget{
  const APPUserCenterPage({Key? key}) : super(key: key);

  @override
  _APPUserCenterPageState createState() => _APPUserCenterPageState();
}

class _APPUserCenterPageState extends State<APPUserCenterPage>{


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
                // Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
                APPThemeSettings.instance.changeTheme();
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
          Hero(
            tag: 'avatar',
            child: Image.asset('images/avatar.png', width:90),
            // child: Image.asset('images/bg.png', width:90),
          ),
          // Container(child: Image.asset('images/icon_appbar_back.png', width:90),),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextButton(
                onPressed: (){
                  // APPRouter.push(context, 'login');
                  // Get.toNamed(APPRouter.loginPage, arguments: "login");
                  Get.toNamed(APPRouter.loginPage2, arguments: "login");
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
        children: serviceList.map((e) => TextButtonExt.build(
            text: e.item1,
            // image: (e.item2 as Icon).copyWith(color: Theme.of(context).iconTheme.color),
            image: (e.item2 as Icon),
            imageAlignment: ImageAlignment.top,
            callback: (value, tag){
          ddlog(value);
        })).toList(),
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

// 我的 列表菜单
const List<Tuple2> serviceList = [
  Tuple2(
    Text('京豆', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xFF666666),),
    ),
    Icon(
      Icons.adjust,
      size: 25,
      color: Colors.lightBlue,
    ),
  ),
  Tuple2(
    Text('白条', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xFF666666),),
    ),
    Icon(
      Icons.content_paste,
      size: 25,
      color: Colors.lightBlue,
    ),
  ),
  Tuple2(
    Text('优惠券', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xFF666666),),
    ),
    Icon(
        Icons.card_giftcard,
        size: 25,
        color: Colors.lightBlue,
      ),
  ),
  Tuple2(
    Text('购物车', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xFF666666),),
    ),
    Icon(
      Icons.shopping_cart,
      size: 25,
      color: Colors.lightBlue,
    ),
  ),
];