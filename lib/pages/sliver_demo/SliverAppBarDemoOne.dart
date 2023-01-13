//
//  SliverAppBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/8/21 6:00 PM.
//  Copyright © 6/8/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

class SliverAppBarDemoOne extends StatefulWidget {

  final String? title;

  SliverAppBarDemoOne({ Key? key, this.title}) : super(key: key);


  @override
  _SliverAppBarDemoOneState createState() => _SliverAppBarDemoOneState();
}

class _SliverAppBarDemoOneState extends State<SliverAppBarDemoOne> with SingleTickerProviderStateMixin {
  var pages = List.generate(3, (index) => "Tab $index");

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: pages.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.title ?? "$widget"),
        // ),
        body: buildDefaultTabController(context),
    );
  }


  Widget buildDefaultTabController(BuildContext context) {
    return
    DefaultTabController(
      length: pages.length, // This is the number of tabs.
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(widget.title ?? "$widget"),
                centerTitle: false,
                pinned: true,
                floating: false,
                snap: false,
                primary: true,
                expandedHeight: 300,

                elevation: 10,
                //是否显示阴影，直接取值innerBoxIsScrolled，展开不显示阴影，合并后会显示
                forceElevated: innerBoxIsScrolled,

                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      print("更多");
                    },
                  ),
                ],

                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset("images/bg.png", fit: BoxFit.fill),
                  // background: Container(
                  //   padding: EdgeInsets.fromLTRB(20, 100, 20, 60),
                  //   // height: 80,
                  //   color: Colors.green,
                  //   child: _buildTopMenu(context),
                  // ),
                ),
                bottom: TabBar(
                  tabs: pages.map((String name) => Tab(text: name)).toList(),
                  controller: this._tabController,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                ),
              ),
            ),
          ];
        },
        body: buildTabBarView(context),
      ),
    );
  }

  Widget buildTabBarView(BuildContext context) {
    return
    TabBarView(
      controller: this._tabController,
      // These are the contents of the tab views, below the tabs.
      children: pages.map((String name) {
        //SafeArea 适配刘海屏的一个widget
        return SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (BuildContext context) {
              return CustomScrollView(
                key: PageStorageKey<String>(name),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(10.0),
                    sliver: SliverFixedExtentList(
                      itemExtent: 50.0, //item高度或宽度，取决于滑动方向
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return ListTile(title: Text('Item $index, tab${_tabController.index}'),
                        );
                      },
                        childCount: 20,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopMenu(BuildContext context) {
    final list = List.generate(8, (index) => "item_$index");

    return Container(
      // height: 160,
      color: Colors.orange,
      child: Scrollbar(
        child: GridView.count(
          // physics: NeverScrollableScrollPhysics(),
          // padding: EdgeInsets.all(15.0),
          //一行多少个
          crossAxisCount: 4,
          //滚动方向
          scrollDirection: Axis.vertical,
          // 左右间隔
          crossAxisSpacing: 8,
          // 上下间隔
          mainAxisSpacing: 8,
          //宽高比
          // childAspectRatio: 3 / 4,
          children: list.map((e) => _buildMenuItem(context, top: FlutterLogo(), bottom: Text(e))).toList(),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required Widget top, required Widget bottom}) {
    return Container(
      color: ColorExt.random,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          top,
          bottom,
        ],
      ),
    );
  }
}
