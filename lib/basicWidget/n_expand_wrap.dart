import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 可展开/收起的 [Wrap]：数据超过阈值时末尾展示切换按钮。
///
/// 收起时仅展示前 [collapsedCount] 项；展开后展示全部。
/// 展开/收起按钮外观由 [iconBuilder] 提供。
class NExpandWrap<T> extends StatefulWidget {
  const NExpandWrap({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.iconBuilder,
    this.onExpandedChanged,
    this.collapsedCount = 3,
    this.spacing = 8,
    this.runSpacing = 8,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  /// 全部数据项。
  final List<T> items;

  /// 单项样式构建；[index] 为在完整 [items] 中的下标。
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// 展开/收起按钮样式；[isExpanded] 为当前是否已展开。
  final Widget Function(BuildContext context, bool isExpanded) iconBuilder;

  /// 展开状态切换回调；参数为切换后的是否已展开。
  final ValueChanged<bool>? onExpandedChanged;

  /// 收起时最多展示的子项数量；仅当 [items.length] 大于该值时显示展开按钮。
  final int collapsedCount;

  /// 主轴方向子项间距。
  final double spacing;

  /// 交叉轴方向行间距。
  final double runSpacing;

  /// Wrap 主轴对齐。
  final WrapAlignment alignment;

  /// Wrap 交叉轴对齐。
  final WrapCrossAlignment crossAxisAlignment;

  @override
  State<NExpandWrap<T>> createState() => _NExpandWrapState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<T>('items', items));
    properties.add(
        ObjectFlagProperty<Widget Function(BuildContext context, T item, int index)>.has('itemBuilder', itemBuilder));
    properties.add(
        ObjectFlagProperty<Widget Function(BuildContext context, bool isExpanded)>.has('iconBuilder', iconBuilder));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onExpandedChanged', onExpandedChanged));
    properties.add(IntProperty('collapsedCount', collapsedCount));
    properties.add(DoubleProperty('spacing', spacing));
    properties.add(DoubleProperty('runSpacing', runSpacing));
    properties.add(EnumProperty<WrapAlignment>('alignment', alignment));
    properties.add(EnumProperty<WrapCrossAlignment>('crossAxisAlignment', crossAxisAlignment));
  }
}

class _NExpandWrapState<T> extends State<NExpandWrap<T>> {
  bool isExpanded = false;

  void onToggle() {
    isExpanded = !isExpanded;
    setState(() {});
    widget.onExpandedChanged?.call(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final canToggleExpand = items.length > widget.collapsedCount;
    final visibleCount = canToggleExpand && !isExpanded ? widget.collapsedCount : items.length;
    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      alignment: widget.alignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: [
        for (var index = 0; index < visibleCount; index++) widget.itemBuilder(context, items[index], index),
        if (canToggleExpand)
          GestureDetector(
            onTap: onToggle,
            child: widget.iconBuilder(context, isExpanded),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isExpanded', isExpanded));
  }
}
