//
//  NTabBarPageCustom.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/9 09:45.
//  Copyright © 2024/3/9 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 选项卡页面封装
class NTabBarPageCustom extends StatefulWidget {
  const NTabBarPageCustom({
    super.key,
    required this.items,
    this.itemWidth = 160,
    this.itemHeight = 50,
    this.initialIndex = 0,
    this.tabBarAlignment = Alignment.center,
    this.isScrollable = false,
    this.isThemeBg = true,
    this.onTabBar,
    this.onChanged,
    this.headerBuilder,
    this.middleBuilder,
    this.footerBuilder,
  });

  final List<({AssetImage unselected, AssetImage selected, Widget child})>
      items;

  final double itemWidth;
  final double itemHeight;

  /// 初始索引
  final int initialIndex;

  final Alignment tabBarAlignment;

  final bool isScrollable;

  final bool isThemeBg;

  final ValueChanged<int>? onTabBar;
  final ValueChanged<int>? onChanged;

  final IndexedWidgetBuilder? headerBuilder;
  final IndexedWidgetBuilder? middleBuilder;
  final IndexedWidgetBuilder? footerBuilder;

  @override
  State<NTabBarPageCustom> createState() => _NTabBarPageCustomState();
}

class _NTabBarPageCustomState extends State<NTabBarPageCustom>
    with SingleTickerProviderStateMixin {
  late final List<({AssetImage unselected, AssetImage selected, Widget child})>
      items = widget.items;

  late final tabController = TabController(
    initialIndex: widget.initialIndex,
    length: items.length,
    vsync: this,
  );

  late final tabBarIndex = ValueNotifier(widget.initialIndex);

  late final colorScheme = Theme.of(context).colorScheme;

  Color get textColor {
    return widget.isThemeBg ? colorScheme.primary : colorScheme.onPrimary;
  }

  Color get bgColor {
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
  void didUpdateWidget(covariant NTabBarPageCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabBarAlignment != oldWidget.tabBarAlignment ||
        widget.isScrollable != oldWidget.isScrollable ||
        widget.isThemeBg != oldWidget.isThemeBg ||
        widget.items.length != oldWidget.items.length) {
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
            builder: (context, index, child) {
              return widget.headerBuilder?.call(context, index) ?? SizedBox();
            }),
        buildTabBar(),
        ValueListenableBuilder(
            valueListenable: tabBarIndex,
            builder: (context, index, child) {
              return widget.middleBuilder?.call(context, index) ?? SizedBox();
            }),
        Expanded(
          child: buildBody(),
        ),
        ValueListenableBuilder(
            valueListenable: tabBarIndex,
            builder: (context, index, child) {
              return widget.footerBuilder?.call(context, index) ?? SizedBox();
            }),
      ],
    );
  }

  Widget buildTabBar() {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: widget.tabBarAlignment,
        child: ValueListenableBuilder(
          valueListenable: tabBarIndex,
          builder: (context, value, child) {
            var labelPadding = EdgeInsets.symmetric(horizontal: 8);
            if (value == 0) {
              labelPadding = EdgeInsets.only(left: 16);
            } else if (value == widget.items.length - 1) {
              labelPadding = EdgeInsets.only(right: 16);
            }

            return SizedBox(
              height: widget.itemHeight + 16,
              child: TabBar(
                controller: tabController,
                isScrollable: widget.isScrollable,
                tabAlignment: TabAlignment.center,
                tabs: widget.items.map((e) {
                  final i = widget.items.indexOf(e);
                  final image = i == value ? e.selected : e.unselected;

                  return Tab(
                    child: Image(
                      image: image,
                      width: widget.itemWidth,
                      fit: BoxFit.fill,
                    ),
                  );
                }).toList(),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.transparent,
                // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
                labelColor: textColor,
                labelPadding: labelPadding,
                // indicatorColor: textColor,
                onTap: (index) {
                  tabBarIndex.value = index;
                  widget.onTabBar?.call(index);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBody() {
    return TabBarView(
      controller: tabController,
      children: items.map((e) => e.child).toList(),
    );
  }
}
