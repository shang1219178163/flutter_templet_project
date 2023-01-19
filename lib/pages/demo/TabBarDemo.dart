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

  final items = <Tuple2<Tab, Widget>>[
    Tuple2(
      Tab(icon: Icon(Icons.directions_railway)),
      FirstPage(),
    ),
    Tuple2(
      Tab(icon: Icon(Icons.directions_car)),
      SecondPage(),
    ),
    Tuple2(
      Tab(icon: Icon(Icons.directions_bus)),
      ThirdPage(),
    ),
    Tuple2(
      Tab(icon: Icon(Icons.directions_bike)),
      FourthPage(),
    ),
    Tuple2(
      Tab(icon: Icon(Icons.directions_boat)),
      BatterLevelPage(),
    ),
  ];


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);//必须添加

    return MaterialApp(
      // theme: Get.isDarkMode ? ThemeData.dark(): ThemeData.light(),
      theme: Get.isDarkMode ? APPThemeSettings.instance.darkThemeData : APPThemeSettings.instance.themeData,
      home: DefaultTabController(
        initialIndex: widget.initialIndex,
        length: items.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: items.map((e) => e.item1).toList(),
            ),
            title: Text('$widget'),
          ),
          body: TabBarView(
            children: items.map((e) => e.item2).toList(),
          ),
        ),
      ),
    );
  }
}