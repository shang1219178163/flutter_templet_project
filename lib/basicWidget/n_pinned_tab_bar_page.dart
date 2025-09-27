//
//  NPinnedTabBarPageOne.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/22 14:41.
//  Copyright © 2024/3/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

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
  });

  final Text title;
  final List<Widget>? actions;
  final double expandedHeight;
  final Widget expandedHeader;

  final List<({Tab tab, Widget child})> tabItems;
  final Color backgroudColor;
  final Color labelColor;
  final TabBarTheme? tabBarTheme;

  final TabAlignment tabAlignment;
  final bool isScrollable;
  final EdgeInsets labelPadding;

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
  void didUpdateWidget(covariant NPinnedTabBarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title == widget.title ||
        oldWidget.actions == widget.actions ||
        oldWidget.expandedHeight == widget.expandedHeight ||
        oldWidget.expandedHeader == widget.expandedHeader ||
        oldWidget.tabItems == widget.tabItems ||
        oldWidget.backgroudColor == widget.backgroudColor ||
        oldWidget.labelColor == widget.labelColor ||
        oldWidget.tabAlignment == widget.tabAlignment ||
        oldWidget.isScrollable == widget.isScrollable ||
        oldWidget.labelPadding == widget.labelPadding) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildPinnedTabBar(
      title: widget.title,
      actions: widget.actions,
      expandedHeight: widget.expandedHeight,
      expandedHeader: widget.expandedHeader,
      tabItems: widget.tabItems,
      backgroudColor: widget.backgroudColor,
      labelColor: widget.labelColor,
      tabAlignment: widget.tabAlignment,
      isScrollable: widget.isScrollable,
      labelPadding: widget.labelPadding,
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
    TabAlignment tabAlignment = TabAlignment.center,
    bool isScrollable = false,
    EdgeInsets labelPadding = EdgeInsets.zero,
  }) {
    return DefaultTabController(
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
                  tabAlignment: tabAlignment,
                  isScrollable: isScrollable,
                  labelPadding: labelPadding,
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
              child: Builder(
                builder: (context) {
                  return e.child;
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
