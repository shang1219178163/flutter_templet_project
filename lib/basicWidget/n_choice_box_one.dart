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
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

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

  /// 每列数
  final int numPerRow;

  final Color primaryColor;

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
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = constraints.maxWidth / widget.numPerRow;

      return Wrap(
        // alignment: WrapAlignment.start,
        // crossAxisAlignment: WrapCrossAlignment.start,
        runSpacing: widget.runSpacing,
        children: widget.items.map(
          (e) {
            final isSelected = widget.selectedItem.value == e;

            final avatarColor = !widget.enable
                ? widget.disabledAvatarColor
                : widget.primaryColor;

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

            String itemTitle = widget.itemNameCb(e);

            TextStyle textStyle = isSelected
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
            return Container(
              width: itemWidth - 1,
              alignment: Alignment.centerLeft,
              child: ChipTheme(
                data: ChipTheme.of(context).copyWith(
                  backgroundColor: widget.backgroundColor ?? Colors.transparent,
                  selectedColor: widget.selectedColor ?? Colors.transparent,
                  disabledColor: widget.disabledColor,
                  elevation: 0,
                  pressElevation: 0,
                  showCheckmark: false,
                  padding: EdgeInsets.zero,
                  // labelPadding: EdgeInsets.zero,
                ),
                child: ChoiceChip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide(color: Colors.transparent),
                  label: Row(
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
                  selected: isSelected,
                  onSelected: (bool selected) {
                    // debugPrint("e: $selected,  $e");
                    if (!widget.enable) {
                      DLog.d("❌$runtimeType 组件已禁用!");
                      return;
                    }
                    final canChange = widget.canChanged
                            ?.call(e, onSelect as ChoiceSelectedType) ??
                        true;
                    if (!canChange) {
                      return;
                    }
                    onSelect(e, selected);
                  },
                ),
              ),
            );
          },
        ).toList(),
      );
    });
  }

  onSelect(T e, bool selected) {
    if (selected == false) {
      return;
    }
    if (widget.selectedItem.value == e) {
      return;
    }
    widget.selectedItem.value = e;
    widget.onChanged?.call(widget.selectedItem.value as T);
    setState(() {});
  }
}
