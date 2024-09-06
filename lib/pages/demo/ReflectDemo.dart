//
//  ReflectDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/13/23 11:03 AM.
//  Copyright © 3/13/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/model/app_update_model.dart';

class ReflectDemo extends StatefulWidget {
  const ReflectDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ReflectDemoState createState() => _ReflectDemoState();
}

class _ReflectDemoState extends State<ReflectDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onPressed,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                width: double.infinity,
                color: ColorExt.random,
                padding: EdgeInsets.all(8),
                child: Wrap(
                  children: [
                    ElevatedButton(
                        onPressed: onPressed, child: Text("Iterable")),
                  ],
                ),
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  onPressed() {
    var model = AppModel(
        appIcon: "assets/icon_light_unselected.png",
        appSize: "53.2M",
        appName: "QQ音乐 - 让生活充满音乐",
        appDate: "13:50",
        appDescription: """【全新设计 纯净享受】
    -重塑全新视觉，轻盈/纯净/无扰/为Mac系统量身设计，从内而外纯净享受；
    -全新结构设计，整体交互优化/人性化和易用性大提升，操作体验豪华升级"；
  """,
        appVersion: "版本 7.6.0",
        isShowAll: false);

    debugPrint(
        "appName before: ${model["appName"]}"); //flutter: appName before: QQ音乐 - 让生活充满音乐
    model["appName"] = "哈哈哈哈";
    debugPrint("appName after: ${model["appName"]}"); //flutter: appName1: 哈哈哈哈
  }
}
