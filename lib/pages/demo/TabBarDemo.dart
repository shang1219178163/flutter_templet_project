import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_templet_project/pages/FirstPage.dart';
import 'package:flutter_templet_project/pages/SecondPage.dart';
import 'package:flutter_templet_project/pages/ThirdPage.dart';
import 'package:flutter_templet_project/pages/FourthPage.dart';
import 'package:flutter_templet_project/pages/BatterLevelPage.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class TabBarDemo extends StatefulWidget {

  final String? title;

  TabBarDemo({ Key? key, this.title}) : super(key: key);

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> with AutomaticKeepAliveClientMixin{

  final List<Tuple2<Tab, Widget>> items = [
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
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            // leading: Icon(Icons.arrow_back)
            //         // .gestures(onTap: ()=> ddlog("back")
            //           .gestures(onTap: (){ Navigator.pop(context); }),
            bottom: TabBar(
              tabs: items.map((e) => e.item1).toList(),
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: items.map((e) => e.item2).toList(),
          ),
        ),
      ),
    );
  }
}