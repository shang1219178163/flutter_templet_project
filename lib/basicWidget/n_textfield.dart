import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/editable_text_ext.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

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
//           ? 'assets/images/icon_eye_close.png'
//           : 'assets/images/icon_eye_open.png',
//       width: 20,
//       height: 20,
//       color: isFocus ? primary : null,
//     ),
//   ),
// ),

/// 封装输入框组件
class NTextField extends StatefulWidget {
  NTextField({
    super.key,
    this.value = "",
    this.controller,
    this.contextMenuBuilder,
    this.onTap,
    this.onTapOutside,
    required this.onChanged,
    this.onSubmitted,
    this.style = const TextStyle(fontSize: 16),
    this.textAlign = TextAlign.left,
    this.readOnly = false,
    this.hintText = "请输入",
    this.hintStyle = const TextStyle(fontSize: 16, color: Color(0xff737373)),
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.autofocus = false,
    this.obscureText = false,
    this.contentPadding,
    this.fillColor = AppColor.bgColor,
    this.focusColor = Colors.white,
    this.radius = 4,
    this.borderWidth = 1,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.prefixIconBuilder,
    this.prefix,
    this.prefixIconConstraints,
    this.suffixIconBuilder,
    this.suffix,
    this.suffixIconConstraints,
    this.focusNode,
    this.hasFocusVN,
    this.isCollapsed,
    this.inputFormatters,
    this.scrollPhysics = const ClampingScrollPhysics(), //避免触发下拉刷新
    this.hidePrefix = true,
    this.hideSuffix = true,
    this.hideClear = true,
    this.prefixImage,
    this.suffixImage,
    this.decorationBuilder,
  });

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

  final BoxConstraints? prefixIconConstraints;

  final Widget? prefix;

  final BoxConstraints? suffixIconConstraints;

  final Widget? suffix;

  // true代表取消textfield最小高度限制
  final bool? isCollapsed;

  final List<TextInputFormatter>? inputFormatters;
  final ScrollPhysics? scrollPhysics;

  final bool hidePrefix;

  final bool hideSuffix;

  final bool hideClear;

  final AssetImage? prefixImage;
  final AssetImage? suffixImage;

  final InputDecoration Function(InputDecoration decoration)? decorationBuilder;

  @override
  _NTextFieldState createState() => _NTextFieldState();
}

class _NTextFieldState extends State<NTextField> {
  late final textEditingController = widget.controller ?? TextEditingController(text: widget.value);

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
  void didUpdateWidget(covariant NTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value ||
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
      textEditingController.text = widget.value ?? "";
      hasFocusVN = widget.hasFocusVN ?? ValueNotifier<bool>(false);

      _focusNode.removeListener(_onFocusChange);
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChange);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefixImage = Image(
      image: widget.prefixImage ?? AssetImage("assets/images/icon_search.png"),
      width: 16,
      height: 16,
      fit: BoxFit.fill,
    );
    final prefixPadding = const EdgeInsets.only(left: 8, right: 4);
    BoxConstraints? prefixIconConstraints = widget.prefixIconConstraints ??
        BoxConstraints(
          maxHeight: prefixImage.height!,
          maxWidth: prefixImage.width! + prefixPadding.left + prefixPadding.right,
        );

    final suffixImage = Image(
      image: widget.suffixImage ?? AssetImage("assets/images/icon_scan.png"),
      width: 16,
      height: 16,
      color: context.primaryColor,
      fit: BoxFit.fill,
    );
    final suffixPadding = const EdgeInsets.only(left: 4, right: 8);
    BoxConstraints? suffixIconConstraints = widget.suffixIconConstraints ??
        BoxConstraints(
          maxHeight: suffixImage.height!,
          maxWidth: suffixImage.width! + suffixPadding.left + suffixPadding.right,
        );

    Widget? prefixIcon =
        widget.prefixIconBuilder?.call(hasFocusVN.value) ?? Padding(padding: prefixPadding, child: prefixImage);

    Widget? suffixIcon =
        widget.suffixIconBuilder?.call(hasFocusVN.value) ?? Padding(padding: suffixPadding, child: suffixImage);

    Widget? defaultSuffix = GestureDetector(
      onTap: () {
        textEditingController.clear();
        widget.onChanged("");
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Icon(Icons.cancel, size: 15, color: Colors.black38),
      ),
    );

    final counter = textEditingController.buildInputDecorationCounter(maxLength: widget.maxLength);

    if (widget.hidePrefix) {
      prefixIcon = null;
      prefixIconConstraints = null;
    }

    if (widget.hideSuffix) {
      suffixIcon = null;
      suffixIconConstraints = null;
    }

    if (widget.hideClear) {
      defaultSuffix = null;
    }

    final decoration = InputDecoration(
      filled: true,
      fillColor: widget.fillColor,
      focusColor: widget.focusColor,
      contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      border: widget.border ?? InputBorder.none,
      enabledBorder: widget.readOnly ? null : widget.enabledBorder ?? buildEnabledBorder(radius: widget.radius),
      focusedBorder: widget.readOnly
          ? null
          : widget.focusedBorder ?? buildEnabledBorder(color: context.primaryColor, radius: widget.radius),
      hintText: widget.hintText,
      hintStyle: widget.hintStyle,
      isCollapsed: widget.isCollapsed ?? false,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefix: widget.prefix,
      prefixIconConstraints: prefixIconConstraints,
      suffix: widget.suffix ?? defaultSuffix,
      suffixIconConstraints: suffixIconConstraints,
      counter: counter,
    );

    return TextField(
      controller: textEditingController,
      contextMenuBuilder: widget.contextMenuBuilder ??
          (_, editableTextState) => AdaptiveTextSelectionToolbar.editableText(
                editableTextState: editableTextState,
              ),
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      textAlign: widget.textAlign,
      readOnly: widget.readOnly,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      cursorColor: context.primaryColor,
      focusNode: _focusNode,
      // focusNode: focusChanged,
      onChanged: widget.onChanged,
      onSubmitted: (val) {
        widget.onSubmitted?.call(val);
        textEditingController.clear();
      },
      obscureText: widget.obscureText != null ? widget.obscureText! : isCloseEye,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      style: widget.style ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.fontColor,
          ),
      inputFormatters: widget.inputFormatters ??
          [
            if (widget.maxLength != null) LengthLimitingTextInputFormatter(widget.maxLength!),
          ],
      scrollPhysics: widget.scrollPhysics,
      decoration: widget.decorationBuilder?.call(decoration) ?? decoration,
    );
  }

  buildEnabledBorder({Color color = AppColor.lineColor, double radius = 4}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(
        color: color, //边线颜色为白色
        width: 1, //边线宽度为1
      ),
    );
  }
}
