//
//  NTextfieldUnit.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/13 12:16.
//  Copyright © 2024/12/13 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/editable_text_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// 带单位的输入框
class NTextfieldUnit extends StatelessWidget {
  const NTextfieldUnit({
    super.key,
    this.focusNode,
    this.enabled,
    required this.name,
    required this.value,
    this.controller,
    this.unit,
    this.maxLines = 1,
    this.hideSuffix = false,
    this.suffixWidth = 36,
    this.suffixHeight = 36,
    this.suffix,
    this.hitText = "请输入",
    this.textColor,
    this.hintTextColor,
    this.debounceMilliseconds = 300,
    required this.onChanged,
    this.onTap,
    this.showClear = true,
    this.onClear,
    this.readOnly = false,
    this.readOnlyFillColor = bgColorF3F3F3,
    this.readOnlyBorderColor = lineColor,
    this.radius = 4,
    this.keyboardType,
    this.inputFormatters,
  });

  /// 输入框焦点
  final FocusNode? focusNode;

  /// 是否禁用
  final bool? enabled;

  /// 左边标题
  final String name;

  /// 值
  final String value;

  /// 控制器
  final TextEditingController? controller;

  /// 右边单位
  final String? unit;

  /// 最大行数
  final int? maxLines;

  /// 隐藏 Suffix
  final bool hideSuffix;

  /// Suffix 宽度
  final double suffixWidth;

  /// Suffix 高度
  final double suffixHeight;

  /// Suffix
  final Widget? suffix;

  /// 提示语
  final String hitText;

  final Color? textColor;

  final Color? hintTextColor;

  /// 防抖间距
  final int debounceMilliseconds;

  /// 回调
  final ValueChanged<String> onChanged;

  /// 点击回调
  final VoidCallback? onTap;

  /// 显示清除按钮
  final bool showClear;

  /// 清除
  final VoidCallback? onClear;

  /// 是否仅读
  final bool readOnly;

  /// 仅读背景色
  final Color? readOnlyFillColor;

  /// 仅读边框线
  final Color readOnlyBorderColor;

  /// 圆角半径
  final double? radius;

  /// 键盘类型
  final TextInputType? keyboardType;

  /// 输入限制
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(radius ?? 4));
    var valueNew = ["null"].contains(value) ? "" : value;

    var clearWidth = showClear ? 24.0 : 0;
    if (readOnly) {
      clearWidth = 0;
    }

    final controllerNew = controller ?? TextEditingController(text: valueNew);

    final hasFocusVN = ValueNotifier<bool>(false);

    Widget child = _NTextField(
      enabled: enabled,
      value: valueNew,
      controller: controllerNew,
      focusNode: focusNode,
      hasFocusVN: hasFocusVN,
      isCollapsed: true,
      maxLines: maxLines,
      onTap: onTap,
      borderWidth: 0.5,
      fillColor: readOnly ? readOnlyFillColor : white,
      readOnly: readOnly,
      contentPadding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 7,
        bottom: 7,
      ),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor ?? fontColor,
      ),
      hintText: hitText,
      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: hintTextColor ?? fontColorB3B3B3,
      ),
      suffixIconBuilder: (isFocus) {
        if (hideSuffix) {
          return null;
        }

        Widget suffixDefault = Container(
          margin: const EdgeInsets.only(right: 5),
          alignment: Alignment.centerRight,
          // decoration: BoxDecoration(
          //   color: Colors.transparent,
          //   border: Border.all(color: Colors.blue),
          // ),
          child: Image(
            image: "assets/images/icon_arrow_right.png".toAssetImage(),
            width: 16,
            height: 16,
            fit: BoxFit.fill,
          ),
        );

        if (unit?.isNotEmpty == true) {
          suffixDefault = Container(
            margin: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            //   // border: Border.all(color: Colors.blue),
            // ),
            child: NText(
              unit ?? "",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: fontColor737373,
            ),
          );
        }

        final suffixNew = suffix ?? suffixDefault;
        var suffixWidthNew = suffixWidth + clearWidth;
        return Container(
          width: suffixWidthNew,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder(
                valueListenable: hasFocusVN,
                builder: (context, isFocus, child) {
                  if (clearWidth > 0 && isFocus) {
                    return GestureDetector(
                      onTap: onClear ??
                          () {
                            controllerNew.text = "";
                            onChanged("");
                          },
                      child: Container(
                        padding: const EdgeInsets.only(top: 1, right: 8),
                        // decoration: BoxDecoration(
                        //   color: Colors.transparent,
                        //   // border: Border.all(color: Colors.blue),
                        // ),
                        child: Icon(
                          Icons.cancel,
                          size: clearWidth - 8,
                          color: const Color(0xffB3B3B3),
                        ),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
              suffixNew,
            ],
          ),
        );
      },
      suffixIconConstraints: BoxConstraints(
        maxHeight: suffixHeight,
        minHeight: suffixHeight,
        maxWidth: suffixWidth + clearWidth,
        minWidth: suffixWidth + clearWidth,
      ),
      onChanged: (String value) {
        if (value.trim().isEmpty) {
          DLog.d("$this onChanged 不能为空");
          return;
        }
        onChanged(value.trim());
      },
      inputFormatters: inputFormatters,
    );

    if (readOnly) {
      child = Container(
        decoration: BoxDecoration(
          border: Border.all(color: readOnlyBorderColor, width: 0.5),
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: child,
        ),
      );
    }

    if (name.isEmpty) {
      return child;
    }

    return Row(
      children: [
        NText(
          name,
          color: fontColor737373,
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}

/// 封装输入框组件
class _NTextField extends StatefulWidget {
  const _NTextField({
    super.key,
    this.enabled,
    this.value = "",
    this.controller,
    this.contextMenuBuilder,
    this.onTap,
    this.onTapOutside,
    required this.onChanged,
    this.onSubmitted,
    this.style = const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: fontColor),
    this.textAlign = TextAlign.left,
    this.textAlignVertical,
    this.readOnly = false,
    this.hintText = "请输入",
    this.hintStyle = const TextStyle(fontSize: 16, color: fontColorB3B3B3),
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.autofocus = false,
    this.obscureText = false,
    this.contentPadding,
    this.fillColor = bgColor,
    this.focusColor = Colors.white,
    this.radius = 4,
    this.borderWidth = 1,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.prefixIconBuilder,
    this.suffixIconBuilder,
    this.suffixIconConstraints,
    this.suffix,
    this.focusNode,
    this.hasFocusVN,
    this.isCollapsed,
    this.inputFormatters,
    this.debounceMilliseconds = 0,
  });

  final bool? enabled;

  final String? value;

  /// 控制器
  final TextEditingController? controller;
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  final VoidCallback? onTap;
  final TapRegionCallback? onTapOutside;

  /// 改变回调
  final ValueChanged<String> onChanged;

  /// 一般是键盘回车键/确定回调
  final ValueChanged<String>? onSubmitted;

  final TextStyle? style;

  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;

  final bool readOnly;

  /// 是否密文
  final bool? obscureText;

  /// 提示语
  final String? hintText;

  final TextStyle? hintStyle;

  /// 最小行数
  final int? minLines;

  /// 最大行数
  final int? maxLines;

  /// 最大字数
  final int? maxLength;

  /// 键盘类型
  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final bool autofocus;

  /// 内容边距
  final EdgeInsetsGeometry? contentPadding;

  /// 填充颜色
  final Color? fillColor;

  /// 聚焦颜色
  final Color? focusColor;

  /// 圆角
  final double radius;

  /// 边框线
  final double borderWidth;

  /// 输入框焦点
  final FocusNode? focusNode;

  final ValueNotifier<bool>? hasFocusVN;

  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;

  /// 左边组件构造器
  final Widget Function(bool isFocus)? prefixIconBuilder;

  /// 右边组件构造器
  final Widget? Function(bool isFocus)? suffixIconBuilder;

  final BoxConstraints? suffixIconConstraints;

  final Widget? suffix;

  // true代表取消textfield最小高度限制
  final bool? isCollapsed;

  final List<TextInputFormatter>? inputFormatters;

  /// 防抖间距
  final int debounceMilliseconds;

  @override
  _NTextFieldState createState() => _NTextFieldState();
}

class _NTextFieldState extends State<_NTextField> {
  late final controller = widget.controller ?? TextEditingController(text: widget.value);

  final current = ValueNotifier("");

  late var _focusNode = widget.focusNode ?? FocusNode();

  late var hasFocusVN = widget.hasFocusVN ?? ValueNotifier<bool>(false);

  bool isCloseEye = true;

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    // _focusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    hasFocusVN.value = _focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(covariant _NTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled != oldWidget.enabled ||
        widget.value != oldWidget.value ||
        widget.controller != oldWidget.controller ||
        widget.readOnly != oldWidget.readOnly ||
        widget.minLines != oldWidget.minLines ||
        widget.maxLines != oldWidget.maxLines ||
        widget.fillColor != oldWidget.fillColor ||
        widget.focusColor != oldWidget.focusColor ||
        widget.contentPadding != oldWidget.contentPadding ||
        widget.isCollapsed != oldWidget.isCollapsed ||
        widget.inputFormatters != oldWidget.inputFormatters ||
        widget.focusNode != oldWidget.focusNode ||
        widget.hasFocusVN != oldWidget.hasFocusVN ||
        widget.suffixIconBuilder != oldWidget.suffixIconBuilder) {
      controller.text = widget.value ?? "";
      hasFocusVN = widget.hasFocusVN ?? ValueNotifier<bool>(false);

      _focusNode.removeListener(_onFocusChange);
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChange);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // textEditingController.text = widget.value ?? "";
    // if (controller.text.contains("-")) {
    //   YLog.d("__>> $this ${[controller.hashCode, controller.text]} ");
    // }

    final prefixIcon = widget.prefixIconBuilder?.call(hasFocusVN.value);

    final suffixIcon = widget.suffixIconBuilder?.call(hasFocusVN.value);

    final counter =
        widget.maxLength != null ? controller.buildInputDecorationCounter(maxLength: widget.maxLength!) : null;

    return TextField(
      enabled: widget.enabled,
      contextMenuBuilder: widget.contextMenuBuilder ??
          (_, editableTextState) => AdaptiveTextSelectionToolbar.editableText(
                editableTextState: editableTextState,
              ),
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      readOnly: widget.readOnly,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      cursorColor: primary,
      focusNode: _focusNode,
      controller: controller,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      // onChanged: widget.onChanged,
      onChanged: widget.onChanged,
      onSubmitted: (val) {
        widget.onSubmitted?.call(val);
        controller.clear();
      },
      obscureText: widget.obscureText != null ? widget.obscureText! : isCloseEye,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      style: widget.style,
      inputFormatters: widget.inputFormatters ??
          [
            if (widget.maxLength != null) LengthLimitingTextInputFormatter(widget.maxLength!),
          ],
      decoration: InputDecoration(
        filled: true,
        // fillColor: widget.focusColor,
        fillColor: widget.fillColor,
        focusColor: widget.focusColor,
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: widget.border ?? InputBorder.none,
        enabledBorder: widget.readOnly
            ? null
            : widget.enabledBorder ?? buildEnabledBorder(radus: widget.radius, borderWidth: widget.borderWidth),
        focusedBorder: widget.readOnly
            ? null
            : widget.focusedBorder ?? buildFocusedBorder(radus: widget.radius, borderWidth: widget.borderWidth),
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        isCollapsed: widget.isCollapsed ?? false,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixIconConstraints: widget.suffixIconConstraints,
        suffix: widget.suffix,
        counter: counter,
      ),
    );
  }

  buildEnabledBorder({double radus = 4, double borderWidth = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(radus), //边角
      ),
      borderSide: BorderSide(
        color: lineColor, //边线颜色为白色
        width: borderWidth, //边线宽度为1
      ),
    );
  }

  buildFocusedBorder({double radus = 4, double borderWidth = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radus)), //边角
      borderSide: BorderSide(
        color: primary, //边框颜色为白色
        width: borderWidth, //宽度为1
      ),
    );
  }
}
