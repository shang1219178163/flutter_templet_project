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
    required this.items,
    this.isSingle = false,
    required this.onChanged,
    this.onSingleChanged,
    this.itemBuilder,
  });

  final String title;
  //组数据
  final List<T> items;

  final bool isSingle;
  final ValueChanged<List<T>> onChanged;
  final ValueChanged<T?>? onSingleChanged;
  final Widget Function(T e)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return NChoiceExpansion<T>(
      title: title,
      items: items,
      titleCb: (e) => e.name ?? "",
      selectedCb: (e) => e.isSelected == true,
      onSelect: (e) {
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
    );
  }

}
