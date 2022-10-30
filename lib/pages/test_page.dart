//
//  TestPage.dart
//  flutter_templet_project
//
//  Created by shang on 12/2/21 2:16 PM.
//  Copyright © 12/2/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/Language/Property.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_extension.dart';
import 'package:flutter_templet_project/extension/map_extension.dart';

import 'package:flutter_templet_project/extension/buildContext_extension.dart';


class TestPage extends StatefulWidget {

  final String? title;

  TestPage({ Key? key, this.title}) : super(key: key);

  
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  var titles = ["splitMapJoin", "1", "2", "3", "4", "5", "6", "7"];

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(
          children: [
            buildWrap(context),
          ],
        )
    );
  }

  Wrap buildWrap(BuildContext context) {
    return Wrap(
      spacing: 8.0, // 主轴(水平)方向间距
      runSpacing: 8.0, // 纵轴（垂直）方向间距
      alignment: WrapAlignment.start, //沿主轴方向居中
      children: titles.map((e) => ActionChip(
        avatar: CircleAvatar(backgroundColor: Theme.of(context).primaryColor,
            child: Text("${e.characters.first.toUpperCase()}")
        ),
        label: Text(e),
        onPressed: (){
          _onPressed(titles.indexOf(e));
        },
      )).toList(),
    );
  }

  void _onPressed(int e) {
    final a = 'Eats shoots leaves'.splitMapJoin((RegExp(r'shoots')),
         onMatch:    (m) => '${m[0]}',  // (or no onMatch at all)
         onNonMatch: (n) => '*'); // Result: "*shoots*"
    ddlog(a);

    final b = 'Eats shoots leaves'.splitMapJoin((RegExp(r's|o')),
        onMatch: (m) => "_",
    );
    ddlog(b);

    final c = 'Eats shoots leaves'.split(RegExp(r's|o'));
    ddlog(c);

    final d = "easy_refresh_plugin".camlCase("_");
    ddlog(d);

    final d1 = "easyRefreshPlugin".uncamlCase("_");
    ddlog(d1);

    final d2 = "easyRefreshPlugin".toCapitalize();
    ddlog(d2);

    ddlog(screenSize);

    showSnackBar(SnackBar(content: Text(d2)));

    Map<String, dynamic> map = {
      'msgType': '5',
      'msgTag': '官方号',
      'msgUnreadNum': 3,
    };

    ddlog('getUrlParams():${getUrlParams(map: map)}');
    ddlog('map.join():${map.join()}' );
  }

  getUrlParams({Map<String, dynamic> map = const {}}) {
    if (map.keys.length == 0) {
      return '';
    }
    String paramStr = '';
    map.forEach((key, value) {
      paramStr += '${key}=${value}&';
    });
    String result = paramStr.substring(0, paramStr.length - 1);
    return result;
  }

  testProperty(){
    // PropertyInfo.getVariableType();
  }
}
