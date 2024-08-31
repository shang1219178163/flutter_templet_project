//
//  //
//  NSearchTheme.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/31 07:09.
//  Copyright © 2024/8/31 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 搜索输入框
class NSearchTextFieldThemeData
    extends ThemeExtension<NSearchTextFieldThemeData> {
  /// 搜索输入框
  const NSearchTextFieldThemeData({
    this.placeholder = "请输入",
    this.style,
    this.placeholderStyle,
    this.primary,
    this.fontColor,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.padding = const EdgeInsetsDirectional.fromSTEB(3.8, 8, 5, 8),
    this.autofocus,
  });

  /// 默认请输入
  final String? placeholder;

  /// 字体样式
  final TextStyle? style;

  /// 占位符样式
  final TextStyle? placeholderStyle;

  /// 主题色
  final Color? primary;

  /// 默认浅灰色
  final Color? fontColor;

  /// 默认浅灰色
  final Color? backgroundColor;

  /// 默认圆角 4px
  final BorderRadius? borderRadius;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 是否默认弹起键盘
  final bool? autofocus;

  @override
  ThemeExtension<NSearchTextFieldThemeData> copyWith({
    String? placeholder,
    TextStyle? style,
    TextStyle? placeholderStyle,
    Color? primary,
    Color? fontColor,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    bool? autofocus,
  }) =>
      NSearchTextFieldThemeData(
        placeholder: placeholder ?? this.placeholder,
        style: style ?? this.style,
        placeholderStyle: placeholderStyle ?? this.placeholderStyle,
        primary: primary ?? this.primary,
        fontColor: fontColor ?? this.fontColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        borderRadius: borderRadius ?? this.borderRadius,
        padding: padding ?? this.padding,
        autofocus: autofocus ?? this.autofocus,
      );

  @override
  ThemeExtension<NSearchTextFieldThemeData> lerp(
    covariant NSearchTextFieldThemeData? other,
    double t,
  ) =>
      NSearchTextFieldThemeData(
        style: TextStyle.lerp(style, other?.style, t),
        placeholderStyle:
            TextStyle.lerp(placeholderStyle, other?.placeholderStyle, t),
        primary: Color.lerp(primary, other?.primary, t),
        fontColor: Color.lerp(fontColor, other?.fontColor, t),
        backgroundColor: Color.lerp(backgroundColor, other?.backgroundColor, t),
        borderRadius: BorderRadius.lerp(borderRadius, other?.borderRadius, t),
        padding: EdgeInsetsGeometry.lerp(padding, other?.padding, t),
      );
}
