//
//  NChoiceChipListItem.dart
//  flutter_templet_project
//
//  Created by shang on 2026/9/1.
//  Copyright © 2026/9/1 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 类似 [NColorChoice] / [NChoiceColorListItem]：点标题折叠/展开，下方 [ChoiceChip] Wrap。
/// 标题后追加当前选中项，格式为 `标题 - 选中文案`。不支持 subtitle。
class NChoiceChipListItem<T> extends StatelessWidget {
  const NChoiceChipListItem({
    super.key,
    required this.values,
    required this.labelOf,
    required this.onChanged,
    this.value,
    this.onEqual,
    required this.title,
    this.secondary,
    this.dense = true,
    this.contentPadding,
    this.tileColor,
    this.selected = false,
    this.selectedTileColor,
    this.shape,
    this.spacing = 8,
    this.runSpacing = 8,
    this.showCheckmark = false,
    this.initiallyExpanded = false,
  });

  /// 选项
  final List<T> values;

  /// 当前值；未传 [onEqual] 时用 `==` 判断
  final T? value;

  /// 相等判断；为 null 时用 `e == value`
  final bool Function(T value)? onEqual;

  /// Chip 文案
  final String Function(T value) labelOf;

  /// 选中变化；为 null 时禁用
  final ValueChanged<T>? onChanged;

  /// 标题；点击折叠/展开
  final Widget title;

  /// 左侧图标；默认 [Icons.tune]
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

  /// Chip 水平间距
  final double spacing;

  /// Chip 垂直间距
  final double runSpacing;

  /// 是否显示勾选
  final bool showCheckmark;

  /// 初始是否展开
  final bool initiallyExpanded;

  bool get enabled => onChanged != null;

  /// 是否选中该项
  bool selectedOf(T e) => onEqual?.call(e) ?? (e == value);

  /// 当前选中项；无选中时为 null
  T? get selectedValue {
    for (final e in values) {
      if (selectedOf(e)) {
        return e;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = scheme.primary;
    final bg = selected ? (selectedTileColor ?? scheme.primaryContainer) : tileColor;
    final style = titleStyleOf(context, theme, accent);
    final current = selectedValue;
    final currentLabel = current == null ? null : labelOf(current);
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
              Icons.tune,
              color: accent,
              size: dense ? 20 : 24,
            ),
        title: DefaultTextStyle(
          style: style,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
          child: Row(
            children: [
              Flexible(
                child: title,
              ),
              if (currentLabel != null)
                Text(
                  ' - $currentLabel',
                  style: style,
                ),
            ],
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
                children: values.map((e) {
                  final chipSelected = selectedOf(e);
                  return ChoiceChip(
                    label: Text(labelOf(e)),
                    selected: chipSelected,
                    showCheckmark: showCheckmark,
                    selectedColor: scheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: chipSelected ? scheme.onPrimaryContainer : scheme.onSurface,
                      fontWeight: chipSelected ? FontWeight.w600 : FontWeight.w500,
                      fontFamily: 'monospace',
                      fontSize: dense ? 12.5 : 13.5,
                    ),
                    side: BorderSide(
                      color: chipSelected
                          ? scheme.primary.withValues(alpha: 0.35)
                          : scheme.outlineVariant.withValues(alpha: 0.65),
                    ),
                    onSelected: enabled
                        ? (on) {
                            if (on) {
                              onChanged!(e);
                            }
                          }
                        : null,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
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
