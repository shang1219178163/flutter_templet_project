//
//  CustomeTabBar.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/6 22:03.
//  Copyright © 2023/1/6 shang. All rights reserved.
//

import 'dart:math' as math;
import 'package:flutter/material.dart';

const double _kTabHeight = 46.0;

typedef IndexedCallback = void Function(BuildContext context, int index);
typedef CustomeTabBarItemWidgetBuilder = Widget Function(BuildContext context, int index, bool isSelect);

class CustomeTabBar extends StatefulWidget implements PreferredSizeWidget {

  CustomeTabBar({
    Key? key,
    this.initialIndex = 0,
    this.tabCount = 0,
    this.tabController,
    this.indicator,
    this.indicatorWeight = 2,
    required this.itemBuilder,
    required this.onClick,
  }) : super(key: key);

  TabController? tabController;
  /// 初始索引
  int initialIndex;

  int tabCount;

  Decoration? indicator;

  double indicatorWeight;

  IndexedCallback onClick;

  CustomeTabBarItemWidgetBuilder itemBuilder;

  @override
  Size get preferredSize {
    double maxHeight = _kTabHeight;
    return Size.fromHeight(maxHeight + indicatorWeight);
  }

  @override
  CustomeTabBarState createState() => CustomeTabBarState();
}

class CustomeTabBarState extends State<CustomeTabBar> with SingleTickerProviderStateMixin {

  /// 当前索引
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    widget.tabController ??= TabController(length: widget.tabCount, vsync: this);
    widget.tabController?.addListener(() {
      if(!widget.tabController!.indexIsChanging){
        // print("_tabController:${widget.tabController!.index}");
        setState(() {
          currentIndex = widget.tabController!.index;
          widget.onClick(context, currentIndex);
        });
      }
    });

    print("widget.tabController${widget.tabController}");
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      isScrollable: true,
        // tabs: List.generate(9, (index) => 'item_$index').toList().map((e) => Tab(text: e,)).toList(),
      tabs: List.generate(widget.tabCount, (index) => widget.itemBuilder(
          context,
          index,
          currentIndex == widget.tabController!.index)
      ),
      // indicatorSize: TabBarIndicatorSize.label,
      // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
      // indicator: widget.indicator ?? UnderlineTabIndicator(
      //     borderSide: BorderSide(
      //       style: BorderStyle.solid,
      //       width: 2,
      //       color: Colors.white,
      //     )
      // ),
    );
  }

  reset() {
    widget.tabController!.index = widget.initialIndex;
  }

}