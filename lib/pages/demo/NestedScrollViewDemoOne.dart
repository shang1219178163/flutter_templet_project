//
//  NestedScrollViewDemoOne.dart
//  flutter_templet_project
//
//  Created by shang on 2023/3/25 12:55.
//  Copyright © 2023/3/25 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/uti/R.dart';

class NestedScrollViewDemoOne extends StatefulWidget {

  const NestedScrollViewDemoOne({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NestedScrollViewDemoOneState createState() => _NestedScrollViewDemoOneState();
}

class _NestedScrollViewDemoOneState extends State<NestedScrollViewDemoOne> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final ScrollController? _scrollController = ScrollController(initialScrollOffset: 0.0);

  List<String> items = List.generate(9, (index) => 'item_$index').toList();

  final indexVN = ValueNotifier<int>(0);

  final flagVN = ValueNotifier(false);

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: items.length, vsync: this);
    // _tabController?.addListener(() {
    //   indexVN.value = _tabController!.index;
    //   print("indexVN:${indexVN.value}_${_tabController?.index}");
    // });

    // _scrollController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: onPressed,
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: buildPage(),
    );
  }

  onPressed(){

  }

  buildPage() {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          // buildSliverAppBar(),
          buildNNSliverPersistentHeader(),
          // buildSliverPersistentHeader(),
        ];
      },
      body: buildTabBarView(controller: _tabController, items: items),
    );
  }

  buildSliverAppBar() {
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

  buildSliverPersistentHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: NSliverPersistentHeaderDelegate(
        builder: (ctx, offset, overlapsContent) {
          return ColoredBox(
            color: Colors.yellow,
            child: Align(
              alignment: Alignment.center,
              child: ColoredBox(
                color: Colors.blue,
                child: buildTabBar(
                  controller: _tabController,
                  indexVN: indexVN,
                  items: items,
                ),
              )
            ),
          );
        }
      ),
    );
  }

  buildNNSliverPersistentHeader() {
    return NNSliverPersistentHeader(
      pinned: true,
      builder: (ctx, offset, overlapsContent) {
        return ColoredBox(
          color: Colors.yellow,
          child: Align(
              alignment: Alignment.center,
              child: ColoredBox(
                color: Colors.blue,
                child: buildTabBar(
                  controller: _tabController,
                  indexVN: indexVN,
                  items: items,
                ),
              )
          ),
        );
      }
    );
  }

  buildTabBar({
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
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 4,
          color: Colors.red,
        )
      ),
      tabs: items.map((e) => Tab(
        child: ValueListenableBuilder<int>(
          valueListenable: indexVN,
          builder: (BuildContext context, int value, Widget? child) {
            final index = items.indexOf(e);
            if (index != 1){
              if (index == 2){
                return Tab(child: Text(e + e,),);
              }
              if (index == 3){
                return Tab(child: Text(e + e, style: TextStyle(fontSize: 20)),);
              }
              return Tab(text: e);
            }

            final url = (value == index) ? R.image.urls[1] : R.image.urls[0];
            return Tab(
              child: FadeInImage(
                image: NetworkImage(url),
                placeholder: AssetImage("images/flutter_logo.png"),
              ),
            );
          }),
      )).toList(),
    );
  }

  buildTabBarView({
    required TabController? controller,
    required List<String> items,
  }) {
    return TabBarView( //构建
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

  buildList() {
    const items = Colors.primaries;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index){
        final color = items[index];
        return ListTile(
          leading: Icon(Icons.ac_unit, color: color,),
          title: Text("$index"),
        );
      }
    );
  }
}