//
//  NestedScrollViewDemoThree.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/22 19:29.
//  Copyright © 2024/3/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_colored_box.dart';

class NestedScrollViewDemoThree extends StatefulWidget {
  const NestedScrollViewDemoThree({super.key});

  @override
  State<NestedScrollViewDemoThree> createState() => _NestedScrollViewDemoThreeState();
}

class _NestedScrollViewDemoThreeState extends State<NestedScrollViewDemoThree> {
  late final List<({Tab tab, Widget child})> tabItems = [
    (
      tab: Tab(
        text: "选项卡0",
      ),
      child: buildScrollView(name: '选项卡0')
    ),
    (
      tab: Tab(
        text: "选项卡1",
      ),
      child: buildScrollView(name: '选项卡1')
    ),
    (
      tab: Tab(
        text: "选项卡2",
      ),
      child: buildScrollView(name: '选项卡2')
    ),
    (
      tab: Tab(
        text: "选项卡3",
      ),
      child: buildScrollView(name: '选项卡3')
    ),
    (
      tab: Tab(
        text: "选项卡4",
      ),
      child: buildScrollView(name: '选项卡4')
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: tabItems.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            Color backgroudColor = Colors.blue;
            var labelColor = Colors.white;

            backgroudColor = Colors.white;
            labelColor = Colors.blue;

            return <Widget>[
              buildHeader(
                context: context,
                innerBoxIsScrolled: innerBoxIsScrolled,
                bottom: NTabBarColoredBox(
                  backgroudColor: backgroudColor,
                  labelColor: labelColor,
                  child: TabBar(
                    tabs: tabItems.map((e) => e.tab).toList(),
                    labelPadding: EdgeInsets.symmetric(horizontal: 4),
                    indicatorColor: labelColor,
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: tabItems.map((e) {
              return SafeArea(
                top: false,
                bottom: false,
                child: e.child,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // 头部
  Widget buildHeader({
    required BuildContext context,
    required bool innerBoxIsScrolled,
    required PreferredSizeWidget? bottom,
  }) {
    // SliverOverlapAbsorber 的作用是处理重叠滚动效果，防止 CustomScrollView 中的滚动视图与其他视图重叠。
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        title: const Text('滚动一致性'),
        pinned: true,
        elevation: 0,
        //影深
        expandedHeight: 300,
        forceElevated: innerBoxIsScrolled,
        //为true时展开有阴影
        flexibleSpace: FlexibleSpaceBar(
          // background: Image.asset(
          //   "assets/images/bg_jiguang.png",
          //   fit: BoxFit.cover,
          // ),
          background: Container(
            decoration: BoxDecoration(
                // color: Colors.orange,
                // border: Border.all(color: Colors.blue),
                ),
            padding: EdgeInsets.only(
              top: mediaQuery.viewPadding.top + kToolbarHeight,
              bottom: 46,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
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
          ),
        ),
        bottom: bottom,
      ),
    );
  }

  Widget buildScrollView({
    required String name,
  }) {
    return Builder(builder: (context) {
      return CustomScrollView(
        key: PageStorageKey<String>(name),
        slivers: <Widget>[
          // SliverOverlapInjector 的作用是处理重叠滚动效果，
          // 确保 CustomScrollView 中的滚动视图不会与其他视图重叠。
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),

          // 横向滚动
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: PageView(
                children: [
                  Container(
                    color: Colors.yellow,
                    child: const Center(child: Text('横向滚动')),
                  ),
                  Container(color: Colors.green),
                  Container(color: Colors.blue),
                ],
              ),
            ),
          ),

          // 固定高度内容
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              color: Colors.greenAccent,
              child: const Center(child: Text('固定高度内容')),
            ),
          ),

          // 列表
          buildContent(name),

          // 固定高度内容
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              color: Colors.greenAccent,
              child: const Center(child: Text('固定高度内容')),
            ),
          ),

          // 列表 100 行
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(title: Text('Item $index'));
              },
              childCount: 100,
            ),
          ),
        ],
      );
    });
  }

  Widget buildContent(String name) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverFixedExtentList(
        itemExtent: 48.0,
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ListTile(
              title: Text('$name - $index'),
            );
          },
          childCount: 50,
        ),
      ),
    );
  }
}
