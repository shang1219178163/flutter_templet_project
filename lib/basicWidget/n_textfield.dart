

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/uti/color_util.dart';


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

class NTextfield extends StatefulWidget {

  NTextfield({
    Key? key,
    this.title,
    this.value = "",
    required this.onChanged,
    required this.onSubmitted,
    this.hintText = "请输入",
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText,
    this.contentPadding,
    this.focusNode,
    this.fillColor = bgColor,
    this.focusColor = Colors.white,
    this.radius = 4,
    this.enabledBorder,
    this.focusedBorder,
    this.prefixIconBuilder,
    this.suffixIconBuilder,
  }) : super(key: key);

  final String? title;

  final String? value;

  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;

  final bool? obscureText;

  final String? hintText;
  final int? minLines;
  final int? maxLines;

  final TextInputType? keyboardType;

  final EdgeInsetsGeometry? contentPadding;

  final FocusNode? focusNode;

  final Color? fillColor;
  final Color? focusColor;
  final double radius;

  InputBorder? enabledBorder;
  InputBorder? focusedBorder;

  Widget Function(bool isFocus)? prefixIconBuilder;
  Widget Function(bool isFocus, bool isCloseEye,)? suffixIconBuilder;

  @override
  _NTextfieldState createState() => _NTextfieldState();
}

class _NTextfieldState extends State<NTextfield> {
  final textEditingController = TextEditingController();

  final current = ValueNotifier("");

  late final _focusNode = widget.focusNode ?? FocusNode();

  final hasFocusVN = ValueNotifier<bool>(false);

  bool isCloseEye = true;


  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    textEditingController.value = TextEditingValue(
        text: widget.value ?? "",
        selection: TextSelection.fromPosition(
            TextPosition(
                affinity: TextAffinity.downstream,
                offset: (widget.value ?? "").length
            )
        )
    );
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
      cursorColor: context.primaryColor,
      focusNode: _focusNode,
      controller: textEditingController,
      // focusNode: focusChanged,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      obscureText:  widget.obscureText != null ? widget.obscureText! : isCloseEye,
      keyboardType: widget.keyboardType,
      // autofocus: !widget.obscureText,
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
        hintStyle: TextStyle(fontSize: 16, color: fontColor[10]),
        prefixIcon: widget.prefixIconBuilder == null? null : ValueListenableBuilder<bool>(
          valueListenable: hasFocusVN,
          builder: (_, isFocus, child) {

            return widget.prefixIconBuilder?.call(isFocus) ?? SizedBox();
          }
        ),
        suffixIcon: widget.suffixIconBuilder == null? null : ValueListenableBuilder<bool>(
          valueListenable: hasFocusVN,
          builder: (_, isFocus, child) {

            return IconButton(
              focusColor: context.primaryColor,
              icon: widget.suffixIconBuilder?.call(isFocus, isCloseEye,) ?? SizedBox(),
              onPressed: () {
                isCloseEye = !isCloseEye;
                setState(() {});
              },
            );
          }
        ),
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
        color: context.primaryColor, //边框颜色为白色
        width: 1, //宽度为1
      ),
    );
  }
}