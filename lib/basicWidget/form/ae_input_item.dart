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
import 'package:flutter_templet_project/util/theme/app_color.dart';

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
    this.minLines = 3,
    this.maxLines = 4,
    this.maxLength = 100,
    this.softWrap = true,
    this.autofocus = false,
    this.inputFormatters,
    this.disableBgColor,
    this.disableTextColor,
    this.showCounter = false,
    this.isCounterInner = false,
    this.header,
    this.footer,
    this.enable = true,
  });

  /// 选择项标题
  final String? title;

  /// 控制器
  final TextEditingController controller;

  /// 回调
  final ValueChanged<String>? onChanged;

  /// 编辑回调
  final VoidCallback? onEditingComplete;

  /// 键盘样式
  final TextInputType? keyboardType;

  /// 字体对齐方式
  final TextAlign textAlign;

  /// 圆角
  final double radius;

  /// 最小行数
  final int? minLines;

  /// 最大行数
  final int? maxLines;

  /// 最大字数
  final int? maxLength;

  /// 是否可以折行
  final bool softWrap;

  /// 是否自动对焦
  final bool autofocus;

  /// 输入过滤
  final List<TextInputFormatter>? inputFormatters;

  /// 禁用背景色
  final Color? disableBgColor;

  /// 禁用字体颜色
  final Color? disableTextColor;

  /// 是否显示字数统计
  final bool showCounter;

  /// 字数统计 是否显示在内部
  final bool isCounterInner;

  /// 组件头
  final Widget? header;

  /// 组件尾
  final Widget? footer;

  /// 是否禁用
  final bool enable;

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
    final textColor = enable ? AppColor.fontColor : (disableTextColor ?? AppColor.fontColorB3B3B3);
    final bgColor = enable ? AppColor.white : disableBgColor ?? AppColor.bgColorEDEDED;

    final style = TextStyle(
      color: textColor,
      fontSize: 14,
    );

    if (!enable) {
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

    /// 边框
    buildBorder({Color color = const Color(0xFFE6E6E6)}) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(radius),
      );
    }

    final counter = showCounter
        ? controller.buildInputDecorationCounter(
            maxLength: maxLength,
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
          style: style,
          autofocus: autofocus,
          cursorColor: context.primaryColor,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.only(
              left: 8,
              top: 8,
              right: 8,
              bottom: showCounter && isCounterInner ? 22 + 8 : 8,
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
            counter: showCounter && !isCounterInner ? counter : null,
          ),
          inputFormatters: inputFormatters ??
              [
                if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
              ],
        ),
        if (showCounter && isCounterInner)
          Positioned(
            right: 10,
            bottom: 8,
            child: counter ?? SizedBox(),
          ),
      ],
    );
  }
}
