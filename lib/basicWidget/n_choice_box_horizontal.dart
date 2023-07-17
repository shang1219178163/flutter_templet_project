

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/uti/color_util.dart';

///选择盒子水平
class NChoiceBoxHorizontal<T> extends StatefulWidget {

  NChoiceBoxHorizontal({
    Key? key,
    required this.onChanged,
    required this.items,
    this.title,
    this.itemColor = bgColor,
    this.itemSelectedColor = Colors.blue,
    this.spacing = 8,
    this.isSingle = false,
  }) : super(key: key);

  List<ChoiceBoxModel<T>> items;

  ValueChanged<List<ChoiceBoxModel<T>>> onChanged;

  String? title;
  /// 元素水平距离默认 8px
  double spacing;

  /// 元素背景色
  Color itemColor;
  /// 选中元素背景色
  Color itemSelectedColor;

  /// 是否单选
  bool isSingle;


  @override
  _NChoiceBoxHorizontalState<T> createState() => _NChoiceBoxHorizontalState<T>();
}

class _NChoiceBoxHorizontalState<T> extends State<NChoiceBoxHorizontal<T>> {

  /// 选中的 items
  List<ChoiceBoxModel<T>> get seletectedItems => widget.items.where((e) => e.isSelected == true).toList();

  List<String> get seletectedItemNames => seletectedItems.map((e) => e.title).toList();

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

        return Theme(
          data: ThemeData(
            canvasColor: Colors.transparent,
            highlightColor: Colors.white,
          ),
          child: ChoiceChip(
            pressElevation: 0,
            label: Text(e.title,
              style: TextStyle(
                color: e.isSelected == true ? Colors.white : fontColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            // padding: EdgeInsets.only(left: 15, right: 15),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
      },
      separatorBuilder: (context, index) {
        return SizedBox(width: widget.spacing,);
      }
    );
  }
}


/// 多选模型
class NChoiceBoxHorizontalModel<T>{

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