

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

///选择盒子
class NChoiceBox<T> extends StatefulWidget {

  NChoiceBox({
    Key? key,
    required this.items,
    required this.onChanged,
    this.title,
    this.itemMargin = const EdgeInsets.symmetric(vertical: 4),
    this.itemColor = const Color(0xffF3F3F3),
    this.itemRadius = 8,
    this.itemSelectedColor = Colors.blue,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.wrapSpacing = 16,
    this.wrapRunSpacing = 12,
    this.wrapAlignment = WrapAlignment.start,
    this.isSingle = false,
  }) : super(key: key);

  List<ChoiceBoxModel<T>> items;

  ValueChanged<List<ChoiceBoxModel<T>>> onChanged;

  String? title;

  CrossAxisAlignment crossAxisAlignment;

  double wrapSpacing;

  double wrapRunSpacing;

  WrapAlignment wrapAlignment;

  EdgeInsets itemMargin;
  /// item 圆角
  double itemRadius;
  /// 元素背景色
  Color itemColor;
  /// 选中元素背景色
  Color itemSelectedColor;

  /// 是否单选
  bool isSingle;


  @override
  _NChoiceBoxState<T> createState() => _NChoiceBoxState<T>();
}

class _NChoiceBoxState<T> extends State<NChoiceBox<T>> {

  /// 选中的 items
  List<ChoiceBoxModel<T>> get seletectedItems => widget.items.where((e) => e.isSelected == true).toList();

  List<String> get seletectedItemNames => seletectedItems.map((e) => e.title).toList();

  @override
  void initState() {
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: [
        Wrap(
          spacing: widget.wrapSpacing,
          runSpacing: widget.wrapRunSpacing,
          alignment: widget.wrapAlignment,
          children: widget.items.map((e) => Theme(
            data: ThemeData(
              canvasColor: Colors.transparent,
              highlightColor: Colors.white,
            ),
            child: ChoiceChip(
              pressElevation: 0,
              showCheckmark: false,
              label: Text(e.title,
                style: TextStyle(
                  color: e.isSelected == true ? Colors.white : fontColor,
                  fontSize: 14,
                ),
              ),
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.symmetric(horizontal: 6),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selected: e.isSelected == true,
              selectedColor: widget.itemSelectedColor,
              // backgroundColor: widget.itemColor,
              backgroundColor: e.isSelected ? widget.itemSelectedColor : Color(0xffF3F3F3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(widget.itemRadius),),
                side: BorderSide(color: Colors.transparent),
              ),
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
          ),).toList(),
        ),
      ],
    );
  }
}

/// ChoiceBox组件匹配模型
class ChoiceBoxModel<T> {

  ChoiceBoxModel({
    required this.title,
    required this.id,
    this.isSelected = false,
    required this.data,
  });

  String id;

  String title;

  bool isSelected;

  T data;
}