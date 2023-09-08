import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/pages/FirstPage.dart';
import 'package:flutter_templet_project/pages/SecondPage.dart';
import 'package:flutter_templet_project/pages/ThirdPage.dart';
import 'package:flutter_templet_project/pages/FourthPage.dart';
import 'package:flutter_templet_project/pages/BatterLevelPage.dart';


class TabBarDemo extends StatefulWidget {


  TabBarDemo({
    Key? key,
    this.title,
    this.initialIndex = 4,
  }) : super(key: key);

  String? title;

  int initialIndex;

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> with AutomaticKeepAliveClientMixin{


  // theme: Get.isDarkMode ? ThemeData.dark(): ThemeData.light(),
  /// 当前主题
  ThemeData get themeData => Get.isDarkMode ? APPThemeService().darkThemeData : APPThemeService().themeData;

  @override
  Widget build(BuildContext context) {
    super.build(context);//必须添加

    return MaterialApp(
      theme: themeData,
      home: DefaultTabController(
        initialIndex: widget.initialIndex,
        length: tabItems.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: tabItems.map((e) => Tab(icon: e.item1)).toList(),
            ),
            title: Text('$widget'),
          ),
          body: TabBarView(
            children: tabItems.map((e) => e.item2).toList(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}

/// Tab 数组
final tabItems = <Tuple2<Icon, Widget>>[
  Tuple2(
    Icon(Icons.directions_railway),
    FirstPage(),
  ),
  Tuple2(
    Icon(Icons.directions_car),
    SecondPage(),
  ),
  Tuple2(
    Icon(Icons.directions_bus),
    ThirdPage(),
  ),
  Tuple2(
    Icon(Icons.directions_bike),
    FourthPage(),
  ),
  Tuple2(
    Icon(Icons.directions_boat),
    BatterLevelPage(),
  ),
];