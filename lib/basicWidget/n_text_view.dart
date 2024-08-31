//
//  NTextview.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/31 09:11.
//  Copyright © 2024/8/31 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/editable_text_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// 封装输入框组件
class NTextView extends StatefulWidget {
  NTextView({
    super.key,
    this.value = "",
    this.controller,
    required this.onChanged,
    this.style = const TextStyle(fontSize: 16),
    this.readOnly = false,
    this.hintText = "请输入",
    this.hintStyle = const TextStyle(fontSize: 16, color: Color(0xff737373)),
    this.minLines = 1,
    this.maxLines = 4,
    this.maxLength = 200,
    this.radius = 4,
    this.autofocus = false,
    this.focusNode,
    this.isCollapsed,
    this.inputFormatters,
    this.decorationBuilder,
    this.isCounterInner = true,
  });

  final String? value;

  /// 控制器
  final TextEditingController? controller;

  /// 改变回调
  final ValueChanged<String> onChanged;

  final TextStyle? style;

  final bool readOnly;

  /// 提示语
  final String? hintText;

  final TextStyle? hintStyle;

  /// 最小行数
  final int? minLines;

  /// 最大行数
  final int? maxLines;

  /// 最大字数
  final int? maxLength;

  final double radius;

  final bool autofocus;

  /// 输入框焦点
  final FocusNode? focusNode;

  // true代表取消textfield最小高度限制
  final bool? isCollapsed;

  final List<TextInputFormatter>? inputFormatters;

  final bool isCounterInner;

  final InputDecoration Function(InputDecoration decoration)? decorationBuilder;

  @override
  _NTextViewState createState() => _NTextViewState();
}

class _NTextViewState extends State<NTextView> {
  late final textEditingController =
      widget.controller ?? TextEditingController(text: widget.value);

  late final focusNode = widget.focusNode ?? FocusNode();

  final hasFocus = ValueNotifier(false);

  @override
  void dispose() {
    focusNode.removeListener(focusAddListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    focusNode.addListener(focusAddListener);
  }

  void focusAddListener() {
    hasFocus.value = focusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    final contentPadding = widget.isCounterInner
        ? EdgeInsets.only(left: 8, right: 8, top: 6)
        : EdgeInsets.symmetric(horizontal: 8, vertical: 6);

    var contentMargin =
        widget.isCounterInner ? EdgeInsets.only(bottom: 6) : EdgeInsets.zero;

    final textField = NTextField(
      focusNode: focusNode,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      hidePrefix: true,
      hideSuffix: true,
      hideClear: true,
      decorationBuilder: (dt) {
        final border = buildBorder(color: Colors.white);

        final focusedBorder = widget.isCounterInner
            ? InputBorder.none
            : buildBorder(color: context.primaryColor);

        final dtNew = dt.copyWith(
          fillColor: Colors.white,
          border: border,
          enabledBorder: border,
          focusedBorder: focusedBorder,
          contentPadding: contentPadding,
        );
        return widget.decorationBuilder?.call(dtNew) ?? dtNew;
      },
      onChanged: widget.onChanged,
    );

    if (!widget.isCounterInner) {
      return textField;
    }

    return ValueListenableBuilder(
      valueListenable: hasFocus,
      builder: (context, value, child) {
        final borderColor = value ? context.primaryColor : Colors.transparent;
        return Container(
          padding: contentMargin,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          ),
          child: textField,
        );
      },
    );
  }

  buildBorder({required Color color, double radius = 4}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(
        color: color, //边线颜色为白色
        width: 1, //边线宽度为1
      ),
    );
  }
}
