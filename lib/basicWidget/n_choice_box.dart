//
//  NChoiceBox.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/20 09:54.
//  Copyright © 2024/7/20 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/color_util.dart';

///选择盒子
class NChoiceBox<T> extends StatefulWidget {
  const NChoiceBox({
    super.key,
    required this.items,
    required this.onChanged,
    this.isSingle = false,
    this.itemMargin = const EdgeInsets.symmetric(vertical: 4),
    this.itemColor = const Color(0xffF3F3F3),
    this.itemRadius = 8,
    this.itemSelectedColor = Colors.blue,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.wrapSpacing = 16,
    this.wrapRunSpacing = 12,
    this.wrapAlignment = WrapAlignment.start,
    this.itemBuilder,
    this.header,
    this.footer,
  });

  /// 是否单选
  final bool isSingle;

  final List<ChoiceBoxModel<T>> items;

  final ValueChanged<List<ChoiceBoxModel<T>>> onChanged;

  final CrossAxisAlignment crossAxisAlignment;

  final double wrapSpacing;

  final double wrapRunSpacing;

  final WrapAlignment wrapAlignment;

  final EdgeInsets itemMargin;

  /// item 圆角
  final double itemRadius;

  /// 元素背景色
  final Color itemColor;

  /// 选中元素背景色
  final Color itemSelectedColor;

  /// 子项样式自定义
  final Widget? Function(T e, bool isSelected)? itemBuilder;

  final Widget? header;
  final Widget? footer;

  @override
  _NChoiceBoxState<T> createState() => _NChoiceBoxState<T>();
}

class _NChoiceBoxState<T> extends State<NChoiceBox<T>> {
  /// 选中的 items
  List<ChoiceBoxModel<T>> get selectedItems =>
      widget.items.where((e) => e.isSelected).toList();

  List<String> get selectedItemNames =>
      selectedItems.map((e) => e.title).toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: [
        widget.header ?? SizedBox(),
        Wrap(
          spacing: widget.wrapSpacing,
          runSpacing: widget.wrapRunSpacing,
          alignment: widget.wrapAlignment,
          children: widget.items
              .map(
                (e) => buildItem(e),
              )
              .toList(),
        ),
        widget.footer ?? SizedBox(),
      ],
    );
  }

  Widget buildItem(ChoiceBoxModel<T> e) {
    if (widget.itemBuilder != null) {
      return InkWell(
        onTap: () {
          onSelect(e: e);
        },
        child: widget.itemBuilder?.call(e.data!, e.isSelected),
      );
    }

    if (e.title.isEmpty) {
      return SizedBox();
    }

    final textColor = e.isSelected ? widget.itemSelectedColor : fontColor;

    final bgColor = e.isSelected
        ? widget.itemSelectedColor.withOpacity(0.08)
        : widget.itemColor;

    final borderColor =
        e.isSelected ? widget.itemSelectedColor : Colors.transparent;

    return GestureDetector(
      onTap: () {
        onSelect(e: e);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Text(
          e.title,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  void onSelect({required ChoiceBoxModel<T> e}) {
    for (final element in widget.items) {
      if (element.id == e.id) {
        element.isSelected = !element.isSelected;
      } else {
        if (widget.isSingle) {
          element.isSelected = false;
        }
      }
    }
    setState(() {});
    widget.onChanged(selectedItems);
  }
}

/// ChoiceBox组件匹配模型
class ChoiceBoxModel<T> {
  ChoiceBoxModel({
    required this.title,
    required this.id,
    this.isSelected = false,
    required this.data,
  });

  String id;

  String title;

  bool isSelected;

  T data;
}
