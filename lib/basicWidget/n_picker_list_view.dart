//
//  NBottomSelectListView.dart
//  yl_health_app
//
//  Created by shang on 2024/3/16 10:40.
//  Copyright © 2024/3/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_picker_tool_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield_search.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

// content = NPickerListView(
//   title: 'NPickerListView',
//   items: selectFeedbackTemplateList,
//   filterCb: (e, value) => (e['formName'] ?? '').contains(value),
//   itemBuilder: (BuildContext context, idx, list) {
//     final item = list[idx];
//
//     return ListTile(
//       title: Text(item['formName'] ?? ''),
//       onTap: () {
//         Navigator.of(context).pop(idx);
//         editRemind(
//           configItem: config,
//           modalId: modalId,
//           typeVal: 'feedbackTemp',
//           val: item,
//           remindType: remindType,
//           idx: index,
//           setState: setState,
//         );
//       },);
//   },
// );

/// 底部弹窗内容带搜索过滤
class NPickerListView<E> extends StatefulWidget {
  const NPickerListView({
    super.key,
    required this.title,
    this.onCancel,
    this.onConfirm,
    required this.items,
    required this.itemBuilder,
    this.filterCb,
    this.toolbar,
    this.empty,
  });

  /// 中间标题
  final String title;

  final Widget? toolbar;

  final Widget? empty;

  /// 取消回调
  final VoidCallback? onCancel;

  /// 取消回调
  final VoidCallback? onConfirm;

  /// 数据源
  final List<E> items;

  /// 子相
  final Widget? Function(BuildContext context, int index, List<E> items) itemBuilder;

  /// 搜索过滤
  final bool Function(E element, String search)? filterCb;

  @override
  NPickerListViewState<E> createState() => NPickerListViewState<E>();
}

class NPickerListViewState<E> extends State<NPickerListView<E>> {
  final scrollController = ScrollController();
  final searchVN = ValueNotifier("");

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
            confirmTitle: "",
          ),
        if (widget.toolbar == null) const Divider(height: 0.5),
        widget.toolbar ?? SizedBox(),
        if (widget.filterCb != null)
          Container(
            padding: const EdgeInsets.all(16),
            child: NSearchTextField(
              placeholder: '请输入',
              backgroundColor: Color(0xffEDEDED),
              onChanged: (String value) {
                searchVN.value = value;
                DLog.d("onChanged: $value, ${searchVN.value}, ");
              },
            ),
          ),
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: searchVN,
              builder: (context, value, child) {
                final list = value.isEmpty
                    ? widget.items
                    : widget.items
                        .where((e) => widget.filterCb == null ? e != null : widget.filterCb!(e, value))
                        .toList();

                if (list.isEmpty) {
                  return widget.empty ?? NPlaceholder();
                }

                return Scrollbar(
                  controller: scrollController,
                  child: ListView.builder(
                    controller: scrollController,
                    itemBuilder: (context, idx) {
                      return widget.itemBuilder(context, idx, list);
                    },
                    itemCount: list.length,
                  ),
                );
              }),
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
