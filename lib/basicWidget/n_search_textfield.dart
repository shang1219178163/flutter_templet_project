//
//  NSearchTextfield.dart
//  yl_health_app
//
//  Created by shang on 2023/8/22 15:46.
//  Copyright © 2023/8/22 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/Debounce.dart';


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
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.padding = const EdgeInsetsDirectional.fromSTEB(3.8, 8, 5, 8),
    this.milliseconds = 500,
    required this.onChanged,
    this.onSubmitted,
    this.onSuffixTap,
    this.focusNode,
    this.onFocus,
    this.enabled = true,
  }) : super(key: key);

  final String? title;

  final TextEditingController? controller;
  /// 默认请输入
  final String placeholder;

  final TextStyle? placeholderStyle;

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
  /// 是否可以响应键盘
  final bool enabled;

  @override
  NSearchTextFieldState createState() => NSearchTextFieldState();
}

class NSearchTextFieldState extends State<NSearchTextField> {

  late final _debounce = Debounce(delay: Duration(milliseconds: widget.milliseconds ?? 500));

  late final  _controller = widget.controller ?? TextEditingController();

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
    return buildSearch(
      focusNode: _focusNode,
      controller: widget.controller ?? _controller,
      placeholder: widget.placeholder,
      placeholderStyle: widget.placeholderStyle,
      backgroundColor: widget.backgroundColor,
      borderRadius: widget.borderRadius,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onSuffixTap: widget.onSuffixTap,
      padding: widget.padding,
      enabled: widget.enabled,
    );
  }

  buildSearch({
    FocusNode? focusNode,
    required TextEditingController controller,
    required String placeholder,
    TextStyle? placeholderStyle,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    required ValueChanged<String> onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onSuffixTap,
    EdgeInsetsGeometry? padding,
    bool enabled = true,
  }) {
    return CupertinoTextField(
      focusNode: focusNode,
      controller: controller,
      padding: padding ?? EdgeInsets.zero,
      placeholder: placeholder,
      placeholderStyle: placeholderStyle ?? const TextStyle(
        fontSize: 14,
        color: Color(0xFF737373),
        fontWeight: FontWeight.w400,
      ),
      textAlignVertical: TextAlignVertical.center,
      clearButtonMode: OverlayVisibilityMode.editing,
      prefix: Padding(
        padding: const EdgeInsets.only(
            left: 15,
            top: 9,
            bottom: 9,
            right: 9
        ),
        child: Image(
          image: "icon_search.png".toAssetImage(),
          width: 14,
          height: 14,
        ),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
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
      onChanged: (String value) {
        _debounce(() {
          // debugPrint('searchText: $value');
          onChanged.call(value);
        });
      },
      onSubmitted: onSubmitted ?? (String value) {
        _debounce(() {
          // debugPrint('onSubmitted: $value');
          onChanged.call(value);
        });
      },
      enabled: enabled,
    );
  }
}

//   buildSearch({
//     FocusNode? focusNode,
//     required TextEditingController controller,
//     required String placeholder,
//     TextStyle? placeholderStyle,
//     Color? backgroundColor,
//     BorderRadius? borderRadius,
//     required ValueChanged<String> onChanged,
//     ValueChanged<String>? onSubmitted,
//     VoidCallback? onSuffixTap,
//     EdgeInsetsGeometry? padding,
//     bool? enabled,
//   }) {
//     return CupertinoSearchTextField(
//       focusNode: focusNode,
//       controller: controller,
//       placeholder: placeholder,
//       backgroundColor: backgroundColor,
//       borderRadius: borderRadius,
//       padding: padding ?? EdgeInsets.zero,
//       placeholderStyle: placeholderStyle ?? const TextStyle(
//         fontSize: 14,
//         color: Color(0xFF737373),
//         fontWeight: FontWeight.w400,
//       ),
//       prefixIcon: Image(
//         image: "icon_search_black.png".toAssetImage(),
//         width: 14,
//         height: 14,
//       ),
//       prefixInsets: const EdgeInsets.only(
//         left: 16,
//         top: 9,
//         bottom: 9,
//         right: 9
//       ),
//       suffixIcon: const Icon(
//         Icons.cancel,
//         color: Color(0xff999999),
//         size: 16,
//       ),
//       suffixInsets: const EdgeInsets.only(
//         left: 6,
//         top: 10,
//         bottom: 10,
//         right: 12,
//       ),
//       onChanged: (String value) {
//         _debounce(() {
//           // debugPrint('searchText: $value');
//           onChanged.call(value);
//         });
//       },
//       onSubmitted: onSubmitted ?? (String value) {
//         _debounce(() {
//           // debugPrint('onSubmitted: $value');
//           onChanged.call(value);
//         });
//       },
//       onSuffixTap: onSuffixTap ?? (){
//         controller.clear();
//         onChanged.call("");
//       },
//       enabled: enabled,
//     );
//   }
// }
