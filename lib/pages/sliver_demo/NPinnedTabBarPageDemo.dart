import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_pinned_tab_bar_page.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
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

class _NPinnedTabBarPageDemoState extends State<NPinnedTabBarPageDemo> {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPinnedTabBarPage(),
    );
  }

  Widget buildPinnedTabBarPage() {
    final tabItems = [
      (title: "选项卡片0", page: buildSliverFixedExtentList(tabIndex: 0)),
      (title: "选项卡片1", page: buildSliverFixedExtentList(tabIndex: 1)),
      (title: "选项卡片2", page: buildSliverFixedExtentList(tabIndex: 2)),
      (title: "选项卡片3", page: buildSliverFixedExtentList(tabIndex: 3)),
      (title: "选项卡片4", page: buildSliverFixedExtentList(tabIndex: 4)),
    ];

    return NPinnedTabBarPage(
      title: Text("NPinnedTabBarPage"),
      expandedHeight: 200,
      expandedHeader: Container(
        height: 200,
        padding: EdgeInsets.only(top: safeAreaTop),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tabItems.map((e) => Chip(label: Text(e.title))).toList(),
        ).toColoredBox(color: Colors.green),
      ),
      tabItems: tabItems,
      isScrollable: false,
      labelPadding: const EdgeInsets.only(left: 6, right: 6),
    );
  }

  Widget buildSliverFixedExtentList({required int tabIndex}) {
    // return SliverFillRemaining(child: buildBox(tabIndex: tabIndex));
    return SliverPadding(
      padding: EdgeInsets.all(10.0),
      sliver: SliverFixedExtentList(
        itemExtent: 50.0, //item高度或宽度，取决于滑动方向
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(bottom: BorderSide(color: Colors.black12)),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: ListTile(
                title: Text('Item $index, tab${tabIndex}'),
              ),
            );
          },
          childCount: 20,
        ),
      ),
    );
  }

  Widget buildBox({required int tabIndex}) {
    return Container(
      height: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.orange, width: 10),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Text('tab${tabIndex}'),
    );
  }
}