//
//  TabBarPageViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_subtitle_cell.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/divider_ext.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/main.dart';
import 'package:flutter_templet_project/basicWidget/app_update_card.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/basicWidget/section_list_view.dart';
import 'package:flutter_templet_project/model/mock_data.dart';
import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';

import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/extension/widget_ext.dart';

class TabBarPageViewDemo extends StatefulWidget {
  final String? title;

  const TabBarPageViewDemo({Key? key, this.title}) : super(key: key);

  @override
  _TabBarPageViewDemoState createState() => _TabBarPageViewDemoState();
}

class _TabBarPageViewDemoState extends State<TabBarPageViewDemo> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: items.length, vsync: this);

  late final PageController _pageController = PageController(initialPage: 0, keepPage: true);

  var isTabBar = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('页面封装'),
        actions: [
          TextButton(
            onPressed: () {
              isTabBar.value = !isTabBar.value;
              setState(() {});
            },
            child: Text(
              isTabBar.value ? "top" : "bottom",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        bottom: isTabBar.value ? null : _buildTabBar(),
      ),
      body: _buildPageView(),
      bottomNavigationBar: !isTabBar.value ? null : _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      // persistentFooterButtons: persistentFooterButtons(),
    );
  }

  PreferredSize _buildPreferredSize(Widget child) {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: Theme(
        data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white)),
        child: Container(
          height: 40,
          alignment: Alignment.center, //圆点居中
          //给自定义导航栏设置圆点控制器
          child: child,
        ),
      ),
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: items.map((e) => Tab(text: e.item1)).toList(),
      indicatorSize: TabBarIndicatorSize.label,
      // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
      onTap: (index) {
        setState(() {
          _pageController.jumpToPage(index);
        });
      },
    );
  }

  Material _buildBottomNavigationBar() {
    final textColor = Theme.of(context).colorScheme.secondary;
    const bgColor = Colors.white;

    // final bgColor = Theme.of(context).colorScheme.secondary;
    // final textColor = Colors.white;

    return Material(
        color: bgColor,
        child: SafeArea(
          child: TabBar(
            controller: _tabController,
            tabs: items.map((e) => Tab(text: e.item1)).toList(),
            labelColor: textColor,
            indicator: BoxDecoration(
              border: Border(
                top: BorderSide(
                    // color: textColor ,
                    color: textColor,
                    width: 3.0),
              ),
            ),
            onTap: (index) {
              DLog.d(index);
              setState(() {
                // _tabController.animateTo(index);
                _pageController.jumpToPage(index);
              });
            },
          ),
        ));
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _tabController.animateTo(index);
        setState(() {});
      },
      // children: _pages.map((e) => Tab(text: e.item1)).toList(),
      children: items.map((e) => e.item2).toList(),
    );
  }

  List<Widget> persistentFooterButtons() {
    return [
      TextButton(
        onPressed: () => setState(() => debugPrint('button1 tapped')),
        child: Text(
          'Button 1',
        ),
      ),
      IconButton(
        icon: Icon(Icons.map),
        onPressed: () => setState(() => debugPrint('button1 tapped')),
      ),
      IconButton(
        icon: Icon(Icons.mail),
        onPressed: () => setState(() => debugPrint('button1 tapped')),
      ),
    ];
  }

  List<Tuple2<String, Widget>> items = [
    Tuple2(
        '功能列表',
        ListView.separated(
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
              subtitle: Text(
                data.content,
                // maxLines: 1,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF999999),
                ),
              ),
              trailing: Text(
                data.time,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              ),
              subtrailing: Text(
                "已完成",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue,
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
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
      '列表(泛型)',
      SectionListView<String, Tuple2<String, String>>(
        headerList: tuples.map((e) => e.item1).toList(),
        itemList: tuples
            .map((e) => e.item2)
            .toList()
            .map((e) => e.sorted((a, b) => a.item1.toLowerCase().compareTo(b.item1.toLowerCase())))
            .toList(),
        headerBuilder: (e) {
          return Container(
            // color: Colors.red,
            padding: EdgeInsets.only(top: 10, bottom: 8, left: 10, right: 15),
            child: Text(
              e,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        },
        itemBuilder: (section, row, e) {
          return ListTile(
            title: Text(e.item2),
            subtitle: Text(e.item2.toCapitalize()),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
            dense: true,
            onTap: () {
              Get.toNamed(e.item1, arguments: e);
              if (e.item1.toLowerCase().contains("loginPage".toLowerCase())) {
                Get.offNamed(e.item1, arguments: e.item1);
              } else {
                Get.toNamed(e.item1, arguments: e.item1);
              }
            },
          );
        },
      ),
    ),
  ];
}
