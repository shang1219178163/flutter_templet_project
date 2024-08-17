import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_pinned_tab_bar_page.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/pages/demo/NRefreshViewDemo.dart';
import 'package:get/get.dart';

class NPinnedTabBarPageDemo extends StatefulWidget {
  NPinnedTabBarPageDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NPinnedTabBarPageDemo> createState() => _NPinnedTabBarPageDemoState();
}

class _NPinnedTabBarPageDemoState extends State<NPinnedTabBarPageDemo>
    with SingleTickerProviderStateMixin {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  late final List<({Tab tab, Widget child})> tabItems = [
    (
      tab: Tab(
        text: "选项卡0",
      ),
      child: buildList(tabIndex: 1)
    ),
    (
      tab: Tab(
        text: "选项卡1",
      ),
      child: buildList(tabIndex: 2)
    ),
    (
      tab: Tab(
        text: "选项卡2",
      ),
      child: buildList(tabIndex: 3)
    ),
    (
      tab: Tab(
        text: "选项卡3",
      ),
      child: buildList(tabIndex: 4)
    ),
    (
      tab: Tab(
        text: "选项卡4",
      ),
      child: buildList(tabIndex: 5)
    ),
  ];

  late final tabController =
      TabController(length: tabItems.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NPinnedTabBarPage(
        title: Text("NPinnedTabBarPage"),
        expandedHeight: 300,
        expandedHeader: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(color: Colors.blue),
          ),
          child: Text(
            "Collapsing Toolbar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        tabItems: tabItems,
      ),
    );

    return Scaffold(
      body: buildPinnedTabBar(
        title: Text("buildPinnedTabBar"),
        expandedHeight: 300,
        expandedHeader: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(color: Colors.blue),
          ),
          child: Text(
            "Collapsing Toolbar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        tabItems: tabItems,
      ),
    );
  }

  Widget buildPinnedTabBar({
    required Text title,
    List<Widget>? actions,
    double expandedHeight = 200,
    required Widget expandedHeader,
    required List<({Tab tab, Widget child})> tabItems,
    Color backgroudColor = Colors.white,
    Color labelColor = Colors.blue,
  }) {
    return Scaffold(
      body: DefaultTabController(
        length: tabItems.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            final top = mediaQuery.viewPadding.top + kToolbarHeight;
            return <Widget>[
              SliverAppBar(
                expandedHeight: expandedHeight,
                floating: false,
                pinned: true,
                title: title,
                actions: actions,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: EdgeInsets.only(
                      top: top,
                    ),
                    // decoration: BoxDecoration(
                    //   color: Colors.green,
                    //   border: Border.all(color: Colors.blue),
                    // ),
                    child: expandedHeader,
                  ),
                ),
              ),
              NSliverPersistentHeaderBuilder(
                pinned: true,
                builder: (context, offset, overlapsContent) {
                  final tabBar = TabBar(
                    controller: tabController,
                    // labelColor: Colors.black87,
                    // unselectedLabelColor: Colors.grey,
                    padding: EdgeInsets.zero,
                    tabs: tabItems.map((e) => e.tab).toList(),
                  );

                  // Color backgroudColor = Colors.blue;
                  // Color labelColor = Colors.white;
                  //
                  // backgroudColor = Colors.white;
                  // labelColor = Colors.blue;

                  return Material(
                    color: backgroudColor,
                    child: Theme(
                      data: ThemeData(
                        splashColor: Colors.transparent, // 点击时的水波纹颜色设置为透明
                        highlightColor: Colors.transparent, // 点击时的背景高亮颜色设置为透明
                        tabBarTheme: TabBarTheme(
                          dividerColor: Colors.transparent,
                          labelColor: labelColor,
                          unselectedLabelColor: labelColor,
                          indicatorColor: labelColor,
                        ),
                      ),
                      child: tabBar,
                    ),
                  );
                },
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: tabItems.map((e) {
              return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Builder(builder: (context) {
                  return e.child;
                  return buildList(tabIndex: tabController.index);
                }),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildList({required int tabIndex}) {
    if (tabIndex == 1) {
      return NRefreshViewDemo();
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return buildCell(index: index);
      },
      itemCount: 20,
    );
  }

  Widget buildCell({required int index}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(bottom: BorderSide(color: Colors.blue)),
      ),
      child: ListTile(
        title: Text('${tabController.index}, Item #$index,'),
      ),
    );
  }
}
