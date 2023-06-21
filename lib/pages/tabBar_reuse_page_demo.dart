//
//  TabBarPageViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 5:11 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/app_update_card.dart';
import 'package:flutter_templet_project/basicWidget/list_subtitle_cell.dart';
import 'package:flutter_templet_project/basicWidget/tabBar_pageView.dart';
import 'package:flutter_templet_project/basicWidget/tabBar_tabBarView.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/divider_ext.dart';
import 'package:flutter_templet_project/model/mock_data.dart';
import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';
import 'package:tuple/tuple.dart';


class TabBarReusePageDemo extends StatefulWidget {

  final String? title;

  const TabBarReusePageDemo({ Key? key, this.title}) : super(key: key);


  @override
  _TabBarReusePageDemoState createState() => _TabBarReusePageDemoState();
}

class _TabBarReusePageDemoState extends State<TabBarReusePageDemo> {

  bool isPageView = true;

  bool isTop = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(isPageView ? "TabBarPageView" : "TabBarTabBarView"),
        actions: [
          TextButton(
            onPressed: () {
              isPageView = !isPageView;
              setState(() {});
            },
            child: Icon(Icons.change_circle_outlined, color: Colors.white,)
          ),
          TextButton(onPressed: () {
            isTop = !isTop;
            setState(() {});
          },
            child: Text(isTop ? "底部" : "顶部", style: TextStyle(color: Colors.white),)
          ),
        ],
      ),
      body: isPageView ? _buildTabBarPageView() : _buildTabBarTabBarView(),
    );
  }

  Widget _buildTabBarPageView() {
    return TabBarPageView(
      isTabBarTop: isTop,
      items: _items,
      canPageChanged: (index) {
        return (index != 1);
      },
      onPageChanged: (index) {
        ddlog(index);
      }
    );
  }

  Widget _buildTabBarTabBarView() {
    return TabBarTabBarView(
      isTabBarTop: isTop,
      items: _items,
      // canPageChanged: (index) {
      //   return (index != 1);
      // },
      onPageChanged: (index) {
        ddlog(index);
      }
    );
  }

  final List<Tuple2<String, Widget>> _items = [
    Tuple2('功能列表', ListView.separated(
      cacheExtent: 180,
      itemCount: kAliPayList.length,
      itemBuilder: (context, index) {
        final data = kAliPayList[index];
        return ListSubtitleCell(
          padding: EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              data.imageUrl,
              width: 40,
              height: 40,
            ),
          ),
          title: Text(
            data.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          subtitle: Text(data.content,
            // maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF999999),
            ),
          ),
          trailing: Text(data.time,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
            ),
          ),
          subtrailing: Text("已完成",
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return DividerExt.custome();
      },
    )),

    Tuple2('升级列表', ListView.separated(
      cacheExtent: 180,
      itemCount: kUpdateAppList.length,
      itemBuilder: (context, index) {
        final data = kUpdateAppList[index];
        if (index == 0) {
          return AppUpdateCard(data: data, isExpand: true, showExpand: false,);
        }
        return AppUpdateCard(data: data);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    )),

    Tuple2('升级列表(新)', ListView.separated(
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