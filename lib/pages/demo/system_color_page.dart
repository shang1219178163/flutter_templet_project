//
//  SystemColorPage.dart
//  flutter_templet_project
//
//  Created by shang on 2022/9/17 09:25.
//  Copyright © 2022/9/17 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/search_results_list_view.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

import 'package:flutter_templet_project/extension/widget_ext.dart';

// List<Color> others = [
//   Colors.transparent,
//   Colors.black,
//   Colors.black87,
//   Colors.black54,
//   Colors.black45,
//   Colors.black38,
//   Colors.black26,
//   Colors.black12,
//   Colors.white,
//   Colors.white70,
//   Colors.white60,
//   Colors.white54,
//   Colors.white38,
//   Colors.white30,
//   Colors.white24,
//   Colors.white12,
//   Colors.white10,];
// var list = [...others, ...Colors.primaries, ...Colors.accents];

class SystemColorPage extends StatefulWidget {
  const SystemColorPage({Key? key}) : super(key: key);

  @override
  _SystemColorPageState createState() => _SystemColorPageState();
}

class _SystemColorPageState extends State<SystemColorPage> {
  TextEditingController editingController = TextEditingController();

  var keys = List.from(kColorDic.keys);
  var searchResults = List.from(kColorDic.keys);

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter 系统颜色"),
        actions: [
          TextButton(
            onPressed: () {
              DLog.d("$widget");
            },
            child: Text(
              "Done",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SearchResultsListView(
        key: _globalKey,
        map: kColorDic,
        leadingBuilder: (key) => Container(
          color: kColorDic[key],
          width: 50,
          height: 50,
        ),
        tap: (obj) {
          debugPrint("obj:$obj");
        },
        itemBuilder: (context, index, searchResults) => _buildCell(context, index, searchResults),
      ),
    );
  }

  _buildCell(BuildContext context, int index, List searchResults) {
    final str = searchResults[index];
    var subtitle = kColorDic[str]
        .toString()
        .replaceAll('MaterialColor(primary value:', '')
        .replaceAll('MaterialAccentColor(primary value:', '')
        .replaceAll('))', ')');

    return ListTile(
      leading: Container(
        color: kColorDic[str],
        width: 40,
        height: 40,
      ),
      title: Text("$str"),
      subtitle: Text(subtitle),
      onTap: () {
        DLog.d(str);
        final value = "$str".split('.').last;

        final ctx = _globalKey.currentContext;
        final cs = _globalKey.currentState;
        final cw = _globalKey.currentWidget as SearchResultsListView?;
        cw?.searchCallback?.call(value);
      },
    );
  }
}

Map<String, dynamic> kColorDic = {
  "A基础: Colors.blue54 == Colors.blue.withOpacity(0.54)": Colors.transparent,
  "A基础: Colors.[white70, ..., white10], 只在暗黑模式有效果": Colors.white,

  "Colors.transparent": Colors.transparent,

  "Colors.black": Colors.black,
  "Colors.black54": Colors.black54,
  "Colors.black.withOpacity(0.54)": Colors.black.withOpacity(0.54),

  "Colors.blue": Colors.blue,
  "Colors.blue[500]": Colors.blue[500],
  "Colors.blue.shade500": Colors.blue.shade500,
  "Colors.blue.withOpacity(0.5)": Colors.blue.withOpacity(0.5),

  "Colors.blue.shade50": Colors.blue.shade50,
  "Colors.blue.shade100": Colors.blue.shade100,
  "Colors.blue.shade200": Colors.blue.shade200,
  "Colors.blue.shade300": Colors.blue.shade300,
  "Colors.blue.shade400": Colors.blue.shade400,
  // "Colors.blue.shade500": Colors.blue.shade500,
  "Colors.blue.shade600": Colors.blue.shade600,
  "Colors.blue.shade700": Colors.blue.shade700,
  "Colors.blue.shade800": Colors.blue.shade800,
  "Colors.blue.shade900": Colors.blue.shade900,

  "Colors.white": Colors.white,
  "Colors.white70": Colors.white70,
  "Colors.white60": Colors.white60,
  "Colors.white54": Colors.white54,
  "Colors.white38": Colors.white38,
  "Colors.white30": Colors.white30,
  "Colors.white24": Colors.white24,
  "Colors.white12": Colors.white12,
  "Colors.white10": Colors.white10,

  "Colors.red": Colors.red,
  "Colors.redAccent": Colors.redAccent,
  "Colors.pink": Colors.pink,
  "Colors.pinkAccent": Colors.pinkAccent,
  "Colors.purple": Colors.purple,
  "Colors.purpleAccent": Colors.purpleAccent,
  "Colors.deepPurple": Colors.deepPurple,
  "Colors.deepPurpleAccent": Colors.deepPurpleAccent,
  "Colors.indigo": Colors.indigo,
  "Colors.indigoAccent": Colors.indigoAccent,
  "Colors.blueAccent": Colors.blueAccent,
  "Colors.lightBlue": Colors.lightBlue,
  "Colors.lightBlueAccent": Colors.lightBlueAccent,
  "Colors.cyan": Colors.cyan,
  "Colors.cyanAccent": Colors.cyanAccent,
  "Colors.teal": Colors.teal,
  "Colors.tealAccent": Colors.tealAccent,
  "Colors.green": Colors.green,
  "Colors.greenAccent": Colors.greenAccent,
  "Colors.lightGreen": Colors.lightGreen,
  "Colors.lightGreenAccent": Colors.lightGreenAccent,
  "Colors.lime": Colors.lime,
  "Colors.limeAccent": Colors.limeAccent,
  "Colors.yellow": Colors.yellow,
  "Colors.yellowAccent": Colors.yellowAccent,
  "Colors.amber": Colors.amber,
  "Colors.amberAccent": Colors.amberAccent,
  "Colors.orange": Colors.orange,
  "Colors.orangeAccent": Colors.orangeAccent,
  "Colors.deepOrange": Colors.deepOrange,
  "Colors.deepOrangeAccent": Colors.deepOrangeAccent,
  "Colors.brown": Colors.brown,
  "Colors.grey": Colors.grey,
  "Colors.blueGrey": Colors.blueGrey,
};
