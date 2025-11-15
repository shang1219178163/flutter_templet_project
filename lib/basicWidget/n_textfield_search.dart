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
import 'package:flutter_templet_project/basicWidget/theme/n_search_theme.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

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
class NSearchTextField extends StatelessWidget {
  const NSearchTextField({
    super.key,
    this.controller,
    this.style,
    this.placeholder = "请输入",
    this.placeholderStyle,
    this.textAlign = TextAlign.start,
    this.suffixMode = OverlayVisibilityMode.editing,
    this.decoration,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.padding = const EdgeInsets.symmetric(vertical: 7),
    this.debounceDuration,
    required this.onChanged,
    this.onSubmitted,
    this.onSuffixTap,
    this.suffix,
    this.focusNode,
    this.onFocus,
    this.autofocus = false,
    this.enabled = true,
    this.hidePrefixIcon = false,
  });

  final TextEditingController? controller;

  /// 默认请输入
  final String placeholder;

  final TextStyle? style;

  final TextStyle? placeholderStyle;

  final TextAlign textAlign;

  final OverlayVisibilityMode suffixMode;

  final BoxDecoration? decoration;

  /// 默认浅灰色
  final Color? backgroundColor;

  /// 是否隐藏 PrefixIcon
  final bool hidePrefixIcon;

  final Widget? suffix;

  /// 默认圆角 4px
  final BorderRadius? borderRadius;

  final EdgeInsetsGeometry padding;

  /// 防抖延迟
  final Duration? debounceDuration;

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<NSearchTextFieldThemeData>();

    final controllerNew = controller ?? TextEditingController();
    onClear() {
      controllerNew.clear();
      onChanged("");
    }

    final placeholderStyleNew = placeholderStyle ??
        theme?.placeholderStyle ??
        const TextStyle(
          fontSize: 15,
          color: Color(0xffB3B3B3),
          fontWeight: FontWeight.w400,
          height: 1.37,
        );

    final styleNew = style ??
        theme?.style ??
        TextStyle(
          fontSize: 15,
          color: AppColor.fontColor,
          fontWeight: FontWeight.w400,
        );

    final prefix = Padding(
      padding: const EdgeInsets.only(left: 8, right: 6),
      child: Image(
        image: const AssetImage("assets/images/icon_search.png"),
        width: 16,
        height: 16,
        color: AppColor.fontColor,
      ),
    );

    final suffixNew = suffix ??
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 8),
          child: Icon(Icons.cancel, color: Color(0xff999999), size: 16),
        );

    final decorationNew = decoration ??
        BoxDecoration(
          color: backgroundColor ?? theme?.backgroundColor,
          borderRadius: borderRadius ?? theme?.borderRadius,
        );

    return DefaultSelectionStyle(
      cursorColor: context.primaryColor,
      child: CupertinoTextField(
        focusNode: focusNode,
        controller: controllerNew,
        padding: padding,
        placeholder: placeholder,
        placeholderStyle: placeholderStyleNew,
        style: styleNew,
        textAlign: textAlign,
        textAlignVertical: TextAlignVertical.center,
        suffixMode: suffixMode,
        clearButtonMode: OverlayVisibilityMode.editing,
        decoration: decorationNew,
        prefix: prefix,
        suffix: InkWell(
          onTap: onSuffixTap ?? onClear,
          child: suffixNew,
        ),
        onChanged: debounceDuration == null ? onChanged : (v) => onChanged.debounce(v, duration: debounceDuration!),
        onSubmitted: onChanged,
        enabled: enabled,
        autofocus: autofocus,
      ),
    );

    // if (textAlign == TextAlign.start) {
    //   return DefaultSelectionStyle(
    //     cursorColor: context.primaryColor,
    //     child: CupertinoSearchTextField(
    //       controller: controllerNew,
    //       placeholder: placeholder ?? theme?.placeholder,
    //       padding: padding ?? theme?.padding ?? EdgeInsets.zero,
    //       placeholderStyle: placeholderStyleNew,
    //       style: styleNew,
    //       decoration: decorationNew,
    //       prefixIcon: prefixImage,
    //       prefixInsets: prefixPadding,
    //       suffixIcon: suffix,
    //       suffixInsets: suffixPadding,
    //       onSuffixTap: onSuffixTap ?? onClear,
    //       onChanged: onChanged,
    //       onSubmitted: onSubmitted ?? onChanged,
    //       enabled: enabled,
    //       autofocus: autofocus ?? false,
    //     ),
    //   );
    // }
  }
}

/// 搜索框 + 取消按钮
class NSearchBar extends StatelessWidget {
  const NSearchBar({
    super.key,
    this.placeholder = "搜索",
    this.decoration,
    required this.onChanged,
    this.onCancel,
  });

  final String placeholder;
  final BoxDecoration? decoration;

  final ValueChanged<String> onChanged;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final textfield = NSearchTextField(
      autofocus: true,
      backgroundColor: Colors.white,
      decoration: decoration,
      placeholder: placeholder,
      onChanged: onChanged,
      hidePrefixIcon: false,
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
              color: AppColor.fontColor,
            ),
          ),
        ),
      ],
    );
  }
}
