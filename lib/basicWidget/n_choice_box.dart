import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

///选择盒子
class NChoiceBox<T> extends StatefulWidget {
  const NChoiceBox({
    super.key,
    required this.items,
    required this.onChanged,
    this.isSingle = false,
    this.itemMargin = const EdgeInsets.symmetric(vertical: 4),
    this.itemColor = const Color(0xffF3F3F3),
    this.itemRadius = 8,
    this.itemSelectedColor = Colors.blue,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.wrapSpacing = 16,
    this.wrapRunSpacing = 12,
    this.wrapAlignment = WrapAlignment.start,
    this.itemBuilder,
  });

  /// 是否单选
  final bool isSingle;

  final List<ChoiceBoxModel<T>> items;

  final ValueChanged<List<ChoiceBoxModel<T>>> onChanged;

  final CrossAxisAlignment crossAxisAlignment;

  final double wrapSpacing;

  final double wrapRunSpacing;

  final WrapAlignment wrapAlignment;

  final EdgeInsets itemMargin;

  /// item 圆角
  final double itemRadius;

  /// 元素背景色
  final Color itemColor;

  /// 选中元素背景色
  final Color itemSelectedColor;

  /// 子项样式自定义
  final Widget? Function(T e, bool isSelected)? itemBuilder;

  @override
  _NChoiceBoxState<T> createState() => _NChoiceBoxState<T>();
}

class _NChoiceBoxState<T> extends State<NChoiceBox<T>> {
  /// 选中的 items
  List<ChoiceBoxModel<T>> get selectedItems =>
      widget.items.where((e) => e.isSelected).toList();

  List<String> get selectedItemNames =>
      selectedItems.map((e) => e.title).toList();

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
          children: widget.items
              .map(
                (e) => buildItem(e),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget buildItem(ChoiceBoxModel e) {
    if (widget.itemBuilder != null) {
      return InkWell(
        onTap: () {
          // widget.onSelected(e);
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
          widget.onChanged(selectedItems);
        },
        child: widget.itemBuilder?.call(e.data!, e.isSelected),
      );
    }

    return ChipTheme(
      data: ChipTheme.of(context).copyWith(
        backgroundColor: Colors.transparent,
        selectedColor: Colors.transparent,
        elevation: 0,
        pressElevation: 0,
        showCheckmark: false,
        padding: EdgeInsets.zero,
      ),
      child: ChoiceChip(
        label: Text(
          e.title,
          style: TextStyle(
            color: e.isSelected ? Colors.white : fontColor.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 6),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        selected: e.isSelected,
        selectedColor: widget.itemSelectedColor,
        // backgroundColor: widget.itemColor,
        backgroundColor:
            e.isSelected ? widget.itemSelectedColor : Color(0xffF3F3F3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.itemRadius),
          ),
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
          widget.onChanged(selectedItems);
          // debugPrint("seletectedItemNames: ${seletectedItemNames}");
        },
      ),
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
