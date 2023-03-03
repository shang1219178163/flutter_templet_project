//
//  tab_bar_segment.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/6 22:03.
//  Copyright © 2023/1/6 shang. All rights reserved.
//

import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const double _kTabHeight = 46.0;

typedef IndexedCallback = void Function(BuildContext context, int index);
// /// 分段选择器 builder
// typedef SegmentWidgetBuilder = Widget Function(BuildContext context, int index, bool isSelect);

/// TabBar 通用性封装
class TabBarSegment extends StatefulWidget implements PreferredSizeWidget {

  TabBarSegment({
    Key? key,
    required this.tabCount,
    required this.itemBuilder,
    this.initialIndex = 0,
    required this.currentIndex,
    this.controller,
    this.onTap,
    // this.onClick,
    this.isScrollable = true,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.physics,
    this.maxHeight = _kTabHeight
  }) : super(key: key);

  TabController? controller;
  /// 初始索引
  int initialIndex;
  /// 当前索引
  int currentIndex;
  /// 总数
  int tabCount;
  /// item builder
  IndexedWidgetBuilder itemBuilder;
  /// 点击回调
  ValueChanged<int>? onTap;
  // /// 点击回调
  // IndexedCallback? onClick;

  bool isScrollable;

  EdgeInsetsGeometry? padding;

  Color? indicatorColor;

  double indicatorWeight;

  EdgeInsetsGeometry indicatorPadding;

  Decoration? indicator;

  bool automaticIndicatorColorAdjustment;

  TabBarIndicatorSize? indicatorSize;

  Color? labelColor;

  Color? unselectedLabelColor;

  TextStyle? labelStyle;

  EdgeInsetsGeometry? labelPadding;

  TextStyle? unselectedLabelStyle;

  MaterialStateProperty<Color?>? overlayColor;

  DragStartBehavior dragStartBehavior;

  MouseCursor? mouseCursor;

  bool? enableFeedback;

  ScrollPhysics? physics;

  /// 设置为 AppBar 的 bottom 时子项 Tab 的最大高度
  double maxHeight;

  @override
  Size get preferredSize {
    // double maxHeight = _kTabHeight;
    return Size.fromHeight(maxHeight + indicatorWeight);
  }

  @override
  TabBarSegmentState createState() => TabBarSegmentState();
}

class TabBarSegmentState extends State<TabBarSegment> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  var _items = <Widget>[];

  @override
  void dispose() {
    // _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    widget.currentIndex = widget.initialIndex;
    _tabController = widget.controller ?? TabController(length: widget.tabCount, vsync: this);
    print("_tabController:${_tabController == widget.controller}");
    if (_tabController == null) {
      return;
    }
    _tabController!.index = widget.currentIndex;
    // _tabController?.addListener(() {
    //   if(!_tabController!.indexIsChanging){
    //     setState(() {
    //       widget.currentIndex = _tabController!.index;
    //       widget.onClick?.call(context, widget.currentIndex);
    //       // print("addListener:${widget.currentIndex}");
    //     });
    //   }
    // });
    // print("widget.tabController${_tabController?.index}");
    if (_items.isEmpty) {
      _items = List.generate(widget.tabCount, (index) => widget.itemBuilder(
          context,
          index,
      ));
      print("_itemBuilders.isEmpty");
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return TabBar(
      controller: _tabController,
      tabs: items,
      onTap: (index){
        widget.currentIndex = index;
        widget.onTap?.call(index);
        _tabController?.index = index;
        setState(() {});
      },
      isScrollable: widget.isScrollable,
      padding: widget.padding,
      indicatorColor: widget.indicatorColor,
      automaticIndicatorColorAdjustment: widget.automaticIndicatorColorAdjustment,
      indicatorWeight: widget.indicatorWeight,
      indicatorPadding: widget.indicatorPadding,
      indicator: widget.indicator,
      indicatorSize: widget.indicatorSize,
      labelColor: widget.labelColor,
      labelStyle: widget.labelStyle,
      labelPadding: widget.labelPadding,
      unselectedLabelColor: widget.unselectedLabelColor,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      dragStartBehavior: widget.dragStartBehavior,
      overlayColor: widget.overlayColor,
      mouseCursor: widget.mouseCursor,
      enableFeedback: widget.enableFeedback,
      physics: widget.physics,
    );

    return TabBar(
      controller: _tabController,
      tabs: items,
      onTap: (index){
        widget.currentIndex = index;
        widget.onTap?.call(index);
        _tabController?.index = index;
        setState(() {});
      },
      isScrollable: widget.isScrollable,
      padding: widget.padding,
      indicatorColor: widget.indicatorColor,
      automaticIndicatorColorAdjustment: widget.automaticIndicatorColorAdjustment,
      indicatorWeight: widget.indicatorWeight,
      indicatorPadding: widget.indicatorPadding,
      indicator: widget.indicator,
      indicatorSize: widget.indicatorSize,
      labelColor: widget.labelColor,
      labelStyle: widget.labelStyle,
      labelPadding: widget.labelPadding,
      unselectedLabelColor: widget.unselectedLabelColor,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      dragStartBehavior: widget.dragStartBehavior,
      overlayColor: widget.overlayColor,
      mouseCursor: widget.mouseCursor,
      enableFeedback: widget.enableFeedback,
      physics: widget.physics,
    );
  }

  /// 重置
  reset() {
    if (_tabController == null) {
      return;
    }
    _tabController!.index = widget.initialIndex;
  }

}