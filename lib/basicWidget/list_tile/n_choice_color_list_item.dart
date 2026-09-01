//
//  NChoiceColorListItem.dart
//  flutter_templet_project
//
//  Created by shang on 2026/9/1.
//  Copyright © 2026/9/1 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// 类似 [NColorChoice] 的颜色选择行：点标题折叠/展开，下方圆形色点。不支持 subtitle。
class NChoiceColorListItem extends StatelessWidget {
  const NChoiceColorListItem({
    super.key,
    required this.value,
    required this.onChanged,
    this.colors = AppColor.colorOptions,
    this.title,
    this.secondary,
    this.dense = true,
    this.contentPadding,
    this.tileColor,
    this.selected = false,
    this.selectedTileColor,
    this.shape,
    this.dotSize = 32,
    this.spacing = 8,
    this.runSpacing = 8,
    this.nullLabel = '默',
    this.initiallyExpanded = false,
  });

  /// 当前颜色；`null` 表示主题默认
  final Color? value;

  /// 选中变化；为 null 时禁用
  final ValueChanged<Color?>? onChanged;

  /// 可选颜色；含 `null` 表示「默」
  final List<Color?> colors;

  /// 标题；点击折叠/展开
  final Widget? title;

  /// 左侧图标；默认 [Icons.color_lens]
  final Widget? secondary;

  /// 紧凑
  final bool dense;

  /// 标题行内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 背景色
  final Color? tileColor;

  /// 是否选中态
  final bool selected;

  /// 选中背景色
  final Color? selectedTileColor;

  /// 形状
  final ShapeBorder? shape;

  /// 色点直径
  final double dotSize;

  /// 色点水平间距
  final double spacing;

  /// 色点垂直间距
  final double runSpacing;

  /// `null` 色点文案
  final String nullLabel;

  /// 初始是否展开
  final bool initiallyExpanded;

  bool get enabled => onChanged != null;

  /// 与 [NColorChoice] 一致：图标/标题跟当前色
  Color accentOf(ColorScheme scheme) {
    return value ?? scheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = accentOf(scheme);
    final bg = selected ? (selectedTileColor ?? scheme.primaryContainer) : tileColor;
    return Theme(
      data: theme.copyWith(
        dividerColor: Colors.transparent,
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: accent,
          collapsedIconColor: accent,
          backgroundColor: bg,
          collapsedBackgroundColor: bg,
          shape: shape,
          collapsedShape: shape,
          tilePadding: contentPadding ?? (dense ? const EdgeInsets.symmetric(horizontal: 0) : null),
          childrenPadding: EdgeInsets.zero,
        ),
      ),
      child: ExpansionTile(
        leading: secondary ??
            Icon(
              Icons.color_lens,
              color: accent,
              size: dense ? 20 : 24,
            ),
        title: DefaultTextStyle(
          style: titleStyleOf(context, theme, accent),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
          child: title ??
              Text(
                '颜色',
                style: TextStyle(color: accent),
              ),
        ),
        initiallyExpanded: initiallyExpanded,
        dense: dense,
        enabled: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: colors.map((e) => buildDot(context, theme, e)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(BuildContext context, ThemeData theme, Color? color) {
    final scheme = theme.colorScheme;
    final isSelected = value == color;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged!(color) : null,
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: dotSize,
          height: dotSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color ?? scheme.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.65),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.28),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: color == null
              ? Text(
                  nullLabel,
                  style: TextStyle(
                    fontSize: dense ? 10 : 12,
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : isSelected
                  ? Icon(
                      Icons.check_rounded,
                      size: dense ? 16 : 18,
                      color: ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    )
                  : null,
        ),
      ),
    );
  }

  TextStyle titleStyleOf(BuildContext context, ThemeData theme, Color accent) {
    final tileTheme = ListTileTheme.of(context);
    final defaultsStyle = theme.useMaterial3
        ? (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(color: accent)
        : (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(color: accent);
    return (tileTheme.titleTextStyle ?? defaultsStyle).copyWith(
      color: enabled ? accent : theme.disabledColor,
      fontSize: dense ? 13 : null,
    );
  }
}
