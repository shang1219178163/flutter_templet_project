//
//  NSearchTextfield.dart
//  yl_health_app
//
//  Created by shang on 2023/8/22 15:46.
//  Copyright © 2023/8/22 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/Debounce.dart';
import 'package:flutter_templet_project/util/color_util.dart';

// ```
// Expanded(
//   child: Container(
//     height: 36.h,
//     // margin: EdgeInsets.all(16),
//     child: NSearchTextfield(
//       controller: searchEditingController,
//       placeholder: searchPlaceholder,
//       backgroundColor: you color,
//       borderRadius: BorderRadius.all(Radius.circular(4)),
//       cb: (value) {
//         // debugPrint(value);
//         searchText = value;
//         requestPaticentList(isTeam: isTeam, searchText: searchText);
//       },
//     ),
//   ),
// ),
// ```

/// 搜索框封装
class NSearchTextField extends StatefulWidget {
  const NSearchTextField({
    Key? key,
    this.title,
    this.controller,
    this.placeholder = "请输入",
    this.placeholderStyle,
    this.decoration,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.padding = const EdgeInsets.all(0),
    this.milliseconds = 500,
    required this.onChanged,
    this.onSubmitted,
    this.onSuffixTap,
    this.focusNode,
    this.onFocus,
    this.autofocus = false,
    this.enabled = true,
  }) : super(key: key);

  final String? title;

  final TextEditingController? controller;

  /// 默认请输入
  final String placeholder;

  final TextStyle? placeholderStyle;

  final BoxDecoration? decoration;

  /// 默认浅灰色
  final Color? backgroundColor;

  /// 默认圆角 4px
  final BorderRadius? borderRadius;

  final EdgeInsetsGeometry padding;

  /// 默认0.5秒延迟
  final int? milliseconds;

  /// 回调
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSuffixTap;

  /// 输入框焦点
  final FocusNode? focusNode;

  /// 焦点回调
  final ValueChanged<bool>? onFocus;

  /// 是否自动聚焦
  final bool autofocus;

  /// 是否可以响应键盘
  final bool enabled;

  @override
  NSearchTextFieldState createState() => NSearchTextFieldState();
}

class NSearchTextFieldState extends State<NSearchTextField> {
  late final _debounce =
      Debounce(delay: Duration(milliseconds: widget.milliseconds ?? 500));

  late final _controller = widget.controller ?? TextEditingController();

  late final _focusNode = widget.focusNode ?? FocusNode();

  final hasFocusVN = ValueNotifier<bool>(false);

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
    debugPrint("hasFocusVN.value: ${hasFocusVN.value}");
    widget.onFocus?.call(hasFocusVN.value);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultSelectionStyle(
      cursorColor: context.primaryColor,
      child: CupertinoTextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        padding: widget.padding ?? EdgeInsets.zero,
        placeholder: widget.placeholder,
        placeholderStyle: widget.placeholderStyle ??
            const TextStyle(
              fontSize: 14,
              color: Color(0xFF737373),
              fontWeight: FontWeight.w400,
            ),
        textAlignVertical: TextAlignVertical.center,
        clearButtonMode: OverlayVisibilityMode.editing,
        prefix: Padding(
          padding: const EdgeInsets.only(left: 15, top: 9, bottom: 9, right: 9),
          child: Image(
            image: "icon_search.png".toAssetImage(),
            width: 14,
            height: 14,
          ),
        ),
        decoration: widget.decoration ??
            BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
        // suffix: InkWell(
        //   onTap: onSuffixTap ?? (){
        //     controller.clear();
        //     onChanged.call("");
        //   },
        //   child: const Padding(
        //     padding: EdgeInsets.only(
        //       left: 6,
        //       top: 10,
        //       bottom: 10,
        //       right: 12,
        //     ),
        //     child: Icon(
        //       Icons.cancel,
        //       color: Color(0xff999999),
        //       size: 16,
        //     ),
        //   ),
        // ),
        onChanged: widget.onChanged,
        onSubmitted: widget.onChanged,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
      ),
    );
  }
}

class NSearchBar extends StatelessWidget {
  const NSearchBar({
    super.key,
    this.placeholder = "搜索",
    required this.onChanged,
    this.onCancel,
  });

  final String placeholder;
  final ValueChanged<String> onChanged;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final textfield = NSearchTextField(
      autofocus: true,
      backgroundColor: Colors.white,
      placeholder: placeholder,
      onChanged: onChanged,
    );
    if (onCancel == null) {
      return textfield;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: textfield,
        ),
        InkWell(
          onTap: onCancel,
          child: Container(
            height: 36,
            padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8),
            alignment: Alignment.center,
            child: const NText(
              '取消',
              fontSize: 15,
              color: fontColor,
            ),
          ),
        ),
      ],
    );
  }
}
