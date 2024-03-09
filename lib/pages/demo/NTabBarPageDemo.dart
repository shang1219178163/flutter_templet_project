//
//  NTabBarPageDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/9 09:47.
//  Copyright © 2024/3/9 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_page.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:tuple/tuple.dart';

class NTabBarPageDemo extends StatefulWidget {

  NTabBarPageDemo({
    super.key,
    this.title
  });

  final String? title;

  @override
  State<NTabBarPageDemo> createState() => _NTabBarPageDemoState();
}

class _NTabBarPageDemoState extends State<NTabBarPageDemo> {

  late List<Tuple2<String, Widget>> items = [
    Tuple2('功能列表', buildSubpage(prefix: "选项zero")),
    Tuple2('功能列表1', buildSubpage(prefix: "选项one")),
    Tuple2('功能列表2', buildSubpage(prefix: "选项two")),
    // Tuple2('功能列表3', buildSubpage(prefix: "选项three")),
    // Tuple2('功能列表4', buildSubpage(prefix: "选项four")),
    // Tuple2('功能列表5', buildSubpage(prefix: "选项five")),
  ];

  var isThemeBg = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            isThemeBg = !isThemeBg;
            setState(() {});
          },)
        ).toList(),
        // bottom: buildTabBar(),
      ),
      body: NTabBarPage(
        items: items,
        // tabBarAlignment: Alignment.centerLeft,
        isThemeBg: isThemeBg,
        onChanged: (index){
          ddlog("NTabBarPage onChanged: $index");
        },
        onTabBar: (index){
          ddlog("NTabBarPage onTabBar: $index");
        },
      ),
    );
  }

  Widget buildSubpage({String prefix = "选项"}) {
    return ListView.separated(
      cacheExtent: 180,
      itemCount: 20,
      itemBuilder: (context, index) {

        return ListTile(
          title: Text("${prefix}_$index"),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }

}