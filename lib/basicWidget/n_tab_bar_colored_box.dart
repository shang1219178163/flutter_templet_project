//
//  NTabBarColoredBox.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/22 10:52.
//  Copyright © 2024/3/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

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

// class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
//
//   ColoredTabBar({
//     super.key,
//     required this.color,
//     this.padding,
//     this.decoration,
//     this.width,
//     this.height,
//     required this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Ink(
//       padding: padding,
//       color: color,
//       decoration: decoration,
//       width: width,
//       height: height,
//       child: child,
//     );
//   }
//
//   final EdgeInsetsGeometry? padding;
//   final Color? color;
//   final Decoration ? decoration;
//
//   final double? width;
//   final double? height;
//   final PreferredSizeWidget child;
//
//
//   @override
//   Size get preferredSize => child.preferredSize;
// }
