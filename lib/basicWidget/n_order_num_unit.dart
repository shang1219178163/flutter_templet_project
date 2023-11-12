//
//  NOrderUnit.dart
//  flutter_templet_project
//
//  Created by shang on 2023/11/12 12:50.
//  Copyright © 2023/11/12 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 订单数量/金额等修改
class NOrderNumUnit extends StatefulWidget {

  NOrderNumUnit({
    Key? key,
    required this.value,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.labelText,
    this.fillColor = Colors.black12,
    this.fillColorReadOnly = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.borderRadius = 4,
    this.inputFormatters,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.unit = "元",
  }) : super(key: key);

  /// 默认值
  final String value;
  /// 键盘样式
  final TextInputType keyboardType;
  /// 是否可编辑
  final bool readOnly;
  /// 顶部提示词
  final String? labelText;
  /// 填充背景
  final Color? fillColor;
  /// 填充背景(不可编辑)
  final Color? fillColorReadOnly;
  /// 边框色
  final Color borderColor;
  /// 圆角
  final double borderRadius;
  /// 规则
  final List<TextInputFormatter>? inputFormatters;
  ///
  final Widget? suffixIcon;
  ///
  final BoxConstraints? suffixIconConstraints;
  /// 默认元
  final String unit;


  @override
  State<NOrderNumUnit> createState() => _NOrderNumUnitState();
}

class _NOrderNumUnitState extends State<NOrderNumUnit> {

  late final _controller = TextEditingController(text: widget.value);

  @override
  Widget build(BuildContext context) {
    return buildTextField();
  }

  Widget buildTextField(
  //     {
  //   TextEditingController? controller,
  //   TextInputType keyboardType = TextInputType.text,
  //   bool readOnly = false,
  //   String? labelText,
  //   Color? fillColor = Colors.black12,
  //   Color? fillColorReadOnly = Colors.transparent,
  //   Color borderColor = Colors.transparent,
  //   double borderRadius = 4,
  //   bool isCollapsed = true,
  //   EdgeInsets? contentPadding = const EdgeInsets.symmetric(
  //     horizontal: 8,
  //     vertical: 12,
  //   ),
  //   List<TextInputFormatter>? inputFormatters,
  //   Widget? suffixIcon,
  //   BoxConstraints? suffixIconConstraints,
  //   String unit = "元",
  // }
  ) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: widget.borderColor),
      borderRadius: BorderRadius.circular(widget.borderRadius),
    );

    final contentPadding = EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 12,
    );

    return TextField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        labelText: widget.labelText,
        filled: true,
        fillColor: widget.readOnly ? widget.fillColorReadOnly : widget.fillColor,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        isCollapsed: true,
        contentPadding: contentPadding,
        suffixIconConstraints: BoxConstraints().loosen(),
        suffixIcon: widget.suffixIcon ?? Row(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: contentPadding.left ?? 0),
              child: Text("| ${widget.unit}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // /// 高度 36
  // buildTextFieldUnit({
  //   TextEditingController? controller,
  //   TextInputType keyboardType = TextInputType.number,
  //   bool readOnly = true,
  //   String? labelText,
  //   Color? fillColor = Colors.black12,
  //   Color? fillColorReadOnly = Colors.transparent,
  //   List<TextInputFormatter>? inputFormatters,
  //   Widget? suffixIcon,
  //   String unit = "元",
  // }) {
  //   final contentPadding = EdgeInsets.symmetric(
  //     horizontal: 8,
  //     vertical: 12,
  //   );
  //   return buildTextField(
  //     controller: controller,
  //     keyboardType: keyboardType,
  //     readOnly: readOnly,
  //     // labelText: 'Weight (KG)',
  //     borderColor: Colors.transparent,
  //     isCollapsed: true,
  //     contentPadding: contentPadding,
  //     fillColor: readOnly ? fillColorReadOnly : fillColor,
  //     inputFormatters: inputFormatters,
  //     suffixIconConstraints: BoxConstraints().loosen(),
  //     suffixIcon: suffixIcon ?? Row(
  //       mainAxisSize: MainAxisSize.min,
  //       // crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(right: contentPadding.left),
  //           child: Text("| $unit",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               color: Colors.black54,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}