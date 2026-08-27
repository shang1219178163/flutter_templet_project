import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/image/n_network_image.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 图文导航
class NCollectionNavWidget extends StatefulWidget {
  NCollectionNavWidget({
    super.key,
    required this.items,
    required this.onItem,
    this.scrollType = PageViewScrollType.full,
    this.pageRowNum = 2,
    this.pageColumnNum = 5,
    this.iconSize = 44,
    this.textHeight = 16,
    this.textGap = 0,
    this.columnSpacing = 16,
    this.rowSpacing = 8,
    this.autoAdjustHeight = true,
    this.indicatorItemHeight = 2,
    this.indicatorItemWidth = 12,
    this.indicatorGap = 8,
    this.boxShadows,
    this.isDebug = false,
  });

  /// 当前页面数据
  final List<AttrNavItem> items;

  final void Function(AttrNavItem e) onItem;

  /// 滚动方式
  final PageViewScrollType scrollType;

  ///金刚区每页行数
  final int pageRowNum;

  ///金刚区每页列数
  final int pageColumnNum;

  /// 图标默认高度
  final double iconSize;

  /// 子项标题高度
  final double textHeight;

  /// 文字间距
  final double textGap;

  /// 垂直间距
  final double columnSpacing;

  /// 水平间距
  final double rowSpacing;

  /// 是否自适应高度
  final bool autoAdjustHeight;

  /// 指示器高度
  final double indicatorItemHeight;

  /// 指示器子项宽度
  final double indicatorItemWidth;

  /// 指示器与最后一样的标题间距
  final double indicatorGap;

  /// 阴影
  final List<BoxShadow>? boxShadows;

  /// 提示模式会展示颜色
  final bool isDebug;

  @override
  _NCollectionNavWidgetState createState() => _NCollectionNavWidgetState();
}

class _NCollectionNavWidgetState extends State<NCollectionNavWidget> {
  late final _controller = PageController();
  final _scrollOffset = ValueNotifier(0.0);

  List<AttrNavItem> get _items => widget.items;

  double get _itemHeight => widget.iconSize + widget.textGap + widget.textHeight;

  int get _pageCapacity => widget.pageRowNum * widget.pageColumnNum;

  bool get _pageSnap => widget.scrollType == PageViewScrollType.full;

  int get _visibleCount {
    if (widget.scrollType == PageViewScrollType.none) {
      return min(_items.length, _pageCapacity);
    }
    return _items.length;
  }

  int get _pageCount {
    if (widget.scrollType == PageViewScrollType.none) {
      return 1;
    }
    if (_visibleCount == 0 || _pageCapacity == 0) {
      return 0;
    }
    return (_visibleCount / _pageCapacity).ceil();
  }

  int get _layoutRowCount {
    if (_pageCapacity >= _items.length) {
      final n = _visibleCount;
      if (widget.pageColumnNum == 0) {
        return widget.pageRowNum;
      }
      return (n + widget.pageColumnNum - 1) ~/ widget.pageColumnNum;
    }
    return widget.pageRowNum;
  }

  double get _totalHeight {
    final rows = max(_layoutRowCount, 0);
    final gapCount = max(rows - 1, 0);
    return _itemHeight * rows + widget.columnSpacing * gapCount + widget.indicatorGap + widget.indicatorItemHeight;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _scrollOffset.value = _controller.offset;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final edge = widget.rowSpacing * 0.5;
      var itemWidth =
          (constraints.maxWidth - widget.rowSpacing * (widget.pageColumnNum - 1) - edge * 2) / widget.pageColumnNum;
      if (!itemWidth.isFinite || itemWidth < 0) {
        itemWidth = 0;
      }
      return SizedBox(
        height: widget.autoAdjustHeight ? _totalHeight : null,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              color: widget.isDebug ? ColorExt.random : null,
              width: constraints.maxWidth,
              child: PageView.builder(
                key: const PageStorageKey('CollectionNavWidget'),
                itemCount: _pageCount,
                controller: _controller,
                pageSnapping: _pageSnap,
                physics: _pageCount == 1 ? const NeverScrollableScrollPhysics() : null,
                itemBuilder: (context, pageIndex) {
                  return Padding(
                    padding: EdgeInsets.only(left: edge),
                    child: Wrap(
                      spacing: widget.rowSpacing,
                      runSpacing: widget.columnSpacing,
                      children: _pageItems(pageIndex, itemWidth),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: widget.indicatorItemHeight,
                child: Center(child: _indicator(constraints.maxWidth)),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _pageItems(int pageIndex, double width) {
    final start = _pageCapacity * pageIndex;
    final end = min(start + _pageCapacity, _visibleCount);
    return [
      for (var i = start; i < end; i++) SizedBox(width: width, child: _item(i, width)),
    ];
  }

  Widget _item(int index, double imgWidth) {
    final model = _items[index];
    final iconSize = min(widget.iconSize, imgWidth);
    return InkWell(
      onTap: () => widget.onItem(model),
      child: Container(
        color: widget.isDebug ? ColorExt.random : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NNetworkImage(
              url: model.icon ?? '',
              width: iconSize,
              height: iconSize,
              radius: 10,
            ),
            Padding(
              padding: EdgeInsets.only(top: widget.textGap),
              child: SizedBox(
                height: widget.textHeight,
                child: Center(child: _title(model)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(AttrNavItem model) {
    var name = model.name ?? '';
    if (name.isEmpty) {
      return const SizedBox();
    }
    if (name.length > 5) {
      name = name.substring(0, 5);
    }
    Widget text = Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.black, fontSize: 13),
    );
    if (widget.isDebug) {
      text = ColoredBox(color: ColorExt.random, child: text);
    }
    return FittedBox(fit: BoxFit.scaleDown, child: text);
  }

  Widget _indicator(double width) {
    if (_pageCount < 2) {
      return const SizedBox();
    }
    final itemW = widget.indicatorItemWidth;
    final itemH = widget.indicatorItemHeight;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(1),
          child: Container(
            height: itemH,
            width: itemW * _pageCount,
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ),
        ValueListenableBuilder<double>(
          valueListenable: _scrollOffset,
          builder: (context, value, child) {
            final offset = width == 0 ? 0.0 : (value / width) * itemW;
            return Positioned(
              left: offset,
              child: Container(
                height: itemH,
                width: itemW,
                decoration: BoxDecoration(
                  color: const Color(0xFFBE965A),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class AttrNavItem {
  // 唯一标识
  int? id;
  // 图片
  String? icon;
  // 导航名称
  String? name;
  // 绑定事件
  String? url;
  // 角标类型
  int? cornerMarker;

  AttrNavItem({
    this.id,
    this.icon,
    this.name,
    this.url,
    this.cornerMarker,
  });

  static AttrNavItem? fromJson(json) {
    if (json is! Map) {
      return null;
    }
    return AttrNavItem(
      icon: json['icon'] as String?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      cornerMarker: json['cornerMarker'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "icon": icon,
      "id": id,
      "name": name,
      "url": url,
      "cornerMarker": cornerMarker,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

/// PageView 滚动方式
enum PageViewScrollType {
  /// 整屏滑动
  full,

  /// 拖拽滑动
  drag,

  /// 禁用滑动
  none;

  /// int 转枚举
  PageViewScrollType indexOf(int index, [bool isClamp = true]) {
    var i = index;
    if (isClamp) {
      i = i.clamp(0, values.length - 1).toInt();
    }
    final result = values.where((e) => e.index == i).firstOrNull ?? this;
    return result;
  }
}
