//
//  NTabBarPage.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/9 09:45.
//  Copyright © 2024/3/9 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';


/// 选项卡页面封装
class NTabBarPage extends StatefulWidget {

  const NTabBarPage({
    super.key,
    required this.items,
    this.tabBarAlignment = Alignment.center,
    this.isScrollable = false,
    this.isThemeBg = true,
    this.onTabBar,
    this.onChanged,
    this.headerBuilder,
    this.middleBuilder,
    this.footerBuilder,
  });

  final List<Tuple2<String, Widget>> items;

  final Alignment tabBarAlignment;

  final bool isScrollable;

  final bool isThemeBg;

  final ValueChanged<int>? onTabBar;
  final ValueChanged<int>? onChanged;

  final IndexedWidgetBuilder? headerBuilder;
  final IndexedWidgetBuilder? middleBuilder;
  final IndexedWidgetBuilder? footerBuilder;

  @override
  State<NTabBarPage> createState() => _NTabBarPageState();
}

class _NTabBarPageState extends State<NTabBarPage> with SingleTickerProviderStateMixin {

  late final List<Tuple2<String, Widget>> items = widget.items;

  late final tabController = TabController(length: items.length, vsync: this);

  final tabBarIndex = ValueNotifier(0);

  late final colorScheme = Theme.of(context).colorScheme;

  Color get textColor{
    return widget.isThemeBg ? colorScheme.primary : colorScheme.onPrimary;
  }

  Color get bgColor{
    return widget.isThemeBg ? colorScheme.onPrimary : colorScheme.primary;
  }

  @override
  void dispose() {
    tabController.removeListener(onListener);
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    tabController.addListener(onListener);
  }

  @override
  void didUpdateWidget(covariant NTabBarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabBarAlignment != oldWidget.tabBarAlignment ||
        widget.isScrollable != oldWidget.isScrollable ||
        widget.isThemeBg != oldWidget.isThemeBg ||
        widget.items.map((e) => e.item1).join(",") != oldWidget.items.map((e) => e.item1).join(",")) {
      setState(() {});
    }
  }

  onListener() {
    if (!tabController.indexIsChanging) {
      tabBarIndex.value = tabController.index;
      widget.onChanged?.call(tabBarIndex.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder(
           valueListenable: tabBarIndex,
           builder: (context, index, child){
            return widget.headerBuilder?.call(context, index) ?? SizedBox();
          }
        ),
        buildTabBar(),
        ValueListenableBuilder(
          valueListenable: tabBarIndex,
          builder: (context, index, child){
            return widget.middleBuilder?.call(context, index) ?? SizedBox();
          }
        ),
        Expanded(
          child: buildBody(),
        ),
        ValueListenableBuilder(
          valueListenable: tabBarIndex,
          builder: (context, index, child){
            return widget.footerBuilder?.call(context, index) ?? SizedBox();
          }
        ),
      ],
    );
  }

  Widget buildTabBar() {
    return Material(
      color: bgColor,
      child: Align(
        alignment: widget.tabBarAlignment,
        child: TabBar(
          controller: tabController,
          isScrollable: widget.isScrollable,
          tabAlignment: TabAlignment.center,
          tabs: items.map((e) => Tab(text: e.item1)).toList(),
          indicatorSize: TabBarIndicatorSize.label,
          // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
          labelColor: textColor,
          indicatorColor: textColor,
          onTap: widget.onTabBar,
        ),
      ),
    );
  }

  Widget buildBody() {
    return TabBarView(
      controller: tabController,
      children: items.map((e) => e.item2).toList(),
    );
  }
}