//
//  AeTextfiled.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 21:17.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// AE 输入框组件
class AeTextfiled extends StatelessWidget {
  const AeTextfiled({
    super.key,
    this.title,
    required this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.radius = 4,
    this.minLines = 4,
    this.maxLines = 4,
    this.maxLength,
    this.softWrap = true,
    this.autofocus = false,
    this.inputFormatters,
    this.disableBgColor,
    this.disableTextColor,
    this.isCounterInner = true,
    this.enable = true,
  });

  /// 选择项标题
  final String? title;

  final TextEditingController controller;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final double radius;
  final int? minLines;
  final int maxLines;

  /// 最大长度
  final int? maxLength;

  /// 是否可以折行
  final bool softWrap;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;

  /// 禁用背景色
  final Color? disableBgColor;

  final Color? disableTextColor;

  /// 字数统计 是否显示在内部
  final bool isCounterInner;

  /// 是否禁用
  final bool enable;

  @override
  Widget build(BuildContext context) {
    // final hasCounterDesc = enable && maxLines > 1;

    final hasMaxLengthLimit = maxLength != null;
    final counter = hasMaxLengthLimit
        ? controller.buildInputDecorationCounter(
            maxLength: maxLength!,
          )
        : null;

    return Stack(
      children: [
        TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enable,
          onEditingComplete: onEditingComplete,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          textAlign: textAlign,
          autofocus: autofocus,
          cursorColor: context.primaryColor,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.only(
              left: 8,
              top: 8,
              right: 8,
              bottom: hasMaxLengthLimit && isCounterInner ? 22 + 8 : 8,
            ),
            // icon: Icon(Icons.search),
            // labelText: "Search",
            hintText: "",
            // prefixIcon: Icon(Icons.search),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: buildBorder(),
            focusedBorder: buildBorder(
              color: context.primaryColor,
            ),
            counter: hasMaxLengthLimit && !isCounterInner ? counter : null,
          ),
          inputFormatters: inputFormatters ??
              [
                if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
              ],
        ),
        if (hasMaxLengthLimit && isCounterInner)
          Positioned(
            right: 10,
            bottom: 8,
            child: counter ?? SizedBox(),
          ),
      ],
    );
  }

  /// 边框
  buildBorder({Color color = const Color(0xFFE6E6E6)}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 0.5),
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
