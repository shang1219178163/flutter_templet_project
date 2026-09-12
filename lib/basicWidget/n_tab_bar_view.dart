//
//  TabBarPageView.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 5:03 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// TabBar + TabBarView
class NTabBarView extends StatefulWidget {
  const NTabBarView({
    super.key,
    required this.items,
    this.isReverse = false,
    this.isTabBottom = false,
    this.tabController,
    required this.onPageChanged,
    this.canPageChanged,
  });

  /// `(标题, 页面)` 列表
  final List<(String, Widget)> items;

  final bool isReverse;

  /// Tab 控制器
  final TabController? tabController;

  /// 左右滑动回调
  final ValueChanged<int> onPageChanged;

  /// 返回 false 时锁定不滚动
  final bool Function(int)? canPageChanged;

  /// tab 位置：false 顶部，true 底部
  final bool isTabBottom;

  @override
  NTabBarViewState createState() => NTabBarViewState();
}

class NTabBarViewState extends State<NTabBarView> with SingleTickerProviderStateMixin {
  late final bool _ownsTabController = widget.tabController == null;

  late final tabController = widget.tabController ??
      TabController(length: widget.items.length, vsync: this);

  /// 是否允许滚动
  bool get canScrollable {
    final disable = (widget.canPageChanged?.call(tabController.index) == false);
    return !disable;
  }

  late final theme = Theme.of(context);
  late final colorScheme = theme.colorScheme;
  late final onPrimary = colorScheme.onPrimary;
  late final primary = colorScheme.primary;

  Color get bgColor => widget.isReverse ? primary : onPrimary;
  Color get textColor => !widget.isReverse ? primary : onPrimary;

  @override
  void dispose() {
    if (_ownsTabController) {
      tabController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NTabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTabBottom != oldWidget.isTabBottom ||
        widget.items.map((e) => e.$1).join(',') != oldWidget.items.map((e) => e.$1).join(',')) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      buildTabBar(),
      buildTabBarView(),
    ];
    if (widget.isTabBottom) {
      children = children.reversed.toList();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget buildTabBar() {
    final borderSide = BorderSide(color: textColor, width: 2.0);
    var decorationTop = BoxDecoration(border: Border(top: borderSide));
    var decorationBom = BoxDecoration(border: Border(bottom: borderSide));

    final tabBar = TabBar(
      controller: tabController,
      tabs: widget.items.map((e) => Tab(text: e.$1)).toList(),
      dividerHeight: 0,
      labelColor: textColor,
      unselectedLabelColor: textColor.withValues(alpha: 0.5),
      indicatorColor: textColor,
      indicator: widget.isTabBottom ? decorationTop : decorationBom,
      onTap: (index) {
        setState(() {});
        widget.onPageChanged(index);
      },
    );

    if (!canScrollable) {
      return IgnorePointer(
        child: tabBar,
      );
    }

    return Material(
      color: bgColor,
      child: tabBar,
    );
  }

  Widget buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: tabController,
        physics: canScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        children: widget.items.map((e) => e.$2).toList(),
      ),
    );
  }
}
