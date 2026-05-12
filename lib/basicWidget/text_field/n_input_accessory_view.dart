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
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_manager_new.dart';
import 'package:flutter_templet_project/util/n_screen_manager.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// 键盘辅助视图
class NInputAccessoryView extends StatefulWidget {
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
    TextInputType? keyboardType,
    String? hintText = "请输入",
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    int? maxLength,
    double? keyboardHeight,
  }) {
    focusNode?.requestFocus();
    // SystemChannels.textInput.invokeMethod('TextInput.show');
    NOverlayManagerNew.show(
      context,
      autoDismiss: false,
      builder: (c) {
        return NInputAccessoryView(
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
        );
      },
    );
  }

  static void dismiss() {
    NOverlayManagerNew.removeAll();
  }

  @override
  State<NInputAccessoryView> createState() => _NInputAccessoryViewState();
}

class _NInputAccessoryViewState extends State<NInputAccessoryView>
    with KeyboardHeightChangedMixin<NInputAccessoryView> {
  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      onTapOutside: (e) {
        if (widget.onTapOutside != null) {
          widget.onTapOutside?.call(e);
          return;
        }
        NInputAccessoryView.dismiss();
      },
      focusNode: widget.focusNode,
      controller: widget.controller,
      inputFormatters: widget.inputFormatters,
      minLines: 1,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        border: InputBorder.none,
        // isDense: true,
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6).copyWith(bottom: 8),
        hintText: widget.hintText,
      ),
    );

    final textFieldNew = widget.textFieldBuilder?.call(textField) ?? textField;

    return ValueListenableBuilder(
      valueListenable: keyboardHeightVN,
      child: Container(
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
              valueListenable: widget.controller,
              builder: (context, value, child) {
                final disable = value.text.isEmpty;
                return ElevatedBtn(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  radius: 20,
                  onPressed: disable
                      ? null
                      : () {
                          widget.onConfirm(value.text);
                          widget.focusNode?.unfocus();
                        },
                  title: "确定",
                );
              },
            ),
          ],
        ),
      ),
      builder: (context, bottom, child) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: bottom,
          child: child!,
        );
      },
    );
  }
}
