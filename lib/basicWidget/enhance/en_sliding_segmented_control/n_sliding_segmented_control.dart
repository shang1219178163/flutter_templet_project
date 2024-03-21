//
//  NSlidingSegmentedControl.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/21 23:13.
//  Copyright © 2024/3/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_sliding_segmented_control/en_sliding_segmented_control.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';


/// 滑动分段组件(ENCupertinoSlidingSegmentedControl)封装
class NSlidingSegmentedControl extends StatefulWidget {

  const NSlidingSegmentedControl({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    required this.onChanged,
    this.textColor,
    this.thumbTextColor,
    this.backgroundColor,
    this.thumbColor,
    this.radius,
    this.padding,
  });

  /// 数据源
  final List<({String title, String icon,})> items;
  /// 初始化位置
  final int selectedIndex;
  /// 点击回调
  final ValueChanged<int> onChanged;
  /// 未选中的文字颜色
  final Color? textColor;
  /// 选中的文字颜色
  final Color? thumbTextColor;
  /// 背景颜色
  final Color? backgroundColor;
  /// 选中的高亮颜色
  final Color? thumbColor;
  /// 圆角
  final Radius? radius;
  /// 滑块相对背景视图的内边距
  final EdgeInsets? padding;

  @override
  State<NSlidingSegmentedControl> createState() => _NSlidingSegmentedControlState();
}

class _NSlidingSegmentedControlState extends State<NSlidingSegmentedControl> {

  late var current = widget.items[widget.selectedIndex];

  @override
  void didUpdateWidget(covariant NSlidingSegmentedControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (
      oldWidget.items != widget.items ||
      oldWidget.selectedIndex != widget.selectedIndex ||
      oldWidget.textColor != widget.textColor ||
      oldWidget.thumbTextColor != widget.thumbTextColor ||
      oldWidget.backgroundColor != widget.backgroundColor ||
      oldWidget.thumbColor != widget.thumbColor ||
      oldWidget.radius != widget.radius ||
      oldWidget.padding != widget.padding ||
      oldWidget.onChanged != widget.onChanged
    ) {
      current = widget.items[widget.selectedIndex];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildSegmentedControl(
      items: widget.items,
      textColor: widget.textColor,
      thumbTextColor: widget.thumbTextColor,
      backgroundColor: widget.backgroundColor,
      thumbColor: widget.thumbColor,
      radius: widget.radius,
      padding: widget.padding,
      onChanged: widget.onChanged,
    );
  }


  Widget buildSegmentedControl({
    required List<({String title, String icon,})> items,
    Color? textColor,
    Color? thumbTextColor,
    Color? backgroundColor,
    Color? thumbColor,
    Radius? radius,
    EdgeInsets? padding,
    required ValueChanged<int> onChanged,
  }) {
    return ENCupertinoSlidingSegmentedControl<({String title, String icon,})>(
      groupValue: current,
      // children: children,
      children: Map<({String title, String icon,}), Widget>.fromIterable(
        items,
        key: (v) => v,
        value: (val) {
          final e = val as ({String title, String icon,});

          final isSelecetd = current == val;

          final color = isSelecetd ? (thumbTextColor ?? Colors.white) : (textColor ?? Color(0xff737373));
          final icon = isSelecetd ? e.icon : e.icon;

          return Container(
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              // border: Border.all(color: Colors.blue),
              // borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(icon.isNotEmpty)Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Image(
                    image: icon.toAssetImage(),
                    width: 12,
                    height: 14,
                    color: color,
                  ),
                ),
                if(e.title.isNotEmpty)Flexible(
                  child: Text(
                    e.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onValueChanged: (val) {
        if (val == null) {
          return;
        }
        current = val;
        onChanged(items.indexOf(val));
        setState(() {});
      },
      backgroundColor: backgroundColor ?? Color(0xfff3F3F3),
      thumbColor: thumbColor ?? context.primaryColor,
      radius: radius ?? Radius.circular(16),
      padding: padding ?? EdgeInsets.all(2),
    );
  }

}