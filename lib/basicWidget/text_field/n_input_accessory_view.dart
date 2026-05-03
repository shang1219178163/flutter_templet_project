//
//  NInputAccessoryView.dart
//  projects
//
//  Created by shang on 2026/4/29 16:51.
//  Copyright © 2026/4/29 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/elevated_btn.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_manager_new.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:route_stack_manager/route_stack_manager.dart';

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
    this.onTapOutside,
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

  final TapRegionCallback? onTapOutside;

  final ValueChanged<String> onConfirm;

  // 展示礼物辅助视图
  static void show({
    required BuildContext context,
    FocusNode? focusNode,
    required TextEditingController controller,
    ValueNotifier<double>? keyboardVN,
    TextInputType? keyboardType,
    String? hintText = "请输入",
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    int? maxLength,
    double? keyboardHeight,
  }) {
    focusNode?.requestFocus();
    if (keyboardVN == null) {
      NOverlayManagerNew.show(
        context,
        autoDismiss: false,
        builder: (c) {
          var bottom = keyboardHeight ?? MediaQuery.of(c).viewInsets.bottom;
          DLog.d("bottom: $bottom");

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
                NInputAccessoryView.dismiss();
              },
            ),
          );
        },
      );
      return;
    }
    NOverlayManagerNew.show(
      context,
      autoDismiss: false,
      builder: (c) {
        var bottom = keyboardHeight ?? MediaQuery.of(c).viewInsets.bottom;
        DLog.d("bottom: $bottom");

        return ValueListenableBuilder(
          valueListenable: keyboardVN,
          child: NInputAccessoryView(
            focusNode: focusNode,
            controller: controller,
            keyboardType: keyboardType,
            hintText: hintText,
            maxLines: maxLines,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            onConfirm: (v) {
              NInputAccessoryView.dismiss();
            },
          ),
          builder: (context, value, child) {
            return AnimatedPositioned(
              duration: Duration(milliseconds: 100),
              left: 0,
              right: 0,
              bottom: max(keyboardVN.value, bottom),
              child: child!,
            );
          },
        );
      },
    );
  }

  static void dismiss() {
    NOverlayManagerNew.removeAll();
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      onTapOutside: (e) {
        if (onTapOutside != null) {
          onTapOutside?.call(e);
          return;
        }
        NInputAccessoryView.dismiss();
      },
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
      // margin: EdgeInsets.only(bottom: bottom),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.blue),
        border: Border(top: BorderSide(color: AppColor.lineColor, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
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
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                radius: 20,
                onPressed: disable
                    ? null
                    : () {
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
