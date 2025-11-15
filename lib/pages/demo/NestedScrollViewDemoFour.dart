//
//  NestedScrollViewDemoFour.dart
//  flutter_templet_project
//
//  Created by shang on 2025/2/13 09:04.
//  Copyright © 2025/2/13 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_templet_project/basicWidget/n_grid_view.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_search_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/basicWidget/scroll/NCustomScrollBehavior.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 电商首页
class NestedScrollViewDemoFour extends StatefulWidget {
  const NestedScrollViewDemoFour({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NestedScrollViewDemoFour> createState() => _NestedScrollViewDemoFourState();
}

class _NestedScrollViewDemoFourState extends State<NestedScrollViewDemoFour> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  final tabItems = [
    "推荐好物",
    "家电",
    "生鲜",
    "食品",
    "爱车",
    "手机",
    "新品",
  ];
  late final tabController = TabController(length: tabItems.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return ScrollConfiguration(
      behavior: NCustomScrollBehavior().copyWith(scrollbars: false),
      child: CustomScrollView(
        // scrollBehavior: NCustomScrollBehavior().copyWith(scrollbars: false),
        controller: scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            pinned: true,
            expandedHeight: 200.0,
            titleSpacing: 10.0,
            // 搜索框(高斯模糊背景)
            title: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: NSearchBar(
                  onChanged: (String v) {
                    DLog.d("onChanged: $v");
                  },
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
              ),
            ],
            // 自定义伸缩区域(轮播图)
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF5000), Color(0xFFfcaec4)],
                ),
              ),
              child: FlexibleSpaceBar(
                background: Swiper.children(
                  pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.white70,
                      activeColor: Colors.white,
                    ),
                  ),
                  // indicatorLayout: PageIndicatorLayout.SCALE,
                  children: [
                    'https://m.360buyimg.com/babel/jfs/t20271217/224114/35/38178/150060/6760d559Fd654f946/968c156726b6e822.png',
                    'https://m.360buyimg.com/babel/jfs/t20280117/88832/5/48468/139826/6789cbcfF4e0b2a3d/9dc54355b6f65c40.jpg',
                    'https://m.360buyimg.com/babel/jfs/t20280108/255505/29/10540/137372/677ddbc1F6cdbbed0/bc477fadedef22a8.jpg',
                  ]
                      .map((e) => NNetworkImage(
                            url: e,
                            fit: BoxFit.fill,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),

          // 菜单
          buildMenueItems().toSliverToBoxAdapter(),

          // tabbar列表
          NSliverPersistentHeaderBuilder(
            pinned: true,
            builder: (BuildContext context, double shrinkOffset, bool overlapsContent) {
              return buildTabBar();
              return PreferredSize(
                preferredSize: Size.fromHeight(35.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.blue),
                  ),
                  child: buildTabBar(),
                ),
              );
            },
          ),

          // 瀑布流列表
          AnimatedBuilder(
            animation: Listenable.merge([
              tabController,
            ]),
            builder: (context, child) {
              return buildList(
                itemBuilder: (_, i) {
                  final prefix = tabItems[tabController.index];
                  return ListTile(
                    title: Text("${prefix}_$i"),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// 顶部功能模块
  Widget buildMenueItems() {
    final children = [
      (
        text: '事情',
        iconImage: 'assets/images/icon_adverse_event.png',
        onTap: () {},
      ),
      (
        text: '记录',
        iconImage: 'assets/images/icon_wait_reply.png',
        onTap: () {},
      ),
      (
        text: '方案',
        iconImage: 'assets/images/icon_reviewed.png',
        onTap: () {
          //待审核
        },
      ),
      (
        text: '样本',
        iconImage: 'assets/images/icon_arranged.png',
        onTap: () {
          //待安排
        },
      ),
      (
        text: '处理',
        iconImage: 'assets/images/icon_reviewed.png',
        onTap: () {
          //待审核
        },
      ),
      (
        text: '排期',
        iconImage: 'assets/images/icon_arranged.png',
        onTap: () {
          //待安排
        },
      ),
    ]
        .map(
          (e) => NPair(
            direction: Axis.vertical,
            betweenGap: 2,
            icon: Image(
              image: e.iconImage.toAssetImage(),
              width: 44,
              height: 44,
            ),
            child: Text(
              e.text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        )
        .toList();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColor.bgColor,
        // border: Border.all(color: Colors.blue),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: NGridView(
          crossAxisCount: 5,
          mainAxisSpacing: 11,
          crossAxisSpacing: 10,
          radius: 8,
          children: children,
        ),
      ),
    );
  }

  Widget buildTabBar({
    Color? textColor = Colors.black,
    Color? indicatorColor = Colors.orange,
  }) {
    return Material(
      color: Colors.white,
      child: Align(
        // alignment: widget.tabBarAlignment,
        child: TabBar(
          controller: tabController,
          isScrollable: tabController.length > 4,
          tabAlignment: TabAlignment.center,
          tabs: tabItems.map((e) => Tab(text: e.toString())).toList(),
          indicatorSize: TabBarIndicatorSize.label,
          // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
          labelColor: textColor,
          indicatorColor: indicatorColor,
          dividerColor: Colors.transparent,
          onTap: (index) {
            // tabBarIndex.value = index;
            // widget.onTabBar?.call(index);
          },
        ),
      ),
    );
  }

  Widget buildList({
    NullableIndexedWidgetBuilder? itemBuilder,
  }) {
    final items = List.generate(20, (index) => index);
    return SliverList.separated(
      itemCount: items.length,
      itemBuilder: itemBuilder ??
          (_, i) {
            return ListTile(
              title: Text("${tabController.index}_Row_$i"),
            );
          },
      separatorBuilder: (_, i) => Divider(height: 1),
    );
  }
}
