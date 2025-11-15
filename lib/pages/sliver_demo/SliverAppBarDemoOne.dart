//
//  SliverAppBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/8/21 6:00 PM.
//  Copyright © 6/8/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class SliverAppBarDemoOne extends StatefulWidget {
  final String? title;

  const SliverAppBarDemoOne({Key? key, this.title}) : super(key: key);

  @override
  _SliverAppBarDemoOneState createState() => _SliverAppBarDemoOneState();
}

class _SliverAppBarDemoOneState extends State<SliverAppBarDemoOne> with SingleTickerProviderStateMixin {
  /// 嵌套滚动
  final scrollControllerNew = ScrollController();
  final scrollY = ValueNotifier(0.0);

  var items = List.generate(3, (index) => "Tab $index");

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    scrollControllerNew.addListener(() {
      scrollY.value = scrollControllerNew.offset;
    });
    tabController = TabController(length: items.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title ?? "$widget"),
      // ),
      body: buildDefaultTabController(),
    );
  }

  Widget buildDefaultTabController() {
    const collapsedHeight = 40.0;

    return DefaultTabController(
      length: items.length, // This is the number of tabs.
      child: NestedScrollView(
        controller: scrollControllerNew,
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
                title: ValueListenableBuilder(
                  valueListenable: scrollY,
                  builder: (context, value, child) {
                    try {
                      // YLog.d("scrollY: ${[
                      //   value,
                      //   scrollControllerNew.position.progress
                      // ]}");

                      final opacity = scrollControllerNew.position.progress > 0.9 ? 1.0 : 0.0;
                      return AnimatedOpacity(
                        opacity: opacity,
                        duration: const Duration(milliseconds: 100),
                        child: Row(
                          children: [
                            FlutterLogo(),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.60),
                              child: Text(widget.title ?? "$widget"),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      debugPrint("$this $e");
                    }
                    return const SizedBox();
                  },
                ),
                toolbarHeight: collapsedHeight,
                collapsedHeight: collapsedHeight,
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
                    onPressed: () => debugPrint("更多"),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  // background: Image.asset("assets/images/bg.png", fit: BoxFit.fill),
                  background: Container(
                    padding: EdgeInsets.fromLTRB(20, safeAreaTop, 20, 60),
                    // height: 80,
                    // color: Colors.green,
                    child: buildTopMenu(),
                  ),
                ),
                bottom: TabBar(
                  tabs: items.map((String name) => Tab(text: name)).toList(),
                  controller: tabController,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: buildTabBarView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      controller: tabController,
      // These are the contents of the tab views, below the tabs.
      children: items.map((String name) {
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
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return ListTile(
                            title: Text('Item $index, tab${tabController.index}'),
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

  Widget buildTopMenu() {
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
          children: list.map((e) => buildMenuItem(top: FlutterLogo(), bottom: Text(e))).toList(),
        ),
      ),
    );
  }

  Widget buildMenuItem({required Widget top, required Widget bottom}) {
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
