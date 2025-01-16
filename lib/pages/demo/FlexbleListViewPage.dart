//
//  FlexbleListView.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/14 16:55.
//  Copyright © 2025/1/14 shang. All rights reserved.
//

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/pages/demo/FittedBoxDemo.dart';
import 'package:get/get.dart';

class FlexbleListViewDemo extends StatefulWidget {
  const FlexbleListViewDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<FlexbleListViewDemo> createState() => _FlexbleListViewDemoState();
}

class _FlexbleListViewDemoState extends State<FlexbleListViewDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant FlexbleListViewDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return buildPage1();
    return buildScaffold();
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final list = List.generate(5, (index) => index);
    return ListView.separated(
      itemBuilder: (_, i) {
        if (i == 0) {
          return Container(
            width: double.infinity,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.blue),
            ),
            child: Text("ListView Header", style: TextStyle(color: Colors.white)),
          );
        } else if (i == list.length + 1) {
          return Container(
            width: double.infinity,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.blue),
            ),
            child: Text("ListView Footer", style: TextStyle(color: Colors.white)),
          );
        }

        final title = "index_$i";
        return ListTile(title: Text(title));
      },
      separatorBuilder: (_, i) {
        return Divider(height: 1);
      },
      itemCount: list.length + 2,
    );
  }

  Widget buildScaffold() {
    final appBarHeight = context.appBarHeight;
    return Scaffold(
      body: PrimaryScrollController(
        controller: _scrollController,
        child: Scrollbar(
          controller: _scrollController,
          child: CustomScrollView(
            slivers: <Widget>[
              NSliverPersistentHeaderBuilder(
                pinned: true,
                min: 56,
                max: 56,
                builder: (context, double shrinkOffset, bool overlapsContent) {
                  return SearchBar(
                    hintText: "search",
                  );
                },
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ListTile(
                      title: Text('Item $index'),
                    );
                  },
                  childCount: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage1() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final min = mediaQuery.viewPadding.top + kToolbarHeight;
    final max = 200.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          NSliverPersistentHeaderBuilder(
            pinned: true,
            min: min,
            max: max,
            builder: (BuildContext context, double shrinkOffset, bool overlapsContent) {
              final double opacity = 1 - (shrinkOffset / (max - min));

              return Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    opacity: opacity,
                    image: ExtendedNetworkImageProvider(
                      'https://picsum.photos/250?image=9',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: Text(
                //   "Pinned Header ${{
                //     "shrinkOffset": shrinkOffset.toStringAsFixed(2),
                //   }} ",
                //   style: TextStyle(color: Colors.white, fontSize: 20),
                // ),
                child: SearchBar(
                  hintText: "search",
                ),
              );
            },
          ),
          // 用 SliverList 填充内容
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('Item #$index'),
              ),
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
