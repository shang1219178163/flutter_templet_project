//
//  NTabBarViewCustomDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/9 09:47.
//  Copyright © 2024/3/9 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_page_custom.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

class NTabBarViewCustomDemo extends StatefulWidget {
  NTabBarViewCustomDemo({super.key, this.title});

  final String? title;

  @override
  State<NTabBarViewCustomDemo> createState() => _NTabBarViewCustomDemoState();
}

class _NTabBarViewCustomDemoState extends State<NTabBarViewCustomDemo> {
  late List<({AssetImage unselected, AssetImage selected, Widget child})> items = [
    (
      unselected: AssetImage("assets/images/icon_inquiry_pay_unselected.png"),
      selected: AssetImage("assets/images/icon_inquiry_pay_selected.png"),
      child: buildSubpage(prefix: "选项zero"),
    ),
    (
      unselected: AssetImage("assets/images/icon_inquiry_rights_unselected.png"),
      selected: AssetImage("assets/images/icon_inquiry_rights_selected.png"),
      child: buildSubpage(prefix: "选项one"),
    ),
    (
      unselected: AssetImage("assets/images/icon_inquiry_pay_unselected.png"),
      selected: AssetImage("assets/images/icon_inquiry_pay_selected.png"),
      child: buildSubpage(prefix: "选项two"),
    ),
  ];

  var isThemeBg = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    isThemeBg = !isThemeBg;
                    setState(() {});
                  },
                ))
            .toList(),
        // bottom: buildTabBar(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        NText("TabBar 自定义图片"),
        Expanded(
          child: buildTabView(),
        ),
      ],
    );
  }

  Widget buildTabView() {
    return NTabBarPageCustom(
      items: items,
      // tabBarAlignment: Alignment.centerLeft,
      isThemeBg: isThemeBg,
      isScrollable: true,
      onChanged: (index) {
        DLog.d("NTabBarPage onChanged: $index");
      },
      onTabBar: (index) {
        DLog.d("NTabBarPage onTabBar: $index");
      },
      // headerBuilder: (context, index) {
      //   return Container(
      //     color: Colors.green,
      //     height: 35,
      //     child: NText("NTabBarPage headerBuilder: $index"),
      //   );
      // },
      // middleBuilder: (context, index) {
      //   return Container(
      //     color: Colors.green,
      //     height: 35,
      //     child: NText("NTabBarPage middleBuilder: $index"),
      //   );
      // },
      // footerBuilder:  (context, index) {
      //   return Container(
      //     color: Colors.green,
      //     height: 35,
      //     child: NText("NTabBarPage footerBuilder: $index"),
      //   );
      // },
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
