//
//  TabBarPageView.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 5:03 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/decoration_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:tuple/tuple.dart';


class TabBarTabBarView extends StatefulWidget {

  const TabBarTabBarView({
    Key? key,
    this.isTabBarTop = true,
    required this.items,
    this.indicatorColor,
    this.labelColor,
    this.pageController,
    this.tabController,
    required this.onPageChanged,
    this.canPageChanged,
  }) : super(key: key);

  final List<Tuple2<String, Widget>> items;

  final Color? indicatorColor;

  final Color? labelColor;

  final PageController? pageController;

  final TabController? tabController;

  final ValueChanged<int> onPageChanged;

  final bool Function(int)? canPageChanged;

  final bool isTabBarTop;

  @override
  _TabBarTabBarViewState createState() => _TabBarTabBarViewState();
}

class _TabBarTabBarViewState extends State<TabBarTabBarView> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  // late PageController _pageController;

  ///是否允许滚动
  bool get canScrollable {
    if (widget.canPageChanged != null && widget.canPageChanged!(_tabController.index) == false) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    _tabController = widget.tabController ??  TabController(length: widget.items.length, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      _buildTabBar(),
      _buildPageView(),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.isTabBarTop ? list : list.reversed.toList(),
    );
  }

  Widget _buildTabBar() {
    final textColor = widget.labelColor ?? Theme
        .of(context)
        .colorScheme
        .primary;

    final bgColor = widget.indicatorColor ?? Colors.white;

    final borderSide = BorderSide(
      color: textColor,
      width: 2.0,
    );

    var decorationTop = BoxDecoration(
      border: Border(
        top: borderSide,
      ),
    );

    var decorationBom = BoxDecoration(
      border: Border(
        bottom: borderSide,
      ),
    );


    final tabBar = TabBar(
      controller: _tabController,
      tabs: widget.items.map((e) => Tab(text: e.item1)).toList(),
      labelColor: textColor,
      indicator: widget.isTabBarTop ? decorationBom : decorationTop,
      onTap: (index) {
        // ddlog([index, _tabController.index]);
        setState(() { });
      },
    );

    if (!canScrollable) {
      return IgnorePointer(
        child: tabBar,
      );
    }

    if (widget.isTabBarTop) {
      return tabBar;
    }

    return Material(
        color: bgColor,
        child: SafeArea(
          child: tabBar,
        )
    );
  }

  Widget _buildPageView() {
    return Expanded(
      child: TabBarView(
        physics: canScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: widget.items.map((e) => e.item2).toList(),
      ),);
  }

}