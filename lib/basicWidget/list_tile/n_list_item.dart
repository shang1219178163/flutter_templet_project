//
//  n_list_item.dart
//  flutter_templet_project
//
//  Created by shang on 2026/9/1.
//  Copyright © 2026/9/1 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 简化版 [ListTile]，用于列表行。
class NListItem extends StatelessWidget {
  const NListItem({
    super.key,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 11,
    ),
    this.spacing = 8,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.accessory,
    this.onTap,
  });

  /// 内容区内边距
  final EdgeInsetsGeometry padding;

  final double spacing;

  /// 主文案，对应 `textLabel`
  final Widget title;

  final Widget? subtitle;

  /// 左侧图标，对应 `imageView`
  final Widget? leading;

  /// 右侧自定义控件；非 null 时优先于 [accessory]
  final Widget? trailing;

  /// 自定义附件，对应 `accessoryView`
  final Widget? accessory;

  /// 行点击
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final inverseColor = isDark ? Colors.white : Colors.black;

    final tileTheme = ListTileTheme.of(context);
    final titleStyle = tileTheme.titleTextStyle ??
        (theme.useMaterial3
            ? theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurface)
            : theme.textTheme.titleMedium!);
    final subtitleStyle = tileTheme.subtitleTextStyle ??
        (theme.useMaterial3
            ? theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSurfaceVariant)
            : theme.textTheme.bodyMedium!.copyWith(color: theme.textTheme.bodySmall?.color));

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null)
              Padding(
                padding: EdgeInsets.only(right: spacing),
                child: leading,
              ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: title,
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: DefaultTextStyle(
                          style: subtitleStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          child: subtitle!,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (accessory != null)
              Padding(
                padding: EdgeInsets.only(left: spacing),
                child: accessory!,
              ),
            Padding(
              padding: EdgeInsets.only(left: spacing),
              child: trailing ??
                  Icon(
                    Icons.chevron_right,
                    color: inverseColor.withValues(alpha: 0.12),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
