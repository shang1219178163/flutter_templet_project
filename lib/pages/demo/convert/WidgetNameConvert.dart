//
//  WidgetNameConvert.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/9 09:33.
//  Copyright © 2024/8/9 shang. All rights reserved.
//

import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/pages/demo/convert/ConvertProtocol.dart';

class WidgetNameConvert extends ConvertProtocol {
  @override
  String get name => "组件类名修改";

  @override
  String exampleTemplet() {
    return """
import 'package:flutter/material.dart';
import 'package:yl_health_app/util/color_util_new.dart';

///选择盒子
class NChoiceBox<T> extends StatefulWidget {
  const NChoiceBox({
    Key? key,
    required this.items,
    required this.onChanged,
    this.isSingle = false,
    this.itemMargin = const EdgeInsets.symmetric(vertical: 4),
    this.itemColor = bgColor,
    this.itemRadius = 4,
    this.itemSelectedColor,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.wrapSpacing = 8,
    this.wrapRunSpacing = 10,
    this.wrapAlignment = WrapAlignment.start,
    this.itemBuilder,
  }) : super(key: key);

  final List<ChoiceBoxModel<T>> items;

  final ValueChanged<List<ChoiceBoxModel<T>>> onChanged;

  /// 是否单选
  final bool isSingle;

  /// item 圆角
  final double itemRadius;

  final CrossAxisAlignment crossAxisAlignment;

  final double wrapSpacing;

  final double wrapRunSpacing;

  final WrapAlignment wrapAlignment;

  final EdgeInsets itemMargin;

  /// 元素背景色
  final Color itemColor;

  /// 选中元素背景色
  final Color? itemSelectedColor;

  /// 子项样式自定义
  final Widget? Function(T e, bool isSelected)? itemBuilder;

  @override
  NChoiceBoxState<T> createState() => NChoiceBoxState<T>();
}

class NChoiceBoxState<T> extends State<NChoiceBox<T>> {
  /// 选中的 items
  List<ChoiceBoxModel<T>> get selectedItems =>
      widget.items.where((e) => e.isSelected == true).toList();

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
          children: widget.items.map((e) => buildItem(e)).toList(),
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

    return Theme(
      // data: ThemeData(canvasColor: widget.itemColor),
      data: ThemeData(
        canvasColor: Colors.transparent,
        highlightColor: Colors.white,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ChoiceChip(
        pressElevation: 0,
        label: Text(
          e.title,
          style: TextStyle(
            color: e.isSelected == true ? primary : weChatSubTitleColor,
            fontSize: 14,
            // fontWeight: FontWeight.w500,
          ),
        ),
        // padding: const EdgeInsets.symmetric(horizontal: -2, vertical: -2),
        padding: EdgeInsets.zero,
        // labelPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        selected: e.isSelected == true,
        selectedColor: widget.itemSelectedColor ?? primary.withOpacity(0.1),
        backgroundColor:
            e.isSelected == true ? widget.itemColor : Color(0xffF3F3F3),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(widget.itemRadius),
        )),
        side: BorderSide(
            color: e.isSelected == true ? primary : Colors.transparent,
            width: 0.5),
        onSelected: (bool selected) {
          for (var element in widget.items) {
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
          // widget.onChanged(_choicItems);
          debugPrint("selectedItemNames: \$selectedItemNames");
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
    required this.isSelected,
    this.data,
  });

  String title;

  String id;

  bool isSelected;

  T? data;
}
""";
  }

  // @override
  // Future<ConvertModel?> convertFile({required File file}) async {
  //   final name = file.path.split("/").last;
  //   String content = await file.readAsString();
  //   return convert(content: content, name: name);
  // }

  @override
  Future<ConvertModel?> convert({
    required String productName,
    String? name,
    required String content,
  }) async {
    if (content.isEmpty) {
      return null;
    }
    final lines = content.split("\n").where((e) => e.startsWith("class ")).toList();

    final line = (lines.where((e) => e.startsWith("class ")).firstOrNull ?? "ClassName");

    var clsName = "";
    if (line.contains("<")) {
      clsName = line.split("<").first.split(" ")[1];
    } else {
      clsName = line.split(" ")[1];
    }

    final clsNameNew = clsName.replaceFirst("My", "Yl").replaceFirst("N", "Yl");
    final fileName = "${clsNameNew.toUncamlCase("_")}.dart".replaceFirst("yl_", "");
    final contentNew = content.replaceAll(clsName, clsNameNew).replaceFirst(
        "Widget build(BuildContext context) {",
        "Widget build(BuildContext context) {"
            "\n\t\tfinal theTheme = Theme.of(context)"
            ".extension<${clsNameNew}Theme>();\n");

    return ConvertModel(
      productName: productName,
      name: name ?? clsName,
      content: content,
      nameNew: fileName,
      contentNew: contentNew,
    );
  }
}
