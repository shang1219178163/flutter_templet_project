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
    this.height,
    this.radius,
    this.itemPadding,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.itemBuilder,
  });

  final List<NTabbarDataModel> items;
  final ValueNotifier<int> indexVN;

  final ValueChanged<int>? onChanged;

  /// default 24
  final double? height;

  /// default 4
  final double? radius;

  /// default EdgeInsets.symmetric(horizontal: 5, vertical: 2)
  final EdgeInsets? itemPadding;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  /// 默认无法满足时自定义
  final IndexedWidgetBuilder? itemBuilder;

  @override
  State<NOutlineTabbar> createState() => _NOutlineTabbarState();
}

class _NOutlineTabbarState extends State<NOutlineTabbar> {
  late var currIndex = widget.indexVN.value;

  @override
  void dispose() {
    widget.indexVN.addListener(onIndexLtr);
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
    final theme = Theme.of(context);
    final tabBarTheme = theme.tabBarTheme;

    return Container(
      height: widget.height ?? 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          final e = widget.items[i];
          final isSelected = widget.indexVN.value == i;
          final textStyle = isSelected
              ? (e.style ?? widget.selectedLabelStyle ?? tabBarTheme.labelStyle)
              : widget.unselectedLabelStyle ?? tabBarTheme.unselectedLabelStyle;

          final textColorDefault = isSelected ? Color(0xffE91025) : Color(0xff7C7C85);
          final textColor = textStyle?.color ?? textColorDefault;

          return GestureDetector(
            onTap: () {
              if (currIndex == i) {
                debugPrint("$runtimeType $i 重复点击");
                return;
              }
              setState(() {});
              currIndex = i;
              widget.indexVN.value = i;
              widget.onChanged?.call(widget.indexVN.value);
            },
            child: Container(
              padding: widget.itemPadding ?? EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: textColor, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 4.0)),
              ),
              alignment: Alignment.center,
              child: widget.itemBuilder?.call(context, i) ??
                  Text(
                    e.title,
                    style: textStyle ?? TextStyle(color: textColorDefault),
                  ),
            ),
          );
        },
        separatorBuilder: (context, i) {
          final e = widget.items[i];
          return SizedBox(width: 6);
        },
        itemCount: widget.items.length,
      ),
    );
  }
}
