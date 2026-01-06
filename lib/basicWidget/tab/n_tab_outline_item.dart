//
//  NTabItem.dart
//  projects
//
//  Created by shang on 2026/1/6 16:00.
//  Copyright © 2026/1/6 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// Outline 风格 tab item
class NTabOutlineItem extends StatelessWidget {
  const NTabOutlineItem({
    super.key,
    required this.title,
    required this.isSelected,
    this.padding = EdgeInsets.zero,
    this.fontColor,
    this.unselectedFontColor,
    this.builder,
  });

  final String title;
  final bool isSelected;

  final EdgeInsetsGeometry? padding;
  final Color? fontColor;
  final Color? unselectedFontColor;

  final Widget Function(BuildContext context, Widget child)? builder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabBarTheme = theme.tabBarTheme;
    final isDark = theme.brightness == Brightness.dark;

    final labelColor = fontColor ?? tabBarTheme.labelColor ?? Colors.red;
    final unselectedLabelColor = unselectedFontColor ?? tabBarTheme.unselectedLabelColor ?? Colors.black54;

    final borderColor = isSelected ? labelColor : Colors.transparent;
    final bgColor = isSelected ? borderColor.withOpacity(0.05) : Colors.black.withOpacity(0.05);

    final textStyle = isSelected
        ? TextStyle(
            color: labelColor,
            fontSize: 14,
            fontFamily: 'PingFang SC',
            // fontWeight: FontWeight.w500,
            // height: 1.29,
          )
        : TextStyle(
            color: unselectedLabelColor,
            fontSize: 14,
            fontFamily: 'PingFang SC',
            // fontWeight: FontWeight.w500,
            // height: 1.29,
          );

    final child = Text(
      title,
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );

    return Container(
      padding: padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 0.5),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: builder?.call(context, child) ?? child,
    );
  }
}
