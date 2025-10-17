//
//  NestedScrollViewDemoOne.dart
//  flutter_templet_project
//
//  Created by shang on 2023/3/25 12:55.
//  Copyright © 2023/3/25 shang. All rights reserved.
//

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_body.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_indicator_fixed.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/Resource.dart';
import 'package:flutter_templet_project/util/app_color.dart';
import 'package:sliver_tools/sliver_tools.dart';

class NestedScrollViewDemoOne extends StatefulWidget {
  const NestedScrollViewDemoOne({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NestedScrollViewDemoOneState createState() => _NestedScrollViewDemoOneState();
}

class _NestedScrollViewDemoOneState extends State<NestedScrollViewDemoOne> with SingleTickerProviderStateMixin {
  TabController? tabController;
  final ScrollController? _scrollController = ScrollController(initialScrollOffset: 0.0);

  List<String> items = List.generate(9, (index) => 'item_$index').toList();

  final indexVN = ValueNotifier<int>(0);

  final flagVN = ValueNotifier(false);

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: items.length, vsync: this);
    // _tabController?.addListener(() {
    //   indexVN.value = _tabController!.index;
    //   print("indexVN:${indexVN.value}_${_tabController?.index}");
    // });

    // _scrollController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Text(widget.title ?? "$widget"),
      // ),
      body: buildNestedScrollView(),
    );
  }

  Widget buildNestedScrollView() {
    final min = 100.0;
    final max = 200.0;

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        final appBar = SliverAppBar(
          title: const Text('Demo'),
          pinned: true,
          collapsedHeight: kToolbarHeight,
          expandedHeight: 200,
          flexibleSpace: Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                // opacity: opacity,
                image: ExtendedNetworkImageProvider(
                  Resource.image.urls[4],
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          bottom: TabBar(
            controller: tabController,
            tabs: items.map((e) => Tab(text: e)).toList(),
          ),
        );
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: appBar,
          ),
        ];
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: MultiSliver(
              children: [
                // NSliverPersistentHeaderBuilder(
                //   pinned: true,
                //   min: min,
                //   max: max,
                //   builder: (BuildContext context, double shrinkOffset, bool overlapsContent) {
                //     final opacity = 1 - (shrinkOffset / (max - min));
                //
                //     return Container(
                //       alignment: Alignment.bottomCenter,
                //       decoration: BoxDecoration(
                //         color: Colors.blue,
                //         image: DecorationImage(
                //           // opacity: opacity,
                //           image: ExtendedNetworkImageProvider(
                //             Resource.image.urls[4],
                //           ),
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //       child: Text(
                //         "Pinned Header ${{
                //           "shrinkOffset": shrinkOffset.toStringAsFixed(2),
                //         }} ",
                //         style: TextStyle(color: Colors.white, fontSize: 20),
                //       ),
                //       // child: SearchBar(
                //       //   hintText: "search",
                //       // ),
                //     );
                //   },
                // ),
                appBar,
              ],
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: tabController,
        children: [
          ...items.map((e) {
            return Builder(
              builder: (context) {
                return CustomScrollView(
                  key: const PageStorageKey<String>('Tab1'),
                  slivers: [
                    // ✅ 每个 tab 内必须是 CustomScrollView 并带 Injector
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(title: Text('Item #$index')),
                        childCount: 30,
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget buildPage() {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          // buildSliverAppBar(),
          buildNSliverPersistentHeader(),
          // buildSliverPersistentHeader(),
        ];
      },
      body: buildTabBarView(controller: tabController, items: items),
    );
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 130.0,
      pinned: true,
      elevation: 0,
      flexibleSpace: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: PageView(),
      ),
    );
  }

  Widget buildSliverPersistentHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: NSliverPersistentHeaderDelegate(builder: (ctx, offset, overlapsContent) {
        return ColoredBox(
          color: Colors.yellow,
          child: Align(
              alignment: Alignment.center,
              child: ColoredBox(
                color: Colors.blue,
                child: buildTabBar(
                  controller: tabController,
                  indexVN: indexVN,
                  items: items,
                ),
              )),
        );
      }),
    );
  }

  Widget buildNSliverPersistentHeader() {
    return NSliverPersistentHeaderBuilder(
        pinned: true,
        builder: (ctx, offset, overlapsContent) {
          return ColoredBox(
            color: Colors.yellow,
            child: Align(
                alignment: Alignment.center,
                child: ColoredBox(
                  color: Colors.blue,
                  child: buildTabBar(
                    controller: tabController,
                    indexVN: indexVN,
                    items: items,
                  ),
                )),
          );
        });
  }

  Widget buildTabBar({
    required TabController? controller,
    required ValueNotifier<int> indexVN,
    required List<String> items,
    TabBarIndicatorSize? indicatorSize = TabBarIndicatorSize.label,
  }) {
    return TabBar(
      isScrollable: true,
      controller: controller,
      // indicatorSize: TabBarIndicatorSize.label,
      indicatorSize: indicatorSize,
      // labelPadding: EdgeInsets.symmetric(horizontal: 12),
      // indicatorPadding: EdgeInsets.only(left: 8, right: 8),
      // indicator: UnderlineTabIndicator(
      //   borderSide: BorderSide(
      //     style: BorderStyle.solid,
      //     width: 4,
      //     color: Colors.red,
      //   )
      // ),
      indicator: NTabBarIndicatorFixed(),
      tabs: items
          .map((e) => Tab(
                child: ValueListenableBuilder<int>(
                    valueListenable: indexVN,
                    builder: (BuildContext context, int value, Widget? child) {
                      final index = items.indexOf(e);
                      if (index != 1) {
                        if (index == 2) {
                          return Tab(
                            child: Text(
                              e + e,
                            ),
                          );
                        }
                        if (index == 3) {
                          return Tab(
                            child: Text(e + e, style: TextStyle(fontSize: 20)),
                          );
                        }
                        return Tab(text: e);
                      }

                      final url = (value == index) ? Resource.image.urls[1] : Resource.image.urls[0];
                      return Tab(
                        child: FadeInImage(
                          image: NetworkImage(url),
                          placeholder: "flutter_logo.png".toAssetImage(),
                        ),
                      );
                    }),
              ))
          .toList(),
    );
  }

  Widget buildTabBarView({
    required TabController? controller,
    required List<String> items,
  }) {
    return TabBarView(
      //构建
      controller: controller,
      children: items.map((e) {
        return RefreshIndicator(
          onRefresh: () {
            debugPrint(('onRefresh'));
            return Future.delayed(Duration(microseconds: 1500));
          },
          child: buildList(),
        );
      }).toList(),
    );
  }

  Widget buildList() {
    const items = Colors.primaries;
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final color = items[index];
          return ListTile(
            leading: Icon(
              Icons.ac_unit,
              color: color,
            ),
            title: Text("$index"),
          );
        });
  }
}
