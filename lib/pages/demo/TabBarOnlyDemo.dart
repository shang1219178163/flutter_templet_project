//
//  TabBarOnlyDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/6/23 6:34 PM.
//  Copyright © 1/6/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';
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

  List<String> items = List.generate(6, (index) => 'item_$index').toList();

  var titles = ["splitMapJoin", "1", "2", "3", "4", "5", "6", "7"];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: items.length, vsync: this)
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
            controller: _tabController,
            isScrollable: true,
            tabs: List.generate(6, (index) => Tab(text: 'item_$index')).toList(),
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
          child: Text("${currentIndex}"),
        )
    );
  }


  onDone() {
    print("onDone");
    _tabController.index = initialIndex;
  }
}

