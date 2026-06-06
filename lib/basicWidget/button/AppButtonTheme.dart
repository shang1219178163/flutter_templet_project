//
//  YlAppButtonTheme.dart
//  yl_design
//
//  Created by shang on 2026/06/06 11:38.
//  Copyright © 2026/06/06 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 自定义
class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  /// 自定义
  AppButtonTheme({
    this.fgColor,
    this.bgColor,
    this.fgColorDisabled,
    this.bgColorDisabled,
    this.outlinedColor,
    this.outlinedColorDisabled,
  });

  ///
  final Color? fgColor;

  ///
  final Color? bgColor;

  ///
  final Color? fgColorDisabled;

  ///
  final Color? bgColorDisabled;

  ///
  final Color? outlinedColor;

  ///
  final Color? outlinedColorDisabled;

  @override
  ThemeExtension<AppButtonTheme> copyWith({
    Color? fgColor,
    Color? bgColor,
    Color? fgDisabledColor,
    Color? bgDisabledColor,
    Color? outlinedColor,
    Color? outlinedDisabledColor,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    Clip? clipBehavior,
    FocusNode? focusNode,
    bool? isSemanticButton,
  }) =>
      AppButtonTheme(
        fgColor: fgColor ?? this.fgColor,
        bgColor: bgColor ?? this.bgColor,
        fgColorDisabled: fgDisabledColor ?? this.fgColorDisabled,
        bgColorDisabled: bgDisabledColor ?? this.bgColorDisabled,
        outlinedColor: outlinedColor ?? this.outlinedColor,
        outlinedColorDisabled: outlinedDisabledColor ?? this.outlinedColorDisabled,
      );

  @override
  ThemeExtension<AppButtonTheme> lerp(
    covariant AppButtonTheme? other,
    double t,
  ) =>
      AppButtonTheme(
        fgColor: Color.lerp(fgColor, other?.fgColor, t),
        bgColor: Color.lerp(bgColor, other?.bgColor, t),
        fgColorDisabled: Color.lerp(fgColorDisabled, other?.fgColorDisabled, t),
        bgColorDisabled: Color.lerp(bgColorDisabled, other?.bgColorDisabled, t),
        outlinedColor: Color.lerp(outlinedColor, other?.outlinedColor, t),
        outlinedColorDisabled: Color.lerp(outlinedColorDisabled, other?.outlinedColorDisabled, t),
      );
}
