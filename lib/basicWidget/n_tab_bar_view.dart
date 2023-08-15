//
//  TabBarPageView.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 5:03 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

/// TabBar + TabBarView
class NTabBarView extends StatefulWidget {

  const NTabBarView({
    Key? key,
    this.isTabBottom = false,
    required this.items,
    this.tabBgColor,
    this.labelColor,
    this.labelStyle,
    this.tabController,
    this.initialIndex = 0,
    required this.onPageChanged,
    this.canPageChanged,
  }) : super(key: key);


  final List<Tuple2<String, Widget>> items;
  /// tab背景颜色
  final Color? tabBgColor;
  /// 标题和指示器颜色
  final Color? labelColor;
  /// 字体样式
  final TextStyle? labelStyle;
  /// Tab 控制器
  final TabController? tabController;
  /// 初始索引
  final int initialIndex;
  /// 左右滑动回调
  final ValueChanged<int> onPageChanged;
  /// 范围 false 时,锁定不在滚动
  final bool Function(int)? canPageChanged;
  /// tab 位置底部 false 顶部, true 底部
  final bool isTabBottom;


  @override
  _NTabBarViewState createState() => _NTabBarViewState();
}

class _NTabBarViewState extends State<NTabBarView> with SingleTickerProviderStateMixin {

  late final _tabController = widget.tabController ?? TabController(
    initialIndex: widget.initialIndex,
    length: widget.items.length, vsync: this
  );

  ///是否允许滚动
  bool get canScrollable {
    final disable = (widget.canPageChanged?.call(_tabController.index) == false);
    return !disable;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var list = [
      _buildTabBar(),
      _buildTabBarView(),
    ];
    if (widget.isTabBottom) {
      list = list.reversed.toList();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }

  Widget _buildTabBar() {
    final textColor = widget.labelColor ?? Theme
        .of(context)
        .colorScheme
        .primary;

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
      labelStyle: widget.labelStyle,
      indicator: widget.isTabBottom ? decorationTop : decorationBom,
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

    // if (widget.isReverse) {
    //   return tabBar;
    // }

    return Material(
      color: widget.tabBgColor,
      child: SafeArea(
        child: tabBar,
      )
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: canScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: widget.items.map((e) => e.item2).toList(),
      ),
    );
  }

}