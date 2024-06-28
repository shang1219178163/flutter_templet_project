//
//  AeRemarkItem.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 21:17.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/editable_text_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// AE 输入框组件
class AeInputItem extends StatelessWidget {
  const AeInputItem({
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
    this.maxLength = 100,
    this.softWrap = true,
    this.autofocus = false,
    this.inputFormatters,
    this.disableBgColor,
    this.disableTextColor,
    this.header,
    this.footer,
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
  final int maxLength;

  /// 是否可以折行
  final bool softWrap;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;

  /// 禁用背景色
  final Color? disableBgColor;

  final Color? disableTextColor;

  /// 是否禁用
  final bool enable;

  /// 组件头
  final Widget? header;

  /// 组件尾
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header ?? const SizedBox(),
        if (header != null) const SizedBox(height: 5),
        buildBody(context),
        footer ?? const SizedBox(),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    final boxShadow = const [
      BoxShadow(
        color: Color(0x08000000),
        blurRadius: 16,
        offset: Offset(0, 5),
      )
    ];
    if (!enable) {
      final textColor =
          enable ? fontColor : (disableTextColor ?? fontColorB3B3B3);
      final bgColor = enable ? white : disableBgColor ?? bgColorEDEDED;

      var text = controller.text;
      if (text.isEmpty) {
        text = "--";
      }
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: const Color(0xFFE6E6E6), width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: boxShadow,
        ),
        child: NText(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
        ),
      );
    }

    buildBorder({Color color = const Color(0xFFE6E6E6)}) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(radius),
      );
    }

    final hasCounterDesc = enable && maxLines > 1;

    return Container(
      decoration: BoxDecoration(
        color: white,
        boxShadow: boxShadow,
      ),
      child: TextField(
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
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          // icon: Icon(Icons.search),
          // labelText: "Search",
          hintText: "",
          // prefixIcon: Icon(Icons.search),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: buildBorder(),
          focusedBorder: buildBorder(
            color: context.primaryColor,
          ),
          counter: hasCounterDesc
              ? controller.buildInputDecorationCounter(
                  maxLength: maxLength,
                )
              : null,
        ),
        inputFormatters: inputFormatters ??
            [
              LengthLimitingTextInputFormatter(maxLength),
            ],
      ),
    );
  }
}
