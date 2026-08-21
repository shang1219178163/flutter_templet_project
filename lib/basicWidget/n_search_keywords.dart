import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_wrap.dart';

/// 搜索关键词历史：标题行 + 可展开词条列表；无历史时不展示。
class NSearchKeyWords extends StatelessWidget {
  const NSearchKeyWords({
    super.key,
    required this.items,
    required this.onTap,
    this.onDelete,
    required this.onClear,
    this.isLoading = false,
    this.onExpandedChanged,
    this.title = '历史搜索',
    this.collapsedCount = 3,
    this.maxCount = defaultMaxCount,
    this.titleColor = Colors.blue,
    this.subtitleColor = Colors.grey,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.blue,
  });

  /// 默认最多保留条数。
  static const int defaultMaxCount = 10;

  /// 新词插入第 0 位，超出 [maxCount] 时移除最后一位；已在列表中则只移到第一位。
  static List<String> insert(
    List<String> current,
    String keyword, {
    int maxCount = defaultMaxCount,
  }) {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) {
      return current;
    }
    final existingIndex = current.indexOf(trimmed);
    if (existingIndex == 0) {
      return current;
    }
    if (existingIndex > 0) {
      final updated = List<String>.from(current);
      updated.removeAt(existingIndex);
      updated.insert(0, trimmed);
      return updated;
    }
    final updated = <String>[trimmed, ...current];
    if (updated.length > maxCount) {
      updated.removeLast();
    }
    return updated;
  }

  /// 历史关键词列表。
  final List<String> items;

  /// 是否仍在加载。
  final bool isLoading;

  /// 点击词条。
  final ValueChanged<String> onTap;

  /// 长按删除词条；为 null 时不可删除。
  final ValueChanged<String>? onDelete;

  /// 清空全部历史。
  final VoidCallback onClear;

  /// 展开/收起状态变化。
  final ValueChanged<bool>? onExpandedChanged;

  /// 标题文案。
  final String title;

  /// 收起时最多展示条数。
  final int collapsedCount;

  /// 最多保留条数；超出时只展示前 [maxCount] 条。
  final int maxCount;

  final Color titleColor;
  final Color subtitleColor;
  final Color backgroundColor;
  final Color borderColor;

  List<String> get visibleItems => items.length > maxCount ? items.sublist(0, maxCount) : items;

  @override
  Widget build(BuildContext context) {
    if (visibleItems.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildHeader(),
        Expanded(child: buildBody()),
      ],
    );
  }

  /// 标题行 + 右侧清空图标。
  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
          ),
          if (visibleItems.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              behavior: HitTestBehavior.opaque,
              child: Icon(Icons.delete, size: 18, color: subtitleColor),
            ),
        ],
      ),
    );
  }

  /// 词条列表；加载中隐藏。
  Widget buildBody() {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Align(
        alignment: Alignment.topLeft,
        child: NExpandWrap<String>(
          items: visibleItems,
          collapsedCount: collapsedCount,
          onExpandedChanged: onExpandedChanged,
          itemBuilder: (context, keyword, index) => _HistoryChip(
            keyword: keyword,
            onTap: () => onTap(keyword),
            onDelete: onDelete == null ? null : () => onDelete!(keyword),
            titleColor: titleColor,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
          ),
          iconBuilder: (context, isExpanded) {
            if (visibleItems.length <= collapsedCount) {
              return const SizedBox.shrink();
            }
            return _ExpandToggleChip(
              isExpanded: isExpanded,
              titleColor: titleColor,
              backgroundColor: backgroundColor,
              borderColor: borderColor,
            );
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('items', items));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
    properties.add(ObjectFlagProperty<ValueChanged<String>>.has('onTap', onTap));
    properties.add(ObjectFlagProperty<ValueChanged<String>?>.has('onDelete', onDelete));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onClear', onClear));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onExpandedChanged', onExpandedChanged));
    properties.add(StringProperty('title', title));
    properties.add(IntProperty('collapsedCount', collapsedCount));
    properties.add(IntProperty('maxCount', maxCount));
    properties.add(ColorProperty('titleColor', titleColor));
    properties.add(ColorProperty('subtitleColor', subtitleColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(IterableProperty<String>('visibleItems', visibleItems));
  }
}

/// 单个历史词条 chip：点击填入搜索框；[onDelete] 非空时可长按删除。
class _HistoryChip extends StatelessWidget {
  const _HistoryChip({
    required this.keyword,
    required this.onTap,
    this.onDelete,
    required this.titleColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final String keyword;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final Color titleColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    const chipHeight = 31.0;
    const chipRadius = 4.0;
    const chipHorizontalPadding = 12.0;
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onDelete,
        child: Container(
          height: chipHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: chipHorizontalPadding,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(chipRadius),
            border: Border.all(color: borderColor, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            keyword,
            style: TextStyle(
              fontSize: 14,
              color: titleColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('keyword', keyword));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onDelete', onDelete));
    properties.add(ColorProperty('titleColor', titleColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('borderColor', borderColor));
  }
}

/// 展开/收起按钮：收起箭头向下，展开箭头向上。
class _ExpandToggleChip extends StatelessWidget {
  const _ExpandToggleChip({
    required this.isExpanded,
    required this.titleColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final bool isExpanded;
  final Color titleColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    const size = 31.0;
    const radius = 4.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: 1),
      ),
      alignment: Alignment.center,
      child: Icon(
        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        size: 20,
        color: titleColor,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isExpanded', isExpanded));
    properties.add(ColorProperty('titleColor', titleColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('borderColor', borderColor));
  }
}
