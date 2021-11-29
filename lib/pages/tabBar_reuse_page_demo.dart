//
//  TabBarPageViewDemo.dart
//  fluttertemplet
//
//  Created by shang on 10/22/21 5:11 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:fluttertemplet/basicWidget/app_update_card.dart';
import 'package:fluttertemplet/basicWidget/list_subtitle_cell.dart';
import 'package:fluttertemplet/basicWidget/tabBar_pageView.dart';
import 'package:fluttertemplet/basicWidget/tabBar_tabBarView.dart';
import 'package:fluttertemplet/dartExpand/ddlog.dart';
import 'package:fluttertemplet/dartExpand/divider_extension.dart';
import 'package:fluttertemplet/mockData/mock_data.dart';
import 'package:fluttertemplet/pages/tabBar_tabBarView_demo.dart';
import 'package:tuple/tuple.dart';


class TabBarReusePageDemo extends StatefulWidget {

  final String? title;

  TabBarReusePageDemo({ Key? key, this.title}) : super(key: key);


  @override
  _TabBarReusePageDemoState createState() => _TabBarReusePageDemoState();
}

class _TabBarReusePageDemoState extends State<TabBarReusePageDemo> {


  bool isPageView = true;
  bool isTabBarTop = true;



  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute
        .of(context)!
        .settings
        .arguments;

    var val = isTabBarTop ? "底部" : "顶部";
    return Scaffold(
      appBar: AppBar(
        title: Text(isPageView ? "TabBarPageView" : "TabBarTabBarView"),
        actions: [
          TextButton(onPressed: () {
            ddlog("change");
            setState(() {
              isPageView = !isPageView;
            });
          }, child: Icon(Icons.change_circle_outlined, color: Colors.white,)),
          TextButton(onPressed: () {
            ddlog("change");
            setState(() {
              isTabBarTop = !isTabBarTop;
            });
          }, child: Text(val, style: TextStyle(color: Colors.white),)),
        ],
      ),
      body: isPageView ? _buildTabBarPageView() : _buildTabBarTabBarView(),
    );
  }

  Widget _buildTabBarPageView() {
    return
      TabBarPageView(
          isTabBarTop: isTabBarTop,
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
    return
      TabBarTabBarView(
          isTabBarTop: isTabBarTop,
          items: _items,
          // canPageChanged: (index) {
          //   return (index != 1);
          // },
          onPageChanged: (index) {
            ddlog(index);
          }
      );
  }

  List<Tuple2<String, Widget>> _items = [
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