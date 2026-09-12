//
//  n_tab_page_view.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// TabBar + PageView 多页滑动封装
///
/// 支持：顶/底 Tab、反色、可滚动 Tab、自定义指示器、
/// 外部 [TabController]/[PageController]、按页锁定滑动。
class NTabPageView extends StatefulWidget {
  const NTabPageView({
    super.key,
    required this.items,
    this.indicator,
    this.isReverse = false,
    this.isScrollable = false,
    this.isBottom = false,
    this.tabAlignment = TabAlignment.center,
    this.pageController,
    this.tabController,
    this.onPageChanged,
    this.canPageChanged,
  });

  /// `(标题, 页面)` 列表
  final List<(String, Widget)> items;

  /// 自定义 Tab 指示器；为 null 时按 [isBottom] 使用顶/底边线
  final Decoration? indicator;

  /// true：主色底 + 反色字；false：反色底 + 主色字
  final bool isReverse;

  /// Tab 是否可横向滚动
  final bool isScrollable;

  /// true：Tab 在底部；false：在顶部
  final bool isBottom;

  /// Tab 对齐方式
  final TabAlignment tabAlignment;

  /// 外部 PageController；不传则内部创建并负责 dispose
  final PageController? pageController;

  /// 外部 TabController；不传则内部创建并负责 dispose
  final TabController? tabController;

  /// 页码变化回调
  final ValueChanged<int>? onPageChanged;

  /// 返回 false 时锁定当前页（禁止 Tab 点击与左右滑动）
  final bool Function(int index)? canPageChanged;

  @override
  State<NTabPageView> createState() => _NTabPageViewState();
}

class _NTabPageViewState extends State<NTabPageView> with TickerProviderStateMixin {
  late final bool _ownsTabController = widget.tabController == null;
  late final bool _ownsPageController = widget.pageController == null;

  late TabController tabController;
  late PageController pageController;

  late final scheme = Theme.of(context).colorScheme;

  Color get bgColor {
    return widget.isReverse ? scheme.primary : scheme.onPrimary;
  }

  Color get textColor {
    return widget.isReverse ? scheme.onPrimary : scheme.primary;
  }

  /// 当前页是否允许切换
  bool get canScroll => widget.canPageChanged?.call(tabController.index) != false;

  int get _safeMaxIndex => widget.items.isEmpty ? 0 : widget.items.length - 1;

  Decoration get effectiveIndicator {
    if (widget.indicator != null) {
      return widget.indicator!;
    }
    final side = BorderSide(color: textColor, width: 2);
    return BoxDecoration(
      border: Border(
        top: widget.isBottom ? side : BorderSide.none,
        bottom: widget.isBottom ? BorderSide.none : side,
      ),
    );
  }

  @override
  void dispose() {
    if (_ownsTabController) {
      tabController.dispose();
    }
    if (_ownsPageController) {
      pageController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController = widget.tabController ??
        TabController(
          length: widget.items.length,
          vsync: this,
        );
    pageController = widget.pageController ?? PageController(keepPage: true);
  }

  @override
  void didUpdateWidget(covariant NTabPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final names = widget.items.map((e) => e.$1).join(',');
    final oldNames = oldWidget.items.map((e) => e.$1).join(',');
    if (names != oldNames && _ownsTabController) {
      final old = tabController;
      final index = old.index.clamp(0, _safeMaxIndex);
      tabController = TabController(
        initialIndex: widget.items.isEmpty ? 0 : index,
        length: widget.items.length,
        vsync: this,
      );
      old.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty || tabController.length == 0) {
      return const SizedBox.shrink();
    }

    var children = [
      _buildTabBar(),
      Expanded(child: _buildPageView()),
    ];
    if (widget.isBottom) {
      children = children.reversed.toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildTabBar() {
    Widget tabBar = TabBar(
      controller: tabController,
      tabAlignment: widget.tabAlignment,
      isScrollable: widget.isScrollable,
      dividerHeight: 0,
      tabs: widget.items.map((e) => Tab(text: e.$1)).toList(),
      labelColor: textColor,
      unselectedLabelColor: textColor.withValues(alpha: 0.5),
      indicatorColor: textColor,
      indicator: effectiveIndicator,
      onTap: (index) {
        if (!canScroll) {
          return;
        }
        pageController.jumpToPage(index);
        setState(() {});
        widget.onPageChanged?.call(index);
      },
    );

    if (widget.tabAlignment == TabAlignment.center) {
      tabBar = Center(child: tabBar);
    }

    final bar = Material(
      color: bgColor,
      elevation: 0,
      child: tabBar,
    );

    if (!canScroll) {
      return IgnorePointer(child: bar);
    }
    return bar;
  }

  Widget _buildPageView() {
    return PageView(
      controller: pageController,
      physics: canScroll ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        tabController.animateTo(index);
        setState(() {});
        widget.onPageChanged?.call(index);
      },
      children: widget.items.map((e) => e.$2).toList(),
    );
  }
}
