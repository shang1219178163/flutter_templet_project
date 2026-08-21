//
//  TabBarPageViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 5:11 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/app_update_card.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_view.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_page_view.dart';
import 'package:flutter_templet_project/model/mock_data.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:tuple/tuple.dart';

class TabBarReusePageDemo extends StatefulWidget {
  const TabBarReusePageDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TabBarReusePageDemoState createState() => _TabBarReusePageDemoState();
}

class _TabBarReusePageDemoState extends State<TabBarReusePageDemo> {
  bool isPageView = true;

  bool isBom = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isPageView ? "NTabPageView" : "NTabBarView"),
        actions: [
          TextButton(
              onPressed: () {
                isPageView = !isPageView;
                setState(() {});
              },
              child: Icon(
                Icons.change_circle_outlined,
                color: Colors.white,
              )),
          TextButton(
              onPressed: () {
                isBom = !isBom;
                setState(() {});
              },
              child: Text(
                !isBom ? "底部" : "顶部",
                style: TextStyle(color: Colors.white),
              )),
        ],
        elevation: 0,
      ),
      body: isPageView ? buildTabPageView() : buildTabBarView(),
    );
  }

  Widget buildTabPageView() {
    return NTabPageView(
        items: _items,
        isTabBottom: isBom,
        // labelColor: Colors.white,
        // canPageChanged: (index) {
        //   return (index != 1);
        // },
        onPageChanged: (index) {
          DLog.d(index);
        });
  }

  Widget buildTabBarView() {
    return NTabBarView(
        items: _items,
        isTabBottom: isBom,
        labelColor: Colors.white,
        tabBgColor: Colors.blue,

        // canPageChanged: (index) {
        //   return (index != 1);
        // },
        onPageChanged: (index) {
          DLog.d(index);
        });
  }

  final List<Tuple2<String, Widget>> _items = [
    Tuple2(
        '升级列表',
        ListView.separated(
          cacheExtent: 180,
          itemCount: kUpdateAppList.length,
          itemBuilder: (context, index) {
            final data = kUpdateAppList[index];
            if (index == 0) {
              return AppUpdateCard(
                data: data,
                isExpand: true,
                showExpand: false,
              );
            }
            return AppUpdateCard(data: data);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        )),
    Tuple2(
        '升级列表(新)',
        ListView.separated(
          cacheExtent: 180,
          itemCount: kUpdateAppList.length,
          itemBuilder: (context, index) {
            final data = kUpdateAppList[index];
            return AppUpdateCard(data: data);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        )),
  ];
}
