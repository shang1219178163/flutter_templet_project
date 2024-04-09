//
//  NChoiceExpansionOfModel.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/9 12:26.
//  Copyright © 2024/4/9 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';

/// 模型(必须包含 String id, String name, bool isSelected)的标签选择器
class NChoiceExpansionOfModel<T extends TagDetailModel> extends StatelessWidget {

  const NChoiceExpansionOfModel({
  	super.key,
    required this.title,
    this.titleStyle,
    required this.items,
    this.isSingle = false,
    required this.onChanged,
    this.onSingleChanged,
    this.itemBuilder,
    this.headerBuilder,
    this.footerBuilder,
  });

  /// 标题
  final String title;
  /// 标题字体样式
  final TextStyle? titleStyle;
  /// 组数据
  final List<T> items;
  /// 单选/多选
  final bool isSingle;
  /// 改变回掉
  final ValueChanged<List<T>> onChanged;
  /// 单选回调
  final ValueChanged<T?>? onSingleChanged;
  /// 子项样式自定义
  final Widget Function(T e)? itemBuilder;
  /// 头部项目自定义
  final Widget Function(VoidCallback onToggle)? headerBuilder;
  /// 尾部自定义
  final Widget Function(VoidCallback onToggle)? footerBuilder;

  @override
  Widget build(BuildContext context) {
    return NChoiceExpansion<T>(
      title: title,
      items: items,
      titleCb: (e) => e.name ?? "",
      selectedCb: (e) => e.isSelected == true,
      onSelected: (e) {
        // ddlog(e.name);
        for (final element in items) {
          if (element.id == e.id) {
            element.isSelected = !element.isSelected;
          } else {
            if (isSingle) {
              element.isSelected = false;
            }
          }
        }
        final selecetdItems = items.where((e) => e.isSelected).toList();
        // ddlog(selecetdItems.map((e) => e.name ?? ""));
        onChanged(selecetdItems);

        final first = selecetdItems.isEmpty ? null : selecetdItems.first;
        onSingleChanged?.call(first);
      },
      itemBuilder: itemBuilder,
      headerBuilder: headerBuilder,
      footerBuilder: footerBuilder,
    );
  }

}
