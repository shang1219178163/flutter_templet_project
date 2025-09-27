//
//  NPickerChoiceView.dart
//  yl_health_app
//
//  Created by shang on 2024/3/16 10:40.
//  Copyright © 2024/3/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_picker_tool_bar.dart';

/// 底部弹窗内容带搜索过滤
class NPickerChoiceView<E> extends StatefulWidget {
  const NPickerChoiceView({
    super.key,
    required this.title,
    this.onCancel,
    this.onConfirm,
    required this.items,
    required this.itemBuilder,
    this.filterCb,
    this.toolbar,
    this.divider,
    this.empty,
  });

  /// 中间标题
  final String title;

  final Widget? toolbar;

  final Widget? divider;

  final Widget? empty;

  /// 取消回调
  final VoidCallback? onCancel;

  /// 取消回调
  final VoidCallback? onConfirm;

  /// 数据源
  final List<E> items;

  /// 子相
  final Widget? Function(BuildContext context, int index) itemBuilder;

  /// 搜索过滤
  final bool Function(E element, String search)? filterCb;

  @override
  NPickerChoiceViewState<E> createState() => NPickerChoiceViewState<E>();
}

class NPickerChoiceViewState<E> extends State<NPickerChoiceView<E>> {
  final scrollController = ScrollController();
  final searchVN = ValueNotifier("");

  @override
  void didUpdateWidget(covariant NPickerChoiceView<E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title || oldWidget.items != widget.items) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.toolbar ??
            NPickerToolBar(
              title: widget.title,
              onCancel: widget.onCancel ??
                  () {
                    Navigator.of(context).pop();
                  },
              onConfirm: widget.onConfirm ??
                  () {
                    Navigator.of(context).pop();
                  },
            ),
        widget.divider ?? Divider(height: 0.5),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, idx) {
                return widget.itemBuilder(context, idx);
              },
              itemCount: widget.items.length,
            ),
          ),
        ),
      ],
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: child,
    );
  }
}
