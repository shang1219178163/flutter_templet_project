//
//  NSliderListItem.dart
//  flutter_templet_project
//
//  Created by shang on 2026/8/31.
//  Copyright © 2026/8/31 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 类似 [SwitchListTile]，用 [Slider] 代替 [Switch]。
///
/// 标题、副标题与 [Slider] 同一行；滑条宽度为组件整宽的 [sliderWidthFactor]。
class NSliderListItem extends StatelessWidget {
  const NSliderListItem({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.secondaryTrackValue,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.allowedInteraction,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.tileColor,
    this.title,
    this.subtitle,
    this.secondary,
    this.trailing,
    this.valueBuilder,
    this.showValue = true,
    this.sliderWidthFactor = 0.5,
    this.isThreeLine = false,
    this.dense,
    this.contentPadding,
    this.selected = false,
    this.shape,
    this.selectedTileColor,
    this.visualDensity,
    this.enableFeedback,
    this.hoverColor,
    this.horizontalTitleGap,
    this.minLeadingWidth,
    this.minVerticalPadding,
    this.titleAlignment,
  })  : assert(min <= max),
        assert(value >= min && value <= max),
        assert(secondaryTrackValue == null || (secondaryTrackValue >= min && secondaryTrackValue <= max)),
        assert(divisions == null || divisions > 0),
        assert(!isThreeLine || subtitle != null),
        assert(sliderWidthFactor > 0 && sliderWidthFactor <= 1);

  /// 当前值
  final double value;

  /// 值变化；为 null 时禁用
  final ValueChanged<double>? onChanged;

  /// 开始拖动
  final ValueChanged<double>? onChangeStart;

  /// 结束拖动
  final ValueChanged<double>? onChangeEnd;

  /// 最小值
  final double min;

  /// 最大值
  final double max;

  /// 分段数
  final int? divisions;

  /// 拖动时的气泡文案
  final String? label;

  /// 次轨道值
  final double? secondaryTrackValue;

  /// 激活色
  final Color? activeColor;

  /// 未激活色
  final Color? inactiveColor;

  /// 次轨道色
  final Color? secondaryActiveColor;

  /// 滑块色
  final Color? thumbColor;

  /// 水波纹色
  final WidgetStateProperty<Color?>? overlayColor;

  /// 鼠标样式
  final MouseCursor? mouseCursor;

  /// 语义格式化
  final SemanticFormatterCallback? semanticFormatterCallback;

  /// 允许的交互
  final SliderInteraction? allowedInteraction;

  /// 焦点
  final FocusNode? focusNode;

  /// 焦点变化
  final ValueChanged<bool>? onFocusChange;

  /// 自动聚焦
  final bool autofocus;

  /// 背景色
  final Color? tileColor;

  /// 标题
  final Widget? title;

  /// 副标题
  final Widget? subtitle;

  /// 左侧图标，对应 [SwitchListTile.secondary]
  final Widget? secondary;

  /// 滑条右侧的额外内容
  final Widget? trailing;

  /// 自定义数值展示
  final Widget Function(BuildContext context, double value)? valueBuilder;

  /// 是否显示默认数值
  final bool showValue;

  /// 滑条占组件整宽的比例，0～1
  final double sliderWidthFactor;

  /// 三行布局
  final bool isThreeLine;

  /// 紧凑
  final bool? dense;

  /// 内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 是否选中
  final bool selected;

  /// 形状
  final ShapeBorder? shape;

  /// 选中背景色
  final Color? selectedTileColor;

  /// 视觉密度
  final VisualDensity? visualDensity;

  /// 是否启用反馈
  final bool? enableFeedback;

  /// 悬停色
  final Color? hoverColor;

  /// 标题与 leading 间距
  final double? horizontalTitleGap;

  /// leading 最小宽度
  final double? minLeadingWidth;

  /// 垂直内边距
  final double? minVerticalPadding;

  /// 标题对齐
  final ListTileTitleAlignment? titleAlignment;

  bool get enabled => onChanged != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueWidget = buildValue(context, theme);
    final pad = contentPadding ?? EdgeInsets.zero;
    final gap = horizontalTitleGap ?? 8;
    final vPad = minVerticalPadding ?? (dense == true ? 8.0 : 16.0);
    final hPad = dense == true ? 0.0 : 24.0;
    return MergeSemantics(
      child: Material(
        color: selected ? (selectedTileColor ?? theme.colorScheme.primaryContainer) : (tileColor ?? Colors.transparent),
        shape: shape,
        child: Padding(
          padding: pad.add(EdgeInsets.symmetric(vertical: vPad, horizontal: hPad)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final sliderW = constraints.maxWidth * sliderWidthFactor;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (secondary != null) ...[
                    SizedBox(
                      width: minLeadingWidth,
                      child: secondary,
                    ),
                    SizedBox(width: gap),
                  ],
                  if (title != null || subtitle != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (title != null)
                              DefaultTextStyle(
                                style: titleStyleOf(context, theme),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                child: title!,
                              ),
                            if (subtitle != null)
                              DefaultTextStyle(
                                style: theme.textTheme.bodyMedium?.copyWith(
                                      color: enabled ? theme.colorScheme.onSurfaceVariant : theme.disabledColor,
                                      fontSize: dense == true ? 12 : null,
                                      height: 1,
                                    ) ??
                                    const TextStyle(height: 1),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                child: subtitle!,
                              ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    width: sliderW,
                    child: Row(
                      children: [
                        Expanded(child: buildSlider(theme)),
                        if (valueWidget != null) valueWidget,
                        if (trailing != null) trailing!,
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget? buildValue(BuildContext context, ThemeData theme) {
    if (valueBuilder != null) {
      return valueBuilder!(context, value);
    }
    if (!showValue) {
      return null;
    }
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: enabled ? theme.colorScheme.onSurfaceVariant : theme.disabledColor,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return SizedBox(
      width: 40,
      child: Text(formatValue(value), style: style, textAlign: TextAlign.end),
    );
  }

  TextStyle titleStyleOf(BuildContext context, ThemeData theme) {
    final tileTheme = ListTileTheme.of(context);
    final defaultsStyle = theme.useMaterial3
        ? (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(color: theme.colorScheme.onSurface)
        : (theme.textTheme.titleMedium ?? const TextStyle());
    final titleColor = !enabled
        ? theme.disabledColor
        : selected
            ? (tileTheme.selectedColor ?? theme.colorScheme.primary)
            : tileTheme.textColor;
    return (tileTheme.titleTextStyle ?? defaultsStyle).copyWith(
      color: titleColor,
      fontSize: dense == true ? 13 : null,
    );
  }

  Widget buildSlider(ThemeData theme) {
    return SliderTheme(
      data: theme.sliderTheme.copyWith(
        overlayShape: SliderComponentShape.noOverlay,
        trackHeight: 2,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
      child: Slider(
        value: value,
        secondaryTrackValue: secondaryTrackValue,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        min: min,
        max: max,
        divisions: divisions,
        label: label ?? formatValue(value),
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        secondaryActiveColor: secondaryActiveColor,
        thumbColor: thumbColor,
        overlayColor: overlayColor,
        mouseCursor: mouseCursor,
        semanticFormatterCallback: semanticFormatterCallback,
        focusNode: focusNode,
        autofocus: autofocus,
        allowedInteraction: allowedInteraction,
      ),
    );
  }

  String formatValue(double v) {
    if (max > 1) {
      return v.toStringAsFixed(0);
    }
    return v.toStringAsFixed(2);
  }
}
