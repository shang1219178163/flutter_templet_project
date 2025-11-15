//
//  PageViewVerticalDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/16 16:13.
//  Copyright © 2025/1/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_sliding_segmented_control/n_sliding_segmented_control.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:get/get.dart';

class PageViewVerticalDemo extends StatefulWidget {
  const PageViewVerticalDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<PageViewVerticalDemo> createState() => _PageViewVerticalDemoState();
}

class _PageViewVerticalDemoState extends State<PageViewVerticalDemo> with SingleTickerProviderStateMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  late final items = <({String name, Widget child})>[
    (
      name: '宝贝',
      child: Container(
        // height: screenSize.height,
        color: ColorExt.random,
        alignment: Alignment.center,
        child: NText("宝贝"),
      )
    ),
    (
      name: '评价',
      child: Container(
        // height: screenSize.height,
        color: ColorExt.random,
        alignment: Alignment.center,
        child: NText("评价"),
      )
    ),
    (
      name: '详情',
      child: Container(
        // height: screenSize.height,
        color: ColorExt.random,
        alignment: Alignment.center,
        child: NText("详情"),
      )
    ),
    (
      name: '推荐',
      child: Container(
        // height: screenSize.height,
        color: ColorExt.random,
        alignment: Alignment.center,
        child: NText("推荐"),
      )
    ),
  ];

  late final tabController = TabController(length: items.length, vsync: this);
  late final pageController = PageController(initialPage: 0);

  final scrollDirection = ValueNotifier(Axis.horizontal);

  late MediaQueryData mq = MediaQuery.of(context);

  ThemeData get theme => Theme.of(context);

  final tabIndex = ValueNotifier(0);

  final segmentIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        debugPrint("_tabController:${tabController.index}");
      }
    });
  }

  @override
  void didUpdateWidget(covariant PageViewVerticalDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              // leading: SizedBox(),
              // leadingWidth: 0,
              elevation: 0,
              flexibleSpace: buildFlexibleSpace(),
            ),
      body: buildBody(),
    );
  }

  Widget buildFlexibleSpace() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(AppRes.image.urls[5]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// TabBar 脱离 AppBar
  Widget buildBody() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: NText("滚动方向"),
              ),
              NSlidingSegmentedControl(
                items: Axis.values.map((e) => e.name).toList(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                onChanged: (v) {
                  segmentIndex.value = v;
                  scrollDirection.value = v == 0 ? Axis.horizontal : Axis.vertical;
                },
              ),
            ],
          ),
        ),
        TabBar(
          controller: tabController,
          isScrollable: items.length > 4,
          padding: items.length > 4 ? EdgeInsets.symmetric(horizontal: 42) : null,
          // indicatorPadding: EdgeInsets.symmetric(horizontal: 42),
          labelColor: theme.primaryColor,
          // labelPadding: EdgeInsets.symmetric(horizontal: 30),
          tabs: items.map((e) => Tab(text: e.name)).toList(),
          onTap: (index) {
            debugPrint("index: $index");
            // tabIndex.value = index;
            pageController.toPage(index);
          },
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: scrollDirection,
            builder: (context, scrollDirection, child) {
              return PageView(
                controller: pageController,
                onPageChanged: (v) {
                  tabController.animateTo(v);
                },
                scrollDirection: scrollDirection,
                children: [
                  ...items.map(
                    (e) => Column(
                      children: [
                        Expanded(child: e.child),
                        if (e == items.last)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(child: Divider(height: 1, indent: 20, endIndent: 20)),
                                Text("到底部了~"),
                                Expanded(child: Divider(height: 1, indent: 20, endIndent: 20)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
