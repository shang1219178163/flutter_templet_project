//
//  NChoiceBoxOne.dart
//  flutter_templet_project
//
//  Created by shang on 2023/11/10 14:26.
//  Copyright © 2023/11/10 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_indicator_point.dart';

typedef ChoiceSelectedType<T> = void Function(T e, bool selected);


/// 带圆形指示器的单选组件
/// T 重写相等运算符
class NChoiceBoxOne<T> extends StatefulWidget {

  NChoiceBoxOne({
    Key? key,
    required this.items,
    required this.seletedItem,
    this.numPerRow = 2,
    this.spacing = 8,
    this.runSpacing = 0,
    this.contentPadding,
    this.onChanged,
    required this.canChanged,
    this.primaryColor = Colors.blue,
    this.avatar,
    this.avatarSeleted,
    this.style,
    this.styleSeleted,
  }) : super(key: key);

  final List<T> items;
  T? seletedItem;

  /// 每列数
  int numPerRow;

  Color primaryColor;

  double spacing;
  double runSpacing;
  EdgeInsets? contentPadding;
  // ValueChanged<T?> onChanged;// 会报错,后续观察
  Function(dynamic value)? onChanged;
  /// 向外部暴漏 onSelect 方法, 可以二次设置选择项
  bool Function(dynamic value, ChoiceSelectedType<T>)? canChanged;

  Widget? avatar;
  Widget? avatarSeleted;

  TextStyle? style;
  TextStyle? styleSeleted;

  @override
  State<NChoiceBoxOne> createState() => _NChoiceBoxOneState<T>();
}

class _NChoiceBoxOneState<T> extends State<NChoiceBoxOne> {


  ///每页行数
  int get rowNum => widget.items.length < widget.numPerRow ? 1 : 2;
  ///每页数
  int get numPerPage => rowNum * widget.numPerRow;

  T? _seletedValue;

  @override
  void initState() {
    // TODO: implement initState
    _seletedValue = widget.seletedItem;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = constraints.maxWidth/widget.numPerRow;

      return Wrap(
        // alignment: WrapAlignment.start,
        // crossAxisAlignment: WrapCrossAlignment.start,
        runSpacing: widget.runSpacing,
        children: widget.items.map((e) {

          final selected = _seletedValue == e;

          final avatar = selected ? (widget.avatarSeleted ?? NIndicatorPointNew(
            size: 14,
            innerSize: 8,
            color: widget.primaryColor,
            innerColor: widget.primaryColor,
          )) : (widget.avatar ?? NIndicatorPointNew(
            size: 14,
            innerSize: 8,
            color: Color(0xffBCBFC2),
            innerColor: Colors.transparent,
          ));

          final defaultTextStyle = TextStyle(
            color: selected ? widget.primaryColor : Colors.black87,
          );

          return Container(
            width: itemWidth - 1,
            alignment: Alignment.centerLeft,
            child: Theme(
              // data: ThemeData(canvasColor: widget.itemColor),
              data: ThemeData(
                canvasColor: Colors.transparent,
                // canvasColor: Colors.green,
                highlightColor: Colors.white,
                hoverColor: Colors.white,
                focusColor: Colors.white,
              ),
              child: ChoiceChip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Colors.transparent,
                selectedColor: Colors.transparent,
                pressElevation: 0,
                showCheckmark: false,
                side: BorderSide(color: Colors.transparent),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: avatar,
                    ),
                    Flexible(
                        child: Text(e.item1,
                          style: selected ? widget.styleSeleted ?? defaultTextStyle
                              : widget.style ?? defaultTextStyle,
                        )
                    ),
                  ],
                ),
                // padding: EdgeInsets.only(left: 8, right: 8),
                padding: EdgeInsets.zero,
                selected: selected,
                onSelected: (bool selected) {
                  debugPrint("e: $selected,  $e");
                  final canChange = widget.canChanged?.call(e, onSelect as ChoiceSelectedType) ?? true;
                  if (!canChange) {
                    return;
                  }
                  onSelect(e, selected);
                },
              ),
            ),
          );
        },).toList(),
      );
    });
  }

  onSelect(T e, bool selected) {
    if (selected) {
      _seletedValue = e;
    }
    widget.onChanged?.call(_seletedValue);
    setState(() {});
  }
}