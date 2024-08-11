import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

///选择盒子水平
class NChoiceBoxHorizontal<T> extends StatefulWidget {
  const NChoiceBoxHorizontal({
    super.key,
    required this.items,
    required this.onChanged,
    this.isSingle = false,
    this.itemColor = bgColor,
    this.itemSelectedColor = Colors.blue,
    this.spacing = 8,
    this.itemBuilder,
  });

  final List<ChoiceBoxModel<T>> items;

  final ValueChanged<List<ChoiceBoxModel<T>>> onChanged;

  /// 是否单选
  final bool isSingle;

  /// 元素水平距离默认 8px
  final double spacing;

  /// 元素背景色
  final Color itemColor;

  /// 选中元素背景色
  final Color itemSelectedColor;

  /// 子项样式自定义
  final Widget? Function(T e, bool isSelected)? itemBuilder;

  @override
  _NChoiceBoxHorizontalState<T> createState() =>
      _NChoiceBoxHorizontalState<T>();
}

class _NChoiceBoxHorizontalState<T> extends State<NChoiceBoxHorizontal<T>> {
  /// 选中的 items
  List<ChoiceBoxModel<T>> get seletectedItems =>
      widget.items.where((e) => e.isSelected == true).toList();

  List<String> get seletectedItemNames =>
      seletectedItems.map((e) => e.title).toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final e = widget.items[index];
          return buildItem(e);
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: widget.spacing,
          );
        });
  }

  Widget buildItem(ChoiceBoxModel e) {
    if (widget.itemBuilder != null) {
      return InkWell(
        onTap: () {
          for (final element in widget.items) {
            if (element.id == e.id) {
              element.isSelected = !element.isSelected;
            } else {
              if (widget.isSingle) {
                element.isSelected = false;
              }
            }
          }
          setState(() {});
          widget.onChanged(seletectedItems);
        },
        child: widget.itemBuilder?.call(e.data!, e.isSelected),
      );
    }

    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
        highlightColor: Colors.white,
      ),
      child: ChoiceChip(
        pressElevation: 0,
        showCheckmark: false,
        side: BorderSide(color: Colors.transparent),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.symmetric(horizontal: 6, vertical: -3),
        label: Text(
          e.title,
          style: TextStyle(
            color: e.isSelected == true ? Colors.white : fontColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: e.isSelected == true,
        selectedColor: widget.itemSelectedColor,
        backgroundColor: widget.itemColor,
        onSelected: (bool selected) {
          for (final element in widget.items) {
            if (element.id == e.id) {
              element.isSelected = selected;
            } else {
              if (widget.isSingle) {
                element.isSelected = false;
              }
            }
          }
          setState(() {});
          widget.onChanged(seletectedItems);
          // debugPrint("seletectedItemNames: ${seletectedItemNames}");
        },
      ),
    );
  }
}

/// 多选模型
class NChoiceBoxHorizontalModel<T> {
  NChoiceBoxHorizontalModel({
    required this.models,
    this.selectedModelsTmp = const [],
    this.selectedModels = const [],
    this.title = "",
    this.isSingle = false,
    this.data,
  });

  String title;

  /// 是否单选
  bool isSingle;

  /// 模型数组
  List<T> models;

  /// 模型最终数组(可传入默认选择)
  List<T> selectedModels = [];

  /// 模型临时数组(可传入默认选择)
  List<T> selectedModelsTmp = [];

  /// 通用参数,挂载任何其他需要的参数
  dynamic data;
}

/// 多选模型
// class HorizontalChoicModel<T>{
//
//   HorizontalChoicModel({
//     required this.models,
//     this.selectedModelsTmp = const [],
//     this.selectedModels = const [],
//     this.title = "",
//     this.isSingle = false,
//     this.data,
//   });
//
//   String title;
//   /// 是否单选
//   bool isSingle;
//   /// 模型数组
//   List<T> models;
//   /// 模型最终数组(可传入默认选择)
//   List<T> selectedModels = [];
//   /// 模型临时数组(可传入默认选择)
//   List<T> selectedModelsTmp = [];
//
//   /// 通用参数,挂载任何其他需要的参数
//   dynamic data;
//
// }
