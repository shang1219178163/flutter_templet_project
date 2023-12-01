

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';


// Padding(
//   padding: EdgeInsets.all(16),
//   child: NTextfield(
//     value: "NTextfield",
//     obscureText: true,
//     onChanged: (String value) {
//       debugPrint("NTextfield: ${value.toString()}");
//     },
//     prefixIconBuilder: (isFocus) {
//       final color = isFocus ? primary : null;
//       return Icon(Icons.account_circle, color: color,);
//     },
//     suffixIconBuilder: (isFocus, isCloseEye) => Image.asset(
//       isCloseEye
//           ? 'images/icon_eye_close.png'
//           : 'images/icon_eye_open.png',
//       width: 20,
//       height: 20,
//       color: isFocus ? primary : null,
//     ),
//   ),
// ),

/// 封装输入框组件
class NTextfield extends StatefulWidget {
  NTextfield({
    Key? key,
    this.title,
    // this.value = "",
    this.controller,
    required this.onChanged,
    required this.onSubmitted,
    this.hintText = "请输入",
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.textAlignVertical = TextAlignVertical.center,
    this.obscureText,
    this.contentPadding,
    this.fillColor = bgColor,
    this.focusColor = Colors.white,
    this.radius = 4,
    this.enabledBorder,
    this.focusedBorder,
    this.prefixIconBuilder,
    this.suffixIconBuilder,
    this.focusNode,
    this.isCollapsed,
  }) : super(key: key);

  final String? title;

  /// 控制器
  final TextEditingController? controller;

  /// 改变回调
  final ValueChanged<String> onChanged;

  /// 一般是键盘回车键/确定回调
  final ValueChanged<String>? onSubmitted;

  /// 是否密文
  final bool? obscureText;

  /// 提示语
  final String? hintText;

  /// 最小行数
  final int? minLines;

  /// 最大行数
  final int? maxLines;

  /// 键盘类型
  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final TextAlignVertical textAlignVertical;

  /// 内容边距
  final EdgeInsetsGeometry? contentPadding;

  /// 填充颜色
  final Color? fillColor;

  /// 聚焦颜色
  final Color? focusColor;

  /// 圆角
  final double radius;

  /// 输入框焦点
  final FocusNode? focusNode;

  InputBorder? enabledBorder;
  InputBorder? focusedBorder;

  /// 左边组件构造器
  Widget Function(bool isFocus)? prefixIconBuilder;

  /// 右边组件构造器
  Widget Function(
      bool isFocus,
      bool isCloseEye,
      )? suffixIconBuilder;

  // true代表取消textfield最小高度限制
  final bool? isCollapsed;

  @override
  _NTextfieldState createState() => _NTextfieldState();
}

class _NTextfieldState extends State<NTextfield> {
  late final textEditingController = widget.controller ?? TextEditingController();

  final current = ValueNotifier("");

  late final _focusNode = widget.focusNode ?? FocusNode();

  final hasFocusVN = ValueNotifier<bool>(false);

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
  Widget build(BuildContext context) {
    return TextField(
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      cursorColor: primaryColor,
      focusNode: _focusNode,
      controller: textEditingController,
      // focusNode: focusChanged,
      onChanged: widget.onChanged,
      onSubmitted: (val) {
        widget.onSubmitted?.call(val);
        textEditingController.clear();
      },
      obscureText: widget.obscureText != null ? widget.obscureText! : isCloseEye,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      // autofocus: !widget.obscureText,
      textAlignVertical: widget.textAlignVertical,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: fontColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.focusColor,
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: InputBorder.none,
        enabledBorder: widget.enabledBorder ?? buildEnabledBorder(radus: widget.radius),
        focusedBorder: widget.focusedBorder ?? buildFocusedBorder(radus: widget.radius),
        hintText: widget.hintText,
        isCollapsed: widget.isCollapsed ?? false,
        hintStyle: TextStyle(fontSize: 16, color: fontColor[10]),
        prefixIcon: widget.prefixIconBuilder == null
            ? null
            : ValueListenableBuilder<bool>(
            valueListenable: hasFocusVN,
            builder: (_, isFocus, child) {
              return widget.prefixIconBuilder?.call(isFocus) ?? SizedBox();
            }),
        suffixIcon: widget.suffixIconBuilder == null
            ? null
            : ValueListenableBuilder<bool>(
            valueListenable: hasFocusVN,
            builder: (_, isFocus, child) {
              return IconButton(
                focusColor: primaryColor,
                icon: widget.suffixIconBuilder?.call(
                  isFocus,
                  isCloseEye,
                ) ??
                    SizedBox(),
                onPressed: () {
                  isCloseEye = !isCloseEye;
                  setState(() {});
                },
              );
            }),
      ),
    );
  }

  buildEnabledBorder({double radus = 4}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(radus), //边角
      ),
      borderSide: BorderSide(
        color: lineColor, //边线颜色为白色
        width: 1, //边线宽度为1
      ),
    );
  }

  buildFocusedBorder({double radus = 4}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radus)), //边角
      borderSide: BorderSide(
        color: primaryColor, //边框颜色为白色
        width: 1, //宽度为1
      ),
    );
  }
}