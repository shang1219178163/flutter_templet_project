import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_page_indicator.dart';

/// 横向分页 Wrap：每页固定列×行（默认 4 列 2 行 = 8 项），底部带页面指示器。
class NWrapPageView<T> extends StatefulWidget {
  const NWrapPageView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 4,
    this.rowCount = 2,
    this.spacing = 8,
    this.runSpacing = 8,
    this.height,
    this.padding = EdgeInsets.zero,
    this.indicatorMargin = const EdgeInsets.only(top: 12),
    this.indicatorItemSize = const Size(8, 3),
    this.indicatorNormalColor = const Color(0x332196F3),
    this.indicatorSelectedColor = const Color(0xFF2196F3),
    this.onPageChanged,
  });

  /// 数据源
  final List<T> items;

  /// 子项构建
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// 每页列数（默认 4）
  final int crossAxisCount;

  /// 每页行数（默认 2）
  final int rowCount;

  /// Wrap 主轴间距
  final double spacing;

  /// Wrap 交叉轴间距
  final double runSpacing;

  /// PageView 区域高度；为空时用 AspectRatio 兜底
  final double? height;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry indicatorMargin;

  final Size indicatorItemSize;

  final Color indicatorNormalColor;

  final Color indicatorSelectedColor;

  final ValueChanged<int>? onPageChanged;

  /// 每页容量
  int get pageSize => crossAxisCount * rowCount;

  /// 子项宽度：`(contentWidth - spacing * (crossAxisCount - 1)) / crossAxisCount`
  /// [contentWidth] 为扣除左右页边距（各 spacing/2）后的宽度。
  static double itemWidthOf({
    required double pageWidth,
    required int crossAxisCount,
    required double spacing,
  }) {
    final contentWidth = pageWidth - spacing;
    if (contentWidth <= 0 || crossAxisCount <= 0) {
      return 0;
    }
    return (contentWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;
  }

  /// 子项高度：`(pageHeight - runSpacing * (rowCount - 1)) / rowCount`
  static double itemHeightOf({
    required double pageHeight,
    required int rowCount,
    required double runSpacing,
  }) {
    if (pageHeight <= 0 || rowCount <= 0) {
      return 0;
    }
    return (pageHeight - runSpacing * (rowCount - 1)) / rowCount;
  }

  @override
  State<NWrapPageView<T>> createState() => _NWrapPageViewState<T>();
}

class _NWrapPageViewState<T> extends State<NWrapPageView<T>> {
  late final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  int get _pageCount {
    if (widget.items.isEmpty) {
      return 0;
    }
    return (widget.items.length / widget.pageSize).ceil();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty || _pageCount == 0) {
      return const SizedBox.shrink();
    }

    final pageView = PageView.builder(
      controller: _pageController,
      itemCount: _pageCount,
      onPageChanged: (index) {
        _currentPage.value = index;
        widget.onPageChanged?.call(index);
      },
      itemBuilder: (context, pageIndex) => buildPage(context, pageIndex),
    );

    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.height != null)
            SizedBox(height: widget.height, child: pageView)
          else
            AspectRatio(
              aspectRatio: widget.crossAxisCount / widget.rowCount,
              child: pageView,
            ),
          if (_pageCount > 1)
            Padding(
              padding: widget.indicatorMargin,
              child: NPageIndicator(
                currentPage: _currentPage,
                itemCount: _pageCount,
                itemSize: widget.indicatorItemSize,
                normalColor: widget.indicatorNormalColor,
                selectedColor: widget.indicatorSelectedColor,
                margin: EdgeInsets.zero,
                hidesForSinglePage: true,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPage(BuildContext context, int pageIndex) {
    final start = pageIndex * widget.pageSize;
    final end = math.min(start + widget.pageSize, widget.items.length);
    final pageItems = widget.items.sublist(start, end);

    // 左右各 spacing/2：相邻两页内容间距 = spacing，与 Wrap 子项间距一致
    final pageInset = widget.spacing / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = NWrapPageView.itemWidthOf(
          pageWidth: constraints.maxWidth,
          crossAxisCount: widget.crossAxisCount,
          spacing: widget.spacing,
        );
        final itemHeight = NWrapPageView.itemHeightOf(
          pageHeight: constraints.maxHeight,
          rowCount: widget.rowCount,
          runSpacing: widget.runSpacing,
        );
        final itemSize = Size(
          itemWidth > 0 ? itemWidth : 0,
          itemHeight > 0 ? itemHeight : 0,
        );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: pageInset),
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: widget.spacing,
              runSpacing: widget.runSpacing,
              children: List.generate(pageItems.length, (i) {
                final index = start + i;
                return SizedBox(
                  width: itemSize.width,
                  height: itemSize.height,
                  child: widget.itemBuilder(context, index),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
