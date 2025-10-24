//
//  NestedScrollViewDemoFive.dart
//  flutter_templet_project
//
//  Created by shang on 2023/3/25 12:55.
//  Copyright © 2023/3/25 shang. All rights reserved.
//

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/scroll_controller_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/pages/demo/widget/user_header.dart';
import 'package:flutter_templet_project/util/Resource.dart';
import 'package:sliver_tools/sliver_tools.dart';

class NestedScrollViewDemoFive extends StatefulWidget {
  const NestedScrollViewDemoFive({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NestedScrollViewDemoFiveState createState() => _NestedScrollViewDemoFiveState();
}

class _NestedScrollViewDemoFiveState extends State<NestedScrollViewDemoFive> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController(initialScrollOffset: 0.0);

  List<String> items = List.generate(9, (index) => 'item_$index').toList();
  late final tabController = TabController(length: items.length, vsync: this);

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
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Text(widget.title ?? "$widget"),
      // ),
      body: buildNestedScrollView(),
    );
  }

  Widget buildNestedScrollView() {
    var statusBarHeight = MediaQuery.of(context).padding.top;

    final collapseHeight = kToolbarHeight;
    final expandedHeight = 300.0;

    final tabBarHeight = 46.0;
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: ListenableBuilder(
                listenable: scrollController,
                builder: (context, child) {
                  try {
                    final value = scrollController.offset;
                    final opacity = scrollController.position.progress > 0.9 ? 1.0 : 0.0;
                    return AnimatedOpacity(
                      opacity: opacity,
                      duration: const Duration(milliseconds: 100),
                      child: buildUserBar(),
                    );
                  } catch (e) {
                    debugPrint("$this $e");
                  }
                  return const SizedBox();
                },
              ),
              pinned: true,
              collapsedHeight: collapseHeight,
              expandedHeight: expandedHeight,
              flexibleSpace: buildFlexibleSpace(
                statusBarHeight: statusBarHeight,
                collapseHeight: collapseHeight,
                expandedHeight: expandedHeight,
                tabBarHeight: tabBarHeight,
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(tabBarHeight),
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  tabs: items.map((e) => Tab(text: e)).toList(),
                ),
              ),
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
                  key: PageStorageKey<String>(e),
                  slivers: [
                    // ✅ 每个 tab 内必须是 CustomScrollView 并带 Injector
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(title: Text('${e} Row #$index')),
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

  Widget buildFlexibleSpace({
    required double statusBarHeight,
    required double collapseHeight,
    required double expandedHeight,
    required double tabBarHeight,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: tabBarHeight), //是否延伸到 TabBar 底下
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
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        var top = constraints.maxHeight;
        final fixedHeight = statusBarHeight + tabBarHeight;
        final double opacity = ((top - fixedHeight - kToolbarHeight) / (expandedHeight - fixedHeight)).clamp(0, 1.0);

        return Container(
          constraints: constraints,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.5),
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(0)),
            image: DecorationImage(
              // opacity: opacity,
              image: ExtendedNetworkImageProvider(
                Resource.image.urls[6],
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: AnimatedOpacity(
            opacity: opacity,
            duration: Duration(milliseconds: 200),
            child: UserHeader(
              constraints: constraints,
            ),
          ),
        );
      }),
    );
  }

  Widget buildUserBar() {
    var realNameAndTypeText = "您好 SoaringHeart!";

    return Container(
      height: 28,
      // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: NText(
              realNameAndTypeText,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              maxLines: 1,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Image(
                image: "assets/images/icon_qr.png".toAssetImage(),
                width: 18,
                height: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
