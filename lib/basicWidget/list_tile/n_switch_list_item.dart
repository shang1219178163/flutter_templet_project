//
//  NSwitchListItem.dart
//  flutter_templet_project
//
//  Created by shang on 2026/9/1.
//  Copyright © 2026/9/1 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 效果展示用的紧凑 [SwitchListTile]：`dense` + 零内边距 + 统一标题样式。
///
/// 不要设置 `inactiveTrackColor`。
class NSwitchListItem extends StatelessWidget {
  const NSwitchListItem({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.secondary,
    this.dense = true,
    this.contentPadding = EdgeInsets.zero,
    this.tileColor,
    this.selected = false,
    this.selectedTileColor,
    this.shape,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.thumbColor,
    this.trackColor,
    this.trackOutlineColor,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.enableFeedback,
    this.hoverColor,
    this.controlAffinity = ListTileControlAffinity.platform,
  });

  /// 是否打开
  final bool value;

  /// 开关变化；为 null 时禁用
  final ValueChanged<bool>? onChanged;

  /// 标题
  final Widget title;

  /// 副标题
  final Widget? subtitle;

  /// 左侧图标
  final Widget? secondary;

  /// 紧凑
  final bool dense;

  /// 内边距
  final EdgeInsetsGeometry contentPadding;

  /// 背景色
  final Color? tileColor;

  /// 是否选中态
  final bool selected;

  /// 选中背景色
  final Color? selectedTileColor;

  /// 形状
  final ShapeBorder? shape;

  /// 打开时滑块色
  final Color? activeColor;

  /// 打开时轨道色
  final Color? activeTrackColor;

  /// 关闭时滑块色
  final Color? inactiveThumbColor;

  /// 滑块色
  final WidgetStateProperty<Color?>? thumbColor;

  /// 轨道色
  final WidgetStateProperty<Color?>? trackColor;

  /// 轨道描边色
  final WidgetStateProperty<Color?>? trackOutlineColor;

  /// 点击目标尺寸
  final MaterialTapTargetSize? materialTapTargetSize;

  /// 指针样式
  final MouseCursor? mouseCursor;

  /// 水波纹色
  final WidgetStateProperty<Color?>? overlayColor;

  /// 水波纹半径
  final double? splashRadius;

  /// 焦点
  final FocusNode? focusNode;

  /// 焦点变化
  final ValueChanged<bool>? onFocusChange;

  /// 自动聚焦
  final bool autofocus;

  /// 反馈
  final bool? enableFeedback;

  /// 悬停色
  final Color? hoverColor;

  /// 控件位置
  final ListTileControlAffinity controlAffinity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final titleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: scheme.onSurface,
      fontSize: dense ? 13.5 : null,
    );
    return SwitchListTile(
      dense: dense,
      contentPadding: contentPadding,
      tileColor: tileColor,
      selected: selected,
      selectedTileColor: selectedTileColor,
      shape: shape,
      title: DefaultTextStyle.merge(
        style: titleStyle,
        child: title,
      ),
      subtitle: subtitle,
      secondary: secondary,
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      activeTrackColor: activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      thumbColor: thumbColor,
      trackColor: trackColor,
      trackOutlineColor: trackOutlineColor,
      materialTapTargetSize: materialTapTargetSize,
      mouseCursor: mouseCursor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      enableFeedback: enableFeedback,
      hoverColor: hoverColor,
      controlAffinity: controlAffinity,
    );
  }
}
