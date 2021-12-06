//
//  LoginPage.dart
//  flutter_templet_project
//
//  Created by shang on 6/3/21 9:04 AM.
//  Copyright © 6/3/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';

class LoginPage extends StatefulWidget {

  final String? title;

  LoginPage({ Key? key, this.title}) : super(key: key);


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  late FocusScopeNode focusScopeNode;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: buildBody(context),
    );
  }

  void _changeFocusNode(BuildContext context){
    if (focusScopeNode == null){
      focusScopeNode = FocusScope.of(context);
    }
    //将焦点从第一个TextField移到第二个TextField
    // 这是一种写法
    // FocusScope.of(context).requestFocus(focusNode2);
    if (!focusNode1.hasFocus) {
      focusScopeNode.requestFocus(focusNode1);

    } else {
      focusScopeNode.requestFocus(focusNode2);
    }
    // ddlog(focusNode1.hasFocus);
    // ddlog(focusNode2.hasFocus);
  }

  void _unfocusNodes(){
    // 当所有编辑框都失去焦点时键盘就会收起
    focusNode1.unfocus();
    focusNode2.unfocus();
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            focusNode: focusNode1, //关联focusNode1
            decoration: InputDecoration(
                labelText: "name"
            ),
          ),
          TextField(
            focusNode: focusNode2, //关联focusNode2
            decoration: InputDecoration(
                labelText: "password"
            ),
          ),
          Builder(builder: (ctx) {
            return Column(
              children: <Widget>[
                TextButton(
                  child: Text("移动焦点"),
                  onPressed: () {
                    _changeFocusNode(context);
                  },
                ),
                TextButton(
                  child: Text("隐藏键盘"),
                  onPressed: () {
                    _unfocusNodes();
                  },
                ),
              ],
            );
          },
          ),
        ],
      ),
    );
  }
}