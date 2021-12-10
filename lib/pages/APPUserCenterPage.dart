//
//  APPUserCenterPage.dart
//  flutter_templet_project
//
//  Created by shang on 5/20/21 4:57 PM.
//  Copyright © 5/20/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/extensions/button_extension.dart';
import 'package:flutter_templet_project/main.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:flutter_templet_project/extensions/navigator_extension.dart';
import 'package:flutter_templet_project/extensions/alertDialog_extension.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';

import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'APPDrawerMenuPage.dart';
import 'package:tuple/tuple.dart';


class APPUserCenterPage extends StatefulWidget{
  @override
  _APPUserCenterPageState createState() => _APPUserCenterPageState();
}

class _APPUserCenterPageState extends State<APPUserCenterPage>{


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
                // 打开抽屉菜单
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
        ),
      // drawer: APPDrawerMenuPage(),

      body: Center(
          child: ListView(
            children: <Widget>[
              buildTop(context),
              buildMid(context),
              Container(height: 15, color: Get.isDarkMode ? Colors.black45 : Color(0xfff2f2f2)),
              // Container(height: 15, color: Colors.red),
              buildBom(context)
            ],
          ),
        ),
    );
  }

  // 头部
  Widget buildTop(BuildContext context) {
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
                child: Text('登录', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: (){
                  // APPRouter.push(context, 'login');
                  // Get.toNamed(APPRouter.loginPage, arguments: "login");
                  Get.toNamed(APPRouter.loginPage2, arguments: "login");
                },
              ),
              Text('/', style: TextStyle(fontSize: 20.0, color: Colors.white)),
              TextButton(
                child: Text('注册', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: (){
                  // APPRouter.push(context, 'register');
                  Get.toNamed(APPRouter.signinPage, arguments: "signin");
                },
              )
            ],
          )
        ],
      ),
    );
  }

  // 中间
  Widget buildMid(BuildContext context) {
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
            image: (e.item2 as Icon).copyWith(color: Theme.of(context).accentColor),
            imageAlignment: ImageAlignment.top,
            callback: (value){
          ddlog(value);
        })).toList(),
      ),
    );
  }

  Widget buildBom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:10, vertical:8),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.mail, color: Theme.of(context).accentColor,),
            title: Text("我的消息",style: TextStyle(fontSize: 16.0)),
            trailing: Icon(Icons.chevron_right),
            dense:true,
            onTap: (){},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.share, color: Theme.of(context).accentColor,),
            title: Text("分享应用", style: TextStyle(fontSize: 16.0)),
            trailing: Icon(Icons.chevron_right),
            dense:true,
            onTap: (){},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.save, color: Theme.of(context).accentColor,),
            title: Text("我的收藏", style: TextStyle(fontSize: 16.0)),
            trailing: Icon(Icons.chevron_right),
            dense:true,
            onTap: (){},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.date_range, color: Theme.of(context).accentColor,),
            title: Text("我的点评", style: TextStyle(fontSize: 16.0)),
            trailing: Icon(Icons.chevron_right),
            dense:true,
            onTap: (){},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.scanner, color: Theme.of(context).accentColor,),
            title: Text("我的书架", style: TextStyle(fontSize: 16.0)),
            trailing: Icon(Icons.chevron_right),
            dense:true,
            onTap: (){},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.table_chart, color: Theme.of(context).accentColor,),
            title: Text("设置主题", style: TextStyle(fontSize: 16.0)),
            trailing: Icon(Icons.chevron_right),
            dense:true,
            onTap: (){},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language, color: Theme.of(context).accentColor,),
            title: Text("语言切换", style: TextStyle(fontSize: 16.0)),
            trailing: Icon(Icons.chevron_right),
            dense:true,
            onTap: (){},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.history, color: Theme.of(context).accentColor,),
            title: Text("历史记录", style: TextStyle(fontSize: 16.0)),
            trailing: Icon(Icons.chevron_right),
            dense:true,
            onTap: (){},
          ),
        ],
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