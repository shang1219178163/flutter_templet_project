//
//  NPageView.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 多页面左右滑动封装
class NPageView extends StatefulWidget {
  const NPageView({
    super.key,
    required this.items,
    this.indicator,
    this.isReverse = false,
    this.isScrollable = false,
    this.isBottom = false,
    this.tabAlignment = TabAlignment.center,
    this.onPageChanged,
  });

  final List<(String, Widget)> items;

  final Decoration? indicator;

  final bool isReverse;

  final bool isScrollable;

  final bool isBottom;

  final TabAlignment tabAlignment;

  final ValueChanged<int>? onPageChanged;

  @override
  _NPageViewState createState() => _NPageViewState();
}

class _NPageViewState extends State<NPageView> with TickerProviderStateMixin {
  late var tabController = TabController(length: widget.items.length, vsync: this);

  late final pageController = PageController(initialPage: 0, keepPage: true);

  late final theme = Theme.of(context);
  late final colorScheme = theme.colorScheme;
  late final onPrimary = colorScheme.onPrimary;
  late final primary = colorScheme.primary;

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
    final names = widget.items.map((e) => e.$1).join(",");
    final oldNames = oldWidget.items.map((e) => e.$1).join(",");
    if (names != oldNames) {
      tabController = TabController(length: widget.items.length, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tabController.length == 0) {
      return SizedBox();
    }
    var children = [
      buildBottomBar(
        items: widget.items,
        isScrollable: widget.isScrollable,
        isBottom: widget.isBottom,
        isReverse: widget.isReverse,
      ),
      Expanded(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            tabController.animateTo(index);
            setState(() {});
            widget.onPageChanged?.call(index);
          },
          children: widget.items.map((e) => e.$2).toList(),
        ),
      ),
    ];

    if (widget.isBottom) {
      children = children.reversed.toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget buildBottomBar({
    required List<(String, Widget)> items,
    bool isScrollable = false,
    bool isBottom = false,
    bool isReverse = true,
  }) {
    final bgColor = isReverse ? primary : onPrimary;
    final labelColor = !isReverse ? primary : onPrimary;

    Widget tabBar = TabBar(
      controller: tabController,
      tabAlignment: widget.tabAlignment,
      isScrollable: isScrollable,
      tabs: items.map((e) => Tab(text: e.$1)).toList(),
      // indicatorSize: TabBarIndicatorSize.label,
      labelColor: labelColor,
      unselectedLabelColor: labelColor.withValues(alpha: 0.5),
      indicatorColor: labelColor,
      indicator: widget.indicator,
      // indicator: BoxDecoration(
      //   border: Border(
      //     top: !isBottom ? BorderSide.none : BorderSide(color: labelColor, width: 3.0),
      //     bottom: isBottom ? BorderSide.none : BorderSide(color: labelColor, width: 3.0),
      //   ),
      // ),
      onTap: (index) {
        pageController.jumpToPage(index);
        setState(() {});
        widget.onPageChanged?.call(index);
      },
    );

    if (widget.tabAlignment == TabAlignment.center) {
      tabBar = Center(child: tabBar);
    }

    return Material(
      color: bgColor,
      elevation: 0,
      child: tabBar,
    );
  }
}
