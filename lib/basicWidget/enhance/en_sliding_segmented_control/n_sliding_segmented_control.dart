//
//  NSlidingSegmentedControl.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/21 23:13.
//  Copyright © 2024/3/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_sliding_segmented_control/en_sliding_segmented_control.dart';
import 'package:flutter_templet_project/extension/extensions.dart';

/// 滑动分段组件(ENCupertinoSlidingSegmentedControl)封装
class NSlidingSegmentedControl<T> extends StatefulWidget {
  const NSlidingSegmentedControl({
    super.key,
    required this.items,
    this.itemBuilder,
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
  final List<T> items;

  /// 数据子项
  final Widget Function(T e, bool isSelecetd)? itemBuilder;

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
  State<NSlidingSegmentedControl<T>> createState() => _NSlidingSegmentedControlState<T>();
}

class _NSlidingSegmentedControlState<T> extends State<NSlidingSegmentedControl<T>> {
  late var current = widget.items[widget.selectedIndex] as T?;

  @override
  void didUpdateWidget(covariant NSlidingSegmentedControl<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items ||
        oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.textColor != widget.textColor ||
        oldWidget.thumbTextColor != widget.thumbTextColor ||
        oldWidget.backgroundColor != widget.backgroundColor ||
        oldWidget.thumbColor != widget.thumbColor ||
        oldWidget.radius != widget.radius ||
        oldWidget.padding != widget.padding ||
        oldWidget.onChanged != widget.onChanged) {
      current = widget.items[widget.selectedIndex];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildSegmentedControl(
      items: widget.items,
      itemBuilder: widget.itemBuilder,
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
    required List<T> items,
    required Widget Function(T e, bool isSelecetd)? itemBuilder,
    Color? textColor,
    Color? thumbTextColor,
    Color? backgroundColor,
    Color? thumbColor,
    Radius? radius,
    EdgeInsets? padding,
    required ValueChanged<int> onChanged,
  }) {
    return ENCupertinoSlidingSegmentedControl<T>(
      groupValue: current,
      // children: children,
      children: Map<T, Widget>.fromIterable(
        items,
        key: (v) => v,
        value: (val) {
          final e = val;

          final isSelecetd = current == e;

          final color = isSelecetd ? (thumbTextColor ?? Colors.white) : (textColor ?? Color(0xff737373));

          return itemBuilder?.call(val, isSelecetd) ??
              Container(
                height: 32,
                padding: padding,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // border: Border.all(color: Colors.blue),
                  // borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Text(
                  e.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
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

/// 带图标默认实现
class NSlidingSegmentedControlIconAndTitlel extends NSlidingSegmentedControl<({String title, String icon})> {
  NSlidingSegmentedControlIconAndTitlel({
    super.key,
    required super.items,
    required super.onChanged,
    super.selectedIndex,
    super.textColor,
    required Color thumbTextColor,
    EdgeInsets? padding,
    super.backgroundColor,
    super.thumbColor,
    super.radius,
  }) : super(
          itemBuilder: (({String icon, String title}) e, bool isSelecetd) {
            final color = isSelecetd ? Colors.white : thumbTextColor;
            final icon = isSelecetd ? e.icon : e.icon;

            return Container(
              height: 32,
              padding: padding,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                // border: Border.all(color: Colors.blue),
                // borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Image(
                        image: icon.toAssetImage(),
                        width: 12,
                        height: 14,
                        color: color,
                      ),
                    ),
                  if (e.title.isNotEmpty)
                    Flexible(
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
        );
}
