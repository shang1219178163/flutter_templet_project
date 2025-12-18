//
//  NTextfieldTextview.dart
//  projects
//
//  Created by shang on 2025/12/18 15:10.
//  Copyright © 2025/12/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 多行文字输入
class TextfieldTextview extends StatefulWidget {
  const TextfieldTextview({
    super.key,
    this.enabled,
    required this.text,
    this.style,
    this.controller,
    this.onChanged,
    this.contentPadding = const EdgeInsets.fromLTRB(8, 12, 8, 12),
    this.fillColor,
    this.border,
    this.hintText,
    this.hintStyle,
    this.readOnly = false,
    this.maxLength = 300,
    this.maxLines = 4,
    this.minLines = 1,
    this.borderRadius = 4,
    this.decorationbuilder,
  });

  final bool? enabled;

  final String text;

  final TextStyle? style;

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  /// 内容边距
  final EdgeInsetsGeometry? contentPadding;

  /// 提示语
  final String? hintText;

  final TextStyle? hintStyle;

  /// 填充颜色
  final Color? fillColor;

  final InputBorder? border;

  final bool readOnly;
  final int maxLength;

  final int? maxLines;

  final int? minLines;

  final double borderRadius;

  final InputDecoration Function(InputDecoration d)? decorationbuilder;

  @override
  State<TextfieldTextview> createState() => _TextfieldTextviewState();
}

class _TextfieldTextviewState extends State<TextfieldTextview> {
  late final controllerNew = widget.controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    controllerNew.text = widget.text;

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        width: 0.5,
        color: Color(0xffDEDEDE),
      ),
    );

    final decoration = InputDecoration(
      isDense: true,
      hintText: widget.hintText ?? '请输入',
      hintStyle: widget.hintStyle,
      border: widget.border ?? outlineInputBorder,
      enabledBorder: widget.border ?? outlineInputBorder,
      focusedBorder: widget.border ?? outlineInputBorder,
      disabledBorder: widget.border ?? outlineInputBorder,
      contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      fillColor: widget.fillColor,
      filled: widget.fillColor != null,
      counter: widget.readOnly
          ? null
          : ValueListenableBuilder(
              valueListenable: controllerNew,
              builder: (context, value, child) {
                final length = value.text.characters.length;
                return Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "$length",
                        // style: const TextStyle(
                        //   fontSize: 12,
                        //   fontWeight: FontWeight.w500,
                        //   color: Colors.black87,
                        // ),
                      ),
                      TextSpan(
                        text: '/${widget.maxLength}',
                      ),
                    ],
                  ),
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF737373),
                  ),
                );
              },
            ),
    );

    return TextField(
      enabled: widget.enabled,
      controller: controllerNew,
      onChanged: widget.onChanged,
      style: widget.style,
      readOnly: widget.readOnly,
      maxLength: widget.readOnly ? null : widget.maxLength,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      decoration: widget.decorationbuilder?.call(decoration) ?? decoration,
    );
  }
}
