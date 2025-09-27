//
//  NBottomSelectListView.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/3/16 10:40.
//  Copyright © 2024/3/16 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_picker_tool_bar.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// 底部列表选择封装
class NCupertinoPickerListView<E> extends StatefulWidget {
  const NCupertinoPickerListView({
    super.key,
    required this.title,
    this.toolbar,
    this.onCancel,
    this.cancelArrow = false,
    this.onConfirm,
    required this.items,
    this.cbName,
    this.itemBuilder,
    this.initialItem,
    required this.onSelectedItemChanged,
    this.empty,
  });

  /// 中间标题
  final String title;

  /// 顶部菜单
  final Widget? toolbar;

  /// 空视图
  final Widget? empty;

  /// 取消显示箭头
  final bool cancelArrow;

  /// 取消回调
  final VoidCallback? onCancel;

  /// 确定回调
  final VoidCallback? onConfirm;

  /// 数据源
  final List<E> items;

  final String Function(E e)? cbName;

  /// 子相
  final Widget? Function(BuildContext context, int index)? itemBuilder;

  /// 默认索引
  final int? initialItem;

  final ValueChanged<int>? onSelectedItemChanged;

  @override
  NNCupertinoPickerListViewState<E> createState() => NNCupertinoPickerListViewState<E>();
}

class NNCupertinoPickerListViewState<E> extends State<NCupertinoPickerListView<E>> {
  final scrollController = ScrollController();

  late var selectedIndex = widget.initialItem ?? 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NCupertinoPickerListView<E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialItem != widget.initialItem ||
        oldWidget.onSelectedItemChanged != widget.onSelectedItemChanged ||
        oldWidget.cancelArrow != widget.cancelArrow) {
      selectedIndex = widget.initialItem ?? 0;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.toolbar == null)
          NPickerToolBar(
            title: widget.title,
            onCancel: widget.onCancel ??
                () {
                  Navigator.of(context).pop();
                },
            onConfirm: widget.onConfirm ??
                () {
                  widget.onSelectedItemChanged?.call(selectedIndex);
                  Navigator.of(context).pop();
                },
            leading: !widget.cancelArrow
                ? null
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Image(
                      image: "assets/images/icon_arrow_left.png".toAssetImage(),
                      width: 16,
                      height: 16,
                      // fit: BoxFit.fill,
                      color: Colors.grey,
                    ),
                  ),
          ),
        if (widget.toolbar == null) const Divider(height: 0.5, color: lineColor),
        widget.toolbar ?? const SizedBox(),
        Expanded(
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            // diameterRatio: 1.25,
            selectionOverlay: null,
            itemExtent: 60,
            scrollController: FixedExtentScrollController(initialItem: selectedIndex),
            onSelectedItemChanged: (index) {
              selectedIndex = index;
            },
            children: widget.items.map((e) {
              final index = widget.items.indexOf(e);
              return widget.itemBuilder?.call(context, index) ??
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          widget.cbName?.call(e) ?? "-",
                          style: const TextStyle(
                            fontSize: 18,
                            color: fontColor,
                          ),
                        ),
                      ),
                      const Divider(height: 0.5, color: lineColor),
                    ],
                  );
            }).toList(),
          ),
        ),
      ],
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: child,
    );
  }
}
