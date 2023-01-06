import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/pages/FirstPage.dart';
import 'package:flutter_templet_project/pages/SecondPage.dart';
import 'package:flutter_templet_project/pages/ThirdPage.dart';
import 'package:flutter_templet_project/pages/FourthPage.dart';
import 'package:flutter_templet_project/pages/BatterLevelPage.dart';
import 'package:flutter_templet_project/uti/R.dart';


class TabBarDemoNew extends StatefulWidget {

  final String? title;

  TabBarDemoNew({ Key? key, this.title}) : super(key: key);

  @override
  _TabBarDemoNewState createState() => _TabBarDemoNewState();
}

class _TabBarDemoNewState extends State<TabBarDemoNew> with SingleTickerProviderStateMixin{
  late TabController _tabController;

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
  void initState() {
    super.initState();

    _tabController = TabController(length: items.length, vsync: this)
      ..addListener(() {
        if(!_tabController.indexIsChanging){
          print("_tabController:${_tabController.index}");
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title ?? "$widget"}"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(R.image.imgUrls[5]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: items.map((e) => e.item1).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: items.map((e) => e.item2).toList(),
      ),
    );
  }
}