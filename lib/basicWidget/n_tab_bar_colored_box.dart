//
//  NTabBarColoredBox.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/22 10:52.
//  Copyright © 2024/3/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_indicator_fixed.dart';

/// TabBar 设置颜色
class NTabBarColoredBox extends StatelessWidget implements PreferredSizeWidget {
  const NTabBarColoredBox({
    super.key,
    this.backgroudColor,
    this.padding,
    this.decoration,
    this.height,
    this.width,
    this.labelColor,
    this.tabBarTheme,
    required this.child,
  });

  final double? width;
  final double? height;

  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;

  final Color? labelColor;
  final Color? backgroudColor;
  final TabBarTheme? tabBarTheme;

  final PreferredSizeWidget child;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: padding,
      color: backgroudColor,
      decoration: decoration,
      width: width ?? double.maxFinite,
      height: height,
      // child: child,
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent, // 点击时的水波纹颜色设置为透明
          highlightColor: Colors.transparent, // 点击时的背景高亮颜色设置为透明
          tabBarTheme: tabBarTheme ??
              TabBarTheme(
                dividerColor: Colors.transparent,
                labelColor: labelColor,
                unselectedLabelColor: labelColor,
                indicatorColor: labelColor,
              ),
        ),
        child: child,
      ),
    );
  }
}

/// 原 MyTabBar
class NTabBar extends StatelessWidget {
  const NTabBar({
    super.key,
    required this.tabs,
    required this.tabController,
    this.isScrollable = true,
    this.padding,
    this.indicatorColor,
    this.indicatorPadding,
    this.indicatorMargin,
    this.labelPadding,
    this.labelColor,
    this.labelStyle,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
  });

  /// 标题数组
  final List<Widget> tabs;

  /// 控制器
  final TabController? tabController;

  /// TabBar's isScrollable
  final bool isScrollable;

  /// TabBar's padding
  final EdgeInsets? padding;

  /// TabBar's labelPadding
  final EdgeInsetsGeometry? indicatorPadding;

  /// 指示器颜色
  final Color? indicatorColor;

  /// TabBar's padding
  final EdgeInsets? indicatorMargin;

  /// TabBar's labelPadding
  final EdgeInsetsGeometry? labelPadding;

  /// TabBar's labelColor
  final Color? labelColor;

  /// TabBar's labelStyle
  final TextStyle? labelStyle;

  /// TabBar's unselectedLabelColor
  final Color? unselectedLabelColor;

  /// TabBar's unselectedLabelStyle
  final TextStyle? unselectedLabelStyle;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.maxFinite, 44),
      child: SizedBox(
        height: 42,
        child: TabBar(
          tabs: tabs,
          controller: tabController,
          isScrollable: isScrollable,
          padding: padding,
          indicatorPadding:
              indicatorPadding ?? const EdgeInsets.symmetric(horizontal: 20),
          indicator: NTabBarIndicatorFixed(
            width: 24,
            height: 2,
            color: indicatorColor ?? Theme.of(context).primaryColor,
            radius: 0,
          ),
          labelPadding: labelPadding ??
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),
          labelColor: labelColor,
          labelStyle: labelStyle ??
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelColor: unselectedLabelColor,
          unselectedLabelStyle: unselectedLabelStyle ??
              TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
