//
//  NPinnedTabBarPage.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/22 14:41.
//  Copyright © 2024/3/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_colored_box.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

/// 悬浮 TabBarPage
class NPinnedTabBarPage extends StatefulWidget {
  NPinnedTabBarPage({
    super.key,
    required this.title,
    this.actions,
    required this.expandedHeight,
    required this.expandedHeader,
    required this.tabItems,
    this.backgroudColor = Colors.white,
    this.labelColor = Colors.blue,
    this.tabBarTheme,
    this.tabAlignment = TabAlignment.center,
    this.isScrollable = false,
    this.labelPadding = const EdgeInsets.only(left: 8, right: 6),
    // this.arguments,
    // this.arguments,
    // this.arguments,
    // this.arguments,
    // this.arguments,
  });

  final Text title;
  final List<Widget>? actions;
  final double expandedHeight;
  final Widget expandedHeader;

  final List<({String title, Widget page})> tabItems;
  final Color backgroudColor;
  final Color labelColor;
  final TabBarTheme? tabBarTheme;

  final TabAlignment tabAlignment;
  final bool isScrollable;
  final EdgeInsets labelPadding;

  // final Widget Function(int index) tabPage

  @override
  State<NPinnedTabBarPage> createState() => _NPinnedTabBarPageState();
}

class _NPinnedTabBarPageState extends State<NPinnedTabBarPage>
    with SingleTickerProviderStateMixin {
  late final tabController =
      TabController(length: widget.tabItems.length, vsync: this);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildDefaultTabController();
  }

  Widget buildDefaultTabController() {
    return DefaultTabController(
      length: widget.tabItems.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: widget.title,
                centerTitle: false,
                pinned: true,
                floating: false,
                snap: false,
                primary: true,
                expandedHeight:
                    widget.expandedHeight + safeAreaTop + kToolbarHeight,
                elevation: 0,
                //是否显示阴影，直接取值innerBoxIsScrolled，展开不显示阴影，合并后会显示
                forceElevated: innerBoxIsScrolled,
                actions: widget.actions,
                flexibleSpace: FlexibleSpaceBar(
                  // collapseMode: CollapseMode.pin,
                  // titlePadding: EdgeInsets.only(top: safeAreaTop,),
                  background: Container(
                    padding: EdgeInsets.only(
                      top: safeAreaTop,
                    ),
                    child: widget.expandedHeader,
                  ),
                ),
                bottom: NTabBarColoredBox(
                  width: double.maxFinite,
                  backgroudColor: widget.backgroudColor,
                  labelColor: widget.labelColor,
                  tabBarTheme: widget.tabBarTheme,
                  child: TabBar(
                    tabs:
                        widget.tabItems.map((e) => Tab(text: e.title)).toList(),
                    controller: tabController,
                    tabAlignment: widget.tabAlignment,
                    isScrollable: widget.isScrollable,
                    labelPadding: widget.labelPadding,
                    indicatorSize: TabBarIndicatorSize.label,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ];
        },
        body: buildTabBarView(),
      ),
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      controller: tabController,
      children: widget.tabItems.map((e) {
        return Builder(builder: (context) {
          return CustomScrollView(
            key: PageStorageKey<String>(e.title),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              e.page,
              // SliverPadding(
              //   padding: EdgeInsets.all(10.0),
              //   sliver: SliverFixedExtentList(
              //     itemExtent: 50.0, //item高度或宽度，取决于滑动方向
              //     delegate: SliverChildBuilderDelegate(
              //           (BuildContext context, int index) {
              //         return ListTile(
              //           title:
              //           Text('Item $index, tab${tabController.index}'),
              //         );
              //       },
              //       childCount: 20,
              //     ),
              //   ),
              // ),
            ],
          );
        });
      }).toList(),
    );
  }
}
