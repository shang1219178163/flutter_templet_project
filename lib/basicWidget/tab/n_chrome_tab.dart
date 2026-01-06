//
//  NChromeTabBar.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/5 17:22.
//  Copyright © 2026/1/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/tab/model/n_tabbar_data_model.dart';

/// Chrome 浏览器风格 tabbar
class NChromeTab extends StatefulWidget {
  const NChromeTab({
    super.key,
    this.controller,
    this.isScrollable = false,
    this.height = 44,
    this.itemPadding,
    this.selectedBgColor,
    this.bgColor,
    required this.items,
    required this.indexVN,
    this.onChanged,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.tabAlignment,
    this.itemBuilder,
  });

  final NChromeTabController? controller;

  final List<NTabbarDataModel> items;
  final ValueNotifier<int> indexVN;

  final ValueChanged<int>? onChanged;

  final bool isScrollable;
  final double? height;
  final EdgeInsets? itemPadding;
  final Color? bgColor;
  final Color? selectedBgColor;

  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final TabAlignment? tabAlignment;

  /// 默认无法满足时自定义
  final IndexedWidgetBuilder? itemBuilder;

  @override
  State<NChromeTab> createState() => _NChromeTabState();
}

class _NChromeTabState extends State<NChromeTab> {
  late var currIndex = widget.indexVN.value;

  late final theme = Theme.of(context);
  late final tabBarTheme = theme.tabBarTheme;

  TextStyle get textStyle =>
      widget.selectedLabelStyle ??
      tabBarTheme.labelStyle ??
      TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.red,
      );

  TextStyle get unselectedTextStyle =>
      widget.unselectedLabelStyle ??
      tabBarTheme.unselectedLabelStyle ??
      TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      );

  @override
  void dispose() {
    widget.controller?.detach(this);
    widget.indexVN.removeListener(onIndexLtr);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);
    widget.indexVN.addListener(onIndexLtr);
  }

  onIndexLtr() {
    currIndex = widget.indexVN.value;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant NChromeTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items ||
        oldWidget.indexVN != widget.indexVN ||
        oldWidget.isScrollable != widget.isScrollable ||
        oldWidget.height != widget.height ||
        oldWidget.itemPadding != widget.itemPadding ||
        oldWidget.bgColor != widget.bgColor ||
        oldWidget.selectedBgColor != widget.selectedBgColor ||
        oldWidget.selectedLabelStyle != widget.selectedLabelStyle ||
        oldWidget.unselectedLabelStyle != widget.unselectedLabelStyle ||
        oldWidget.itemBuilder != widget.itemBuilder) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = SizedBox();
    if (widget.isScrollable) {
      contentWidget = buildScroll();
    } else {
      contentWidget = buildRow();
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.bgColor,
      ),
      child: contentWidget,
    );
  }

  Widget buildScroll() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.items.map(
          (e) {
            final i = widget.items.indexOf(e);
            return buildItem(i: i);
          },
        ).toList(),
      ),
    );
  }

  Widget buildRow() {
    final alignmentMap = {
      TabAlignment.start: MainAxisAlignment.start,
      TabAlignment.center: MainAxisAlignment.center,
      TabAlignment.startOffset: MainAxisAlignment.end,
    };

    return Row(
      mainAxisAlignment: alignmentMap[widget.tabAlignment] ?? MainAxisAlignment.start,
      children: widget.items.map(
        (e) {
          final i = widget.items.indexOf(e);
          Widget child = buildItem(i: i);
          if (widget.tabAlignment == TabAlignment.fill) {
            child = Expanded(child: child);
          }
          return child;
        },
      ).toList(),
    );
  }

  Widget buildItem({required int i}) {
    final e = widget.items[i];
    final isSelected = widget.indexVN.value == i;

    final bgColor = e.bgColor ?? widget.selectedBgColor;
    final colorFilter = bgColor == null ? null : ColorFilter.mode(bgColor, BlendMode.srcIn);
    final image = isSelected
        ? DecorationImage(
            image: e.bg!,
            fit: BoxFit.fill,
            colorFilter: colorFilter,
          )
        : null;

    return GestureDetector(
      onTap: () {
        jumpTo(i);
      },
      child: widget.itemBuilder?.call(context, i) ??
          Container(
            padding: widget.itemPadding,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              image: image,
            ),
            child: Container(
              alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   color: Colors.transparent,
              //   border: Border.all(color: Colors.blue),
              // ),
              child: Text(
                e.title,
                maxLines: 1,
                style: isSelected ? (e.style ?? textStyle) : unselectedTextStyle,
              ),
            ),
          ),
    );
  }

  void jumpTo(int i) {
    if (currIndex == i) {
      debugPrint("$runtimeType $i 重复点击");
      return;
    }
    setState(() {});
    currIndex = i;
    widget.indexVN.value = i;
    widget.onChanged?.call(widget.indexVN.value);
  }
}

class NChromeTabController<T extends _NChromeTabState> {
  T? _anchor;

  void attach(T anchor) {
    _anchor = anchor;
  }

  void detach(T anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  void jumpTo(int i) {
    assert(_anchor != null);
    _anchor!.jumpTo(i);
  }
}
