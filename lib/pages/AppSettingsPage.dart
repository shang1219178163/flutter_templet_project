//
//  AppAppSettingsPage.dart
//  flutter_templet_project
//
//  Created by shang on 5/20/21 4:54 PM.
//  Copyright © 5/20/21 shang. All rights reserved.
//


// 设置
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:tuple/tuple.dart';


class AppSettingsPage extends StatefulWidget{
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  _AppSettingsPageState createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage>{

  late final items = <Tuple3<String, IconData, VoidCallback>>[
    Tuple3("用户信息", Icons.mail, onPressed),
    Tuple3("手机号", Icons.share, onPressed),
    Tuple3("微信号", Icons.save, onPressed),
    Tuple3("应用信息", Icons.date_range, onPressed),
    Tuple3("清除缓存", Icons.scanner, onPressed),
    Tuple3("设置主题", Icons.table_chart, onPressed),
    Tuple3("语言切换", Icons.language, onPressed),
    Tuple3("历史记录", Icons.history, onPressed),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('设置',),
        actions: [
          TextButton(
            onPressed: (){
              APPThemeService().showThemePicker(
                context: context,
                cb: (){
                  Navigator.of(context).pop();
              });
            },
            child: Text("主题色",)
          ),
        ],
      ),
      body: ListView(
        children: [
          buildBom(),
        ]
      ),
    );
  }

  Widget buildBom() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:10, vertical:8),
      child: Column(
        children: items.map((e) => Container(
          child: Column(
            children: [
              ListTile(
                dense: true,
                leading: Icon(e.item2,),
                title: Text(e.item1, style: TextStyle(fontSize: 16.0)),
                trailing: Icon(Icons.chevron_right),
                onTap: (){
                  debugPrint("${e.item1}");
                },
              ),
              if (e != items.last) Divider(height: 1, indent: 0, endIndent: 0,),
            ],
          ),
        )).toList(),
      ),
    );
  }

  onPressed() {

  }


}
