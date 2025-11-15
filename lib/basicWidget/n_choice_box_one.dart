//
//  NChoiceBoxOne.dart
//  flutter_templet_project
//
//  Created by shang on 2023/11/10 14:26.
//  Copyright © 2023/11/10 shang. All rights reserved.
//
// Chip 默认高度 _kChipHeight _RenderChip

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_indicator_point.dart';

typedef ChoiceSelectedType<T> = void Function(T e, bool selected);

/// 带圆形指示器的单选组件
/// T 重写相等运算符
class NChoiceBoxOne<T> extends StatefulWidget {
  const NChoiceBoxOne({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.itemNameCb,
    this.numPerRow = 2,
    this.spacing = 8,
    this.runSpacing = 0,
    this.contentPadding,
    this.onChanged,
    required this.canChanged,
    this.primaryColor = Colors.blue,
    this.itemPadding,
    this.avatar,
    this.avatarSelected,
    this.style,
    this.styleSelected,
    this.backgroundColor = Colors.transparent,
    this.selectedColor = Colors.transparent,
    this.disabledColor = Colors.white,
    this.disabledAvatarColor = const Color(0xffB3B3B3),
    this.enable = true,
  });

  final List<T> items;
  final ValueNotifier<T?> selectedItem;

  /// 类型转字符串
  final String Function(T e) itemNameCb;

  /// 每列数,为 0 时自由排布
  final int numPerRow;

  final Color primaryColor;
  final EdgeInsets? itemPadding;

  final double spacing;
  final double runSpacing;
  final EdgeInsets? contentPadding;
  final ValueChanged<T>? onChanged; // 会报错,后续观察

  /// 向外部暴漏 onSelect 方法, 可以二次设置选择项
  final bool Function(T value, ChoiceSelectedType<T>)? canChanged;

  final Widget? avatar;
  final Widget? avatarSelected;

  final TextStyle? style;
  final TextStyle? styleSelected;

  /// 背景颜色
  final Color backgroundColor;
  final Color selectedColor;

  final Color disabledColor;
  final Color disabledAvatarColor;

  /// 是否禁用
  final bool enable;

  @override
  State<NChoiceBoxOne<T>> createState() => _NChoiceBoxOneState<T>();
}

class _NChoiceBoxOneState<T> extends State<NChoiceBoxOne<T>> {
  ///每页行数
  int get rowNum => widget.items.length < widget.numPerRow ? 1 : 2;

  ///每页数
  int get numPerPage => rowNum * widget.numPerRow;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.numPerRow <= 0) {
      return Wrap(
        // alignment: WrapAlignment.start,
        // crossAxisAlignment: WrapCrossAlignment.start,
        spacing: widget.spacing,
        runSpacing: widget.runSpacing,
        children: widget.items.map(
          (e) {
            return buildItem(e: e);
          },
        ).toList(),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = constraints.maxWidth / widget.numPerRow;

      return Wrap(
        // alignment: WrapAlignment.start,
        // crossAxisAlignment: WrapCrossAlignment.start,
        runSpacing: widget.runSpacing,
        children: widget.items.map(
          (e) {
            return Container(
              width: itemWidth - 1,
              alignment: Alignment.centerLeft,
              child: buildItem(e: e),
            );
          },
        ).toList(),
      );
    });
  }

  /// 子项
  Widget buildItem({required T e}) {
    final isSelected = widget.selectedItem.value == e;

    final avatarColor = !widget.enable ? widget.disabledAvatarColor : widget.primaryColor;

    final avatar = isSelected
        ? (widget.avatarSelected ??
            NIndicatorPointNew(
              size: 14,
              innerSize: 8,
              color: avatarColor,
              innerColor: avatarColor,
            ))
        : (widget.avatar ??
            NIndicatorPointNew(
              size: 14,
              innerSize: 8,
              color: Color(0xffBCBFC2),
              innerColor: Colors.transparent,
            ));

    var itemTitle = widget.itemNameCb(e);

    var textStyle = isSelected
        ? widget.styleSelected ??
            TextStyle(
              color: widget.primaryColor,
            )
        : widget.style ??
            TextStyle(
              color: Colors.black87,
            );
    if (!widget.enable) {
      textStyle = textStyle.copyWith(color: avatarColor);
    }

    return GestureDetector(
      onTap: () {
        onTap(e: e, isSelected: isSelected);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: widget.itemPadding ??
            const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 10,
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          // border: Border.all(color: Colors.blue),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: avatar,
            ),
            Flexible(
              child: Text(
                itemTitle,
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 子项选择
  void onTap({required T e, required bool isSelected}) {
    if (!widget.enable) {
      DLog.d("❌$runtimeType 组件已禁用!");
      return;
    }

    var selected = !isSelected;
    // debugPrint("e: $selected,  $e");
    final canChange = widget.canChanged?.call(e, onSelect as ChoiceSelectedType) ?? true;
    if (!canChange) {
      return;
    }
    onSelect(e, selected);
  }

  onSelect(T e, bool selected) {
    if (widget.selectedItem.value == e) {
      return;
    }
    widget.selectedItem.value = e;
    widget.onChanged?.call(widget.selectedItem.value as T);
    setState(() {});
  }
}
