//
//  NChoiceExpansionOfModel.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/9 12:26.
//  Copyright © 2024/4/9 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_expansion.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/mixin/selectable_mixin.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';

/// 模型(必须包含 bool isSelected 属性)的标签选择器
// class NChoiceExpansionOfModel<T extends SelectableMixin> extends StatelessWidget {
//
//   const NChoiceExpansionOfModel({
//     super.key,
//     required this.title,
//     this.titleStyle = const TextStyle(
//       color: Color(0xff737373),
//       fontSize: 14,
//       fontWeight: FontWeight.w500,
//     ),
//     required this.items,
//     required this.idCb,
//     required this.titleCb,
//     this.selectedCb,
//     this.isSingle = false,
//     required this.onChanged,
//     this.onSingleChanged,
//     this.itemBuilder,
//     this.headerBuilder,
//     this.footerBuilder,
//   });
//
//   /// 标题
//   final String title;
//   /// 标题字体样式
//   final TextStyle? titleStyle;
//   /// 组数据
//   final List<T> items;
//   /// 单选/多选
//   final bool isSingle;
//   final String Function(T e) idCb;
//   /// 标题显示
//   final String Function(T e) titleCb;
//   /// 标题显示
//   final bool Function(T e)? selectedCb;
//
//   /// 改变回掉
//   final ValueChanged<List<T>> onChanged;
//   /// 单选回调
//   final ValueChanged<T?>? onSingleChanged;
//   /// 子项样式自定义
//   final Widget Function(T e)? itemBuilder;
//   /// 头部项目自定义
//   final Widget Function(VoidCallback onToggle)? headerBuilder;
//   /// 尾部自定义
//   final Widget Function(VoidCallback onToggle)? footerBuilder;
//
//   @override
//   Widget build(BuildContext context) {
//     return NChoiceExpansion<T>(
//       title: title,
//       titleStyle: titleStyle,
//       items: items,
//       titleCb: titleCb,
//       selectedCb: selectedCb ?? (e) => e.isSelected,
//       // selectedCb: (e) => e.isSelected,
//       onSelected: (e) {
//         // ddlog(e.name);
//         for (final element in items) {
//           if (idCb(element) == idCb(e)) {
//             element.isSelected = !element.isSelected;
//           } else {
//             if (isSingle) {
//               element.isSelected = false;
//             }
//           }
//         }
//         final selecetdItems = items.where((e) => e.isSelected).toList();
//         // ddlog(items.map((e) => "${titleCb(e)},${e.isSelected}" ).toList().join("\n"));
//         onChanged(selecetdItems);
//
//         final first = selecetdItems.isEmpty ? null : selecetdItems.first;
//         onSingleChanged?.call(first);
//       },
//       itemBuilder: itemBuilder,
//       headerBuilder: headerBuilder,
//       footerBuilder: footerBuilder,
//     );
//   }
//
// }


class NChoiceExpansionOfModel<T> extends StatefulWidget {

  const NChoiceExpansionOfModel({
    super.key,
    required this.title,
    this.titleStyle = const TextStyle(
      color: Color(0xff737373),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    required this.items,
    // required this.selectedItems,
    required this.idCb,
    required this.titleCb,
    required this.selectedCb,
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
  /// 组数据
  // final List<T> selectedItems;
  /// 单选/多选
  final bool isSingle;
  final String Function(T e) idCb;
  /// 标题显示
  final String Function(T e) titleCb;
  /// 标题显示
  final bool Function(T e) selectedCb;

  /// 改变回掉
  final ValueChanged<List<T>> onChanged;
  /// 单选回调
  final ValueChanged<T?>? onSingleChanged;
  /// 子项样式自定义
  final Widget Function(T e, bool isSelected)? itemBuilder;
  /// 头部项目自定义
  final Widget Function(VoidCallback onToggle)? headerBuilder;
  /// 尾部自定义
  final Widget Function(VoidCallback onToggle)? footerBuilder;

  @override
  _NChoiceExpansionOfModelState<T> createState() => _NChoiceExpansionOfModelState<T>();
}

class _NChoiceExpansionOfModelState<T> extends State<NChoiceExpansionOfModel<T>> {

  @override
  void didUpdateWidget(covariant NChoiceExpansionOfModel<T> oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final models = widget.items.map((e) => ChoiceBoxModel<T>(
      id: widget.idCb(e),
      title: widget.titleCb(e),
      isSelected: widget.selectedCb(e),
      data: e,
    ))
        .toList();
    return NChoiceExpansion<ChoiceBoxModel<T>>(
      title: widget.title,
      titleStyle: widget.titleStyle,
      items: models,
      titleCb: (e) => widget.titleCb(e.data),
      selectedCb: (e) => e.isSelected,
      onSelected: (e) {
        for (final element in models) {
          if (element.id == e.id) {
            element.isSelected = !element.isSelected;
          } else {
            if (widget.isSingle) {
              element.isSelected = false;
            }
          }
        }

        final selecetdItems = models.where((e) => e.isSelected).map((e) => e.data).toList();
        // ddlog(items.map((e) => "${titleCb(e)},${e.isSelected}" ).toList().join("\n"));
        widget.onChanged(selecetdItems);

        final first = selecetdItems.isEmpty ? null : selecetdItems.first;
        widget.onSingleChanged?.call(first);
      },
      itemBuilder: (e, isSelected) => widget.itemBuilder?.call(e.data, e.isSelected),
      headerBuilder: widget.headerBuilder,
      footerBuilder: widget.footerBuilder,
    );
  }

}
