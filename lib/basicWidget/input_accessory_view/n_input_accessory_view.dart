//
//  NInputAccessoryView.dart
//  projects
//
//  Created by shang on 2026/4/29 16:51.
//  Copyright © 2026/4/29 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/elevated_btn.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_manager.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:provider/provider.dart';

/// 键盘辅助视图
class NInputAccessoryView extends StatelessWidget {
  const NInputAccessoryView({
    super.key,
    this.focusNode,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.maxLines = 3,
    this.maxLength,
    this.inputFormatters,
    this.textFieldBuilder,
    required this.onConfirm,
  });

  final FocusNode? focusNode;

  final TextEditingController controller;

  final TextInputType? keyboardType;

  final String? hintText;

  final int? maxLines;
  final int? maxLength;

  final List<TextInputFormatter>? inputFormatters;

  final TextField Function(TextField v)? textFieldBuilder;

  final ValueChanged<String> onConfirm;

  // 展示礼物辅助视图
  static void show({
    BuildContext? context,
    required FocusNode focusNode,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? hintText = "请输入",
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    int? maxLength,
  }) {
    final contextNew = context ?? ToolUtil.navigator.context;
    NOverlayManager.show(
      contextNew,
      autoDismiss: false,
      builder: (c) {
        final bottom = MediaQuery.of(c).viewInsets.bottom;
        DLog.d("NOverlayManager.show $bottom");
        return Positioned(
          left: 0,
          right: 0,
          bottom: bottom,
          child: NInputAccessoryView(
            focusNode: focusNode,
            controller: controller,
            keyboardType: keyboardType,
            hintText: hintText,
            maxLines: maxLines,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            onConfirm: (v) {
              dismiss();
            },
          ),
        );
      },
    );
  }

  static void dismiss() {
    NOverlayManager.clear();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;
    final color23242FOrWhite = isDark ? Color(0xFF23242F) : Colors.white;

    late final themeProvider = context.read<ThemeProvider>();

    final textField = TextField(
      focusNode: focusNode,
      controller: controller,
      inputFormatters: inputFormatters,
      minLines: 1,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        border: InputBorder.none,
        // isDense: true,
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6).copyWith(bottom: 8),
        hintText: hintText,
      ),
    );

    final textFieldNew = textFieldBuilder?.call(textField) ?? textField;

    return Container(
      // height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: color23242FOrWhite,
        // border: Border.all(color: Colors.blue),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: themeProvider.color181829OrF6F6F6,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: textFieldNew,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              final disable = value.text.isEmpty;
              return ElevatedBtn(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                radius: 20,
                onPressed: disable
                    ? null
                    : () {
                        DLog.d("确定 ${value.text}");
                        onConfirm(value.text);
                        focusNode?.unfocus();
                      },
                title: "确定",
              );
            },
          ),
        ],
      ),
    );
  }
}
