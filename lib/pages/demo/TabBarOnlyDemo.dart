//
//  TabBarOnlyDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/6/23 6:34 PM.
//  Copyright © 1/6/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/tab_bar_segment.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/uti/R.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/pages/demo/TabBarDemo.dart';

class TabBarOnlyDemo extends StatefulWidget {

  const TabBarOnlyDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TabBarOnlyDemoState createState() => _TabBarOnlyDemoState();
}

class _TabBarOnlyDemoState extends State<TabBarOnlyDemo> with TickerProviderStateMixin {

  late TabController _tabController;
  late TabController _tabController1;

  /// 初始索引
  int initialIndex = 1;
  /// 当前索引
  int currentIndex = 0;

  List<String> titles = List.generate(9, (index) => 'item_$index').toList();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: titles.length, vsync: this)
      ..addListener(() {
        if(!_tabController.indexIsChanging){
          debugPrint("_tabController:${_tabController.index}");
          setState(() {
            currentIndex = _tabController.index;
          });
        }
      });

    _tabController1 = TabController(length: tabItems.length, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(R.image.urls[5]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(widget.title ?? "$widget"),
        actions: ['reset',].map((e) => TextButton(
          onPressed: onDone,
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
        )).toList(),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => debugPrint("onTap $index"),
          isScrollable: true,
          // tabs: titles.map((e) => Tab(text: e,)).toList(),
          tabs: titles.map((e) => buildItem(e)).toList(),
          // indicatorSize: TabBarIndicatorSize.label,
          // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 3,
              color: Colors.red,
            )
          ),
        ),
      ),
      // body: _buildBody(),
      body: _buildTabBarPage(controller: _tabController1),
    );
  }

  _buildBody() {
    return Column(
      children: [
        Text(currentIndex.toString()),
      ],
    );
  }

  /// TabBar 脱离 AppBar
  Widget _buildTabBarPage({
    TabController? controller,
    double barHeight = 50,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){

        return Column(
          children: [
            Container(
              color: Colors.blue,
              height: barHeight,
              child: TabBar(
                controller: controller,
                isScrollable: true,
                // padding: EdgeInsets.symmetric(horizontal: 42),
                // indicatorPadding: EdgeInsets.symmetric(horizontal: 42),
                labelPadding: EdgeInsets.symmetric(horizontal: 30),
                tabs: tabItems.map((e) => Tab(icon: e.item1)).toList(),
              ),
            ),
            Container(
              height: constraints.maxHeight - barHeight,
              child: TabBarView(
                controller: controller,
                children: tabItems.map((e) => e.item2).toList(),
              ),
            ),
          ],
        );
      }
    );
  }

  Widget buildItem(String e) {
    if (titles.indexOf(e) != 1){
      return Tab(text: e);
    }
    final url = currentIndex == _tabController.index ? R.image.urls[1] : R.image.urls[0];
    return Tab(
      child: FadeInImage(
        image: NetworkImage(url),
        placeholder: AssetImage("images/flutter_logo.png"),
      ),
    );
  }

  onDone() {
    debugPrint("onDone");
    _tabController.index = initialIndex;
  }

}



class BottomTabBar extends StatefulWidget {

  BottomTabBar({
    Key? key,
    this.title,
    required this.tabCount,
    required this.itembuilder,
    required this.onClick,
    this.controller,
  }) : super(key: key);

  String? title;

  int tabCount;

  IndexedWidgetBuilder itembuilder;

  TabController? controller;

  IndexedCallback onClick;

  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  /// 初始索引
  int initialIndex = 1;
  /// 当前索引
  int currentIndex = 0;


  @override
  void initState() {
    super.initState();

    _tabController = widget.controller ?? TabController(length: widget.tabCount, vsync: this)
      ..addListener(() {
        if(!_tabController.indexIsChanging){
          debugPrint("_tabController:${_tabController.index}");
          setState(() {
            currentIndex = _tabController.index;
            widget.onClick(context, currentIndex);
          });
        }
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = List.generate(widget.tabCount, (index) => widget.itembuilder(context, index)).toList();

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: tabs,
    );
  }

}