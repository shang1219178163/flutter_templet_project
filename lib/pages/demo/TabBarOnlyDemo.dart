//
//  TabBarOnlyDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/6/23 6:34 PM.
//  Copyright © 1/6/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/tab_bar_segment.dart';
import 'package:flutter_templet_project/uti/R.dart';

class TabBarOnlyDemo extends StatefulWidget {

  TabBarOnlyDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TabBarOnlyDemoState createState() => _TabBarOnlyDemoState();
}

class _TabBarOnlyDemoState extends State<TabBarOnlyDemo> with SingleTickerProviderStateMixin {

  late TabController _tabController;
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
          print("_tabController:${_tabController.index}");
          setState(() {
            currentIndex = _tabController.index;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(R.image.imgUrls[5]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(widget.title ?? "$widget"),
          actions: ['reset',].map((e) => TextButton(
            child: Text(e,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onDone,
          )).toList(),
          bottom: TabBar(
            // controller: _tabController,
            onTap: (index) => print("onTap $index"),
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
        body: Center(
          child: ListView(
            children: [
              Text("${currentIndex}"),

              Container(
                color: Colors.green,
                // width: 200,
                height: 100,
                child: BottomTabBar(
                  tabCount: titles.length,
                  onClick: (BuildContext context, int index) {
                    print("BottomTabBar ${index}");
                  },
                  itembuilder: (BuildContext context, int index) {
                    return Tab(text: titles[index]);
                  },
                ),
              )
            ],
          ),
        )
    );
  }

  Widget buildItem(String e) {
    if (titles.indexOf(e) != 1){
      return Tab(text: e);
    }
    final url = currentIndex == _tabController.index ? R.image.imgUrls[1] : R.image.imgUrls[0];
    return Tab(
      child: FadeInImage(
        image: NetworkImage(url),
        placeholder: AssetImage("images/flutter_logo.png"),
      ),
    );
  }

  onDone() {
    print("onDone");
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
          print("_tabController:${_tabController.index}");
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