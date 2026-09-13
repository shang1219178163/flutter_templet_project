//
//  NOrderUnit.dart
//  flutter_templet_project
//
//  Created by shang on 2023/11/12 12:50.
//  Copyright © 2023/11/12 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 订单数量/金额等修改（颜色默认跟随 Theme ColorScheme）
class NOrderNumUnit extends StatefulWidget {
  NOrderNumUnit({
    super.key,
    required this.value,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.labelText,
    this.fillColor,
    this.fillColorReadOnly,
    this.borderColor,
    this.borderRadius = 4,
    this.inputFormatters,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.unit = "元",
  });

  final String value;
  final TextInputType keyboardType;
  final bool readOnly;
  final String? labelText;

  /// 可编辑填充；null → colorScheme.surfaceContainer
  final Color? fillColor;

  /// 只读填充；null → colorScheme.surfaceContainerLow
  final Color? fillColorReadOnly;

  /// 边框色；null → transparent
  final Color? borderColor;
  final double borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final String unit;

  @override
  State<NOrderNumUnit> createState() => _NOrderNumUnitState();
}

class _NOrderNumUnitState extends State<NOrderNumUnit> {
  late final _controller = TextEditingController(text: widget.value);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderColor = widget.borderColor ?? Colors.transparent;
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor),
      borderRadius: BorderRadius.circular(widget.borderRadius),
    );
    const contentPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 6);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final inputFill = dark ? cs.surfaceContainerLow : cs.surfaceContainer;
    final card = dark ? cs.surfaceContainer : cs.surfaceContainerLow;
    final fill = widget.readOnly
        ? (widget.fillColorReadOnly ?? card)
        : (widget.fillColor ?? inputFill);

    return TextField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        labelText: widget.labelText,
        filled: true,
        fillColor: fill,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        isCollapsed: true,
        contentPadding: contentPadding,
        suffixIconConstraints: const BoxConstraints().loosen(),
        suffixIcon: widget.suffixIcon ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: contentPadding.left),
                  child: Text(
                    "| ${widget.unit}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
