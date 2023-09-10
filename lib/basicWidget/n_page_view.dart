//
//  NPageView.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/tab_ext.dart';
import 'package:tuple/tuple.dart';

/// 多页面左右滑动封装
class NPageView extends StatefulWidget {


  const NPageView({
    Key? key,
    required this.items,
    this.needSafeArea = true,
    this.isThemeBg = false,
    this.isScrollable = false,
    this.isBottom = false,
    this.tabBar,
  }) : super(key: key);

  final List<Tuple2<String, Widget>> items;

  final bool needSafeArea;

  final bool isThemeBg;

  final bool isScrollable;

  final bool isBottom;
  /// 样式设置
  final TabBar? tabBar;

  @override
  _NPageViewState createState() => _NPageViewState();
}

class _NPageViewState extends State<NPageView> with SingleTickerProviderStateMixin {

  late final _tabController = TabController(length: widget.items.length, vsync: this);

  late final _pageController = PageController(initialPage: 0, keepPage: true);

  late final textColor = Theme.of(context).colorScheme.primary;

  late final bgColor = Theme.of(context).colorScheme.onPrimary;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      _buildBottomBar(
        items: widget.items,
        isScrollable: widget.isScrollable,
        isBottom: widget.isBottom,
        isThemeBg: widget.isThemeBg,
      ),
      Expanded(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            _tabController.animateTo(index);
            setState(() {});
          },
          children: widget.items.map((e) => e.item2).toList(),
        ),
      ),
    ];

    if (widget.isBottom) {
      children = children.reversed.toList();
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildBottomBar({
    required List<Tuple2<String, Widget>> items,
    bool isScrollable = false,
    bool isBottom = false,
    bool isThemeBg = true,
  }) {

    final labelColor = !isThemeBg ? textColor : bgColor;

    final tabBar = TabBar(
      controller: _tabController,
      isScrollable: isScrollable,
      tabs: items.map((e) => Tab(text: e.item1)).toList(),
      // indicatorSize: TabBarIndicatorSize.label,
      labelColor: labelColor,
      indicator: BoxDecoration(
        border: Border(
          top: !isBottom ? BorderSide.none : BorderSide(
              color: labelColor,
              width: 3.0,
          ),
          bottom: isBottom ? BorderSide.none : BorderSide(
              color: labelColor,
              width: 3.0,
          ),
        ),
      ),
      onTap: (index){
        _pageController.jumpToPage(index);
        setState(() {});
      },
    )
        // .cover(widget.tabBar)
    ;

    return Material(
      color: isThemeBg ? primaryColor : null,
      child: Center(
        child: tabBar,
      ),
    );
  }

}
