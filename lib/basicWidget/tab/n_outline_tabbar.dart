//
//  NOutlineTabbar.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/5 17:25.
//  Copyright © 2026/1/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/tab/model/n_tabbar_data_model.dart';

/// 圆角边框
class NOutlineTabbar extends StatefulWidget {
  const NOutlineTabbar({
    super.key,
    required this.items,
    required this.indexVN,
    required this.onChanged,
    this.isScrollable = false,
    this.isWrap = false,
    this.height = 30,
    this.radius,
    this.itemWidth,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    this.spacing = 6,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.itemBuilder,
  });

  final List<String> items;
  final ValueNotifier<int> indexVN;

  final ValueChanged<int>? onChanged;

  final bool isScrollable;
  final bool isWrap;

  /// default 30
  final double height;

  /// default 4
  final double? radius;

  /// 子项宽度
  final double? itemWidth;

  /// default EdgeInsets.symmetric(horizontal: 5, vertical: 2)
  final EdgeInsets? itemPadding;
  final double spacing;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  /// 默认无法满足时自定义
  final IndexedWidgetBuilder? itemBuilder;

  @override
  State<NOutlineTabbar> createState() => _NOutlineTabbarState();
}

class _NOutlineTabbarState extends State<NOutlineTabbar> {
  late var currIndex = widget.indexVN.value;

  late final theme = Theme.of(context);
  late final tabBarTheme = theme.tabBarTheme;

  @override
  void dispose() {
    widget.indexVN.removeListener(onIndexLtr);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.indexVN.addListener(onIndexLtr);
  }

  onIndexLtr() {
    currIndex = widget.indexVN.value;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant NOutlineTabbar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = Container(
      height: widget.height,
      child: buildRow(),
    );
    if (widget.isScrollable) {
      contentWidget = Container(
        height: widget.height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return Container(
              width: widget.itemWidth,
              child: buildItem(i: i),
            );
          },
          separatorBuilder: (context, i) {
            final e = widget.items[i];
            return SizedBox(width: widget.spacing);
          },
          itemCount: widget.items.length,
        ),
      );
    } else if (widget.isWrap) {
      contentWidget = buildWrap();
    }
    return contentWidget;
  }

  Widget buildRow() {
    return Row(
      children: widget.items.map(
        (e) {
          final i = widget.items.indexOf(e);
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: e == widget.items.last ? 0 : widget.spacing),
              child: buildItem(i: i),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget buildWrap() {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      // final spacing = widget.spacing;
      // final rowCount = 4.0;
      // final itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount).truncateToDouble();

      return Wrap(
        spacing: widget.spacing,
        runSpacing: widget.spacing,
        // crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...widget.items.map((e) {
            final i = widget.items.indexOf(e);

            return Container(
              width: widget.itemWidth,
              height: widget.height,
              child: buildItem(i: i),
            );
          }),
        ],
      );
    });
  }

  Widget buildItem({required int i}) {
    final e = widget.items[i];
    final isSelected = widget.indexVN.value == i;
    final textStyle = isSelected
        ? (widget.selectedLabelStyle ?? tabBarTheme.labelStyle)
        : widget.unselectedLabelStyle ?? tabBarTheme.unselectedLabelStyle;

    final textColorDefault = isSelected ? Color(0xffE91025) : Color(0xff7C7C85);
    final textColor = textStyle?.color ?? textColorDefault;

    return GestureDetector(
      onTap: () {
        jumpTo(i);
      },
      child: widget.itemBuilder?.call(context, i) ??
          Container(
            padding: widget.itemPadding,
            decoration: BoxDecoration(
              border: Border.all(color: textColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 4.0)),
            ),
            alignment: Alignment.center,
            child: Text(
              e,
              style: textStyle ?? TextStyle(color: textColorDefault),
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
