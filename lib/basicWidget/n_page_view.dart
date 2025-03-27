//
//  NPageView.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
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
    this.tabAlignment = TabAlignment.center,
    this.tabBar,
    this.onPageChanged,
  }) : super(key: key);

  final List<Tuple2<String, Widget>> items;

  final bool needSafeArea;

  final bool isThemeBg;

  final bool isScrollable;

  final bool isBottom;

  /// 样式设置
  final TabBar? tabBar;

  final TabAlignment tabAlignment;

  final ValueChanged<int>? onPageChanged;

  @override
  _NPageViewState createState() => _NPageViewState();
}

class _NPageViewState extends State<NPageView> with TickerProviderStateMixin {
  late TabController tabController =
      TabController(length: widget.items.length, vsync: this);

  late final pageController = PageController(initialPage: 0, keepPage: true);

  late final textColor = Theme.of(context).colorScheme.primary;

  late final bgColor = Theme.of(context).colorScheme.onPrimary;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final names = widget.items.map((e) => e.item1).join(",");
    final oldNames = oldWidget.items.map((e) => e.item1).join(",");
    if (names != oldNames) {
      tabController = TabController(length: widget.items.length, vsync: this);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (tabController.length == 0) {
      return SizedBox();
    }
    var children = [
      _buildBottomBar(
        items: widget.items,
        isScrollable: widget.isScrollable,
        isBottom: widget.isBottom,
        isThemeBg: widget.isThemeBg,
      ),
      Expanded(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            tabController.animateTo(index);
            setState(() {});
            widget.onPageChanged?.call(index);
          },
          children: widget.items.map((e) => e.item2).toList(),
        ),
      ),
    ];

    if (widget.isBottom) {
      children = children.reversed.toList();
    }

    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
    if (!widget.needSafeArea) {
      return child;
    }

    return SafeArea(
      child: child,
    );
  }

  Widget _buildBottomBar({
    required List<Tuple2<String, Widget>> items,
    bool isScrollable = false,
    bool isBottom = false,
    bool isThemeBg = true,
  }) {
    final labelColor = !isThemeBg ? textColor : bgColor;

    Widget tabBar = TabBar(
      controller: tabController,
      tabAlignment: widget.tabAlignment,
      isScrollable: isScrollable,
      tabs: items.map((e) => Tab(text: e.item1)).toList(),
      // indicatorSize: TabBarIndicatorSize.label,
      labelColor: labelColor,
      indicator: BoxDecoration(
        border: Border(
          top: !isBottom
              ? BorderSide.none
              : BorderSide(
                  color: labelColor,
                  width: 3.0,
                ),
          bottom: isBottom
              ? BorderSide.none
              : BorderSide(
                  color: labelColor,
                  width: 3.0,
                ),
        ),
      ),
      onTap: (index) {
        pageController.jumpToPage(index);
        setState(() {});
        widget.onPageChanged?.call(index);
      },
    )
        // .cover(widget.tabBar)
        ;

    if (widget.tabAlignment == TabAlignment.center) {
      tabBar = Center(
        child: tabBar,
      );
    }

    return Material(
      color: isThemeBg ? primaryColor : null,
      child: tabBar,
    );
  }
}
