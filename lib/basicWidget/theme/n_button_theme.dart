import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 确定按钮 MyButton
class NButtonTheme extends ThemeExtension<NButtonTheme> {
  /// 确定按钮
  const NButtonTheme({
    this.primary,
    this.height,
    this.margin,
    this.padding,
    this.gradient,
    this.gradientDisable,
    this.boxShadow,
    this.boxShadowDisable,
    this.border,
    this.borderDisable,
    this.borderRadius,
    this.borderRadiusDisable,
    this.textStyle,
    this.textStyleDisable,
  });

  final Color? primary;

  /// 点击区域高
  final double? height;

  /// 点击区域外边距
  final EdgeInsets? margin;

  /// 点击区域内边距
  final EdgeInsets? padding;

  /// 点击区域背景颜色(渐进)
  final Gradient? gradient;
  final Gradient? gradientDisable;

  /// 阴影
  final List<BoxShadow>? boxShadow;

  /// 阴影
  final List<BoxShadow>? boxShadowDisable;
  final Border? border;
  final Border? borderDisable;

  final BorderRadius? borderRadius;
  final BorderRadius? borderRadiusDisable;

  /// 文字颜色
  final TextStyle? textStyle;
  final TextStyle? textStyleDisable;

  @override
  ThemeExtension<NButtonTheme> copyWith({
    Color? primary,
    double? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Gradient? gradient,
    Gradient? gradientDisable,
    List<BoxShadow>? boxShadow,
    List<BoxShadow>? boxShadowDisable,
    BorderRadius? borderRadius,
    BorderRadius? borderRadiusDisable,
    Border? border,
    Border? borderDisable,
  }) =>
      NButtonTheme(
        primary: primary ?? this.primary,
        height: height ?? this.height,
        margin: margin ?? this.margin,
        padding: padding ?? this.padding,
        gradient: gradient ?? this.gradient,
        gradientDisable: gradientDisable ?? this.gradientDisable,
        boxShadow: boxShadow ?? this.boxShadow,
        boxShadowDisable: boxShadowDisable ?? this.boxShadowDisable,
        borderRadius: borderRadius ?? this.borderRadius,
        borderRadiusDisable: borderRadiusDisable ?? this.borderRadiusDisable,
        border: border ?? this.border,
        borderDisable: borderDisable ?? this.borderDisable,
      );

  @override
  ThemeExtension<NButtonTheme> lerp(
    covariant NButtonTheme? other,
    double t,
  ) =>
      NButtonTheme(
        primary: Color.lerp(primary, other?.primary, t),
        margin: EdgeInsets.lerp(margin, other?.margin, t),
        padding: EdgeInsets.lerp(padding, other?.padding, t),
        gradient: Gradient.lerp(gradient, other?.gradient, t),
        gradientDisable:
            Gradient.lerp(gradientDisable, other?.gradientDisable, t),
        borderRadius: BorderRadius.lerp(borderRadius, other?.borderRadius, t),
        borderRadiusDisable: BorderRadius.lerp(
            borderRadiusDisable, other?.borderRadiusDisable, t),
        border: Border.lerp(border, other?.border, t),
        borderDisable: Border.lerp(borderDisable, other?.borderDisable, t),
      );
}

/// 确定按钮
class YlButtonConfirmTheme extends ThemeExtension<YlButtonConfirmTheme> {
  /// 确定按钮
  const YlButtonConfirmTheme({
    this.primary,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding,
    this.gradient,
    this.boxShadow,
  });

  /// 主题色
  final Color? primary;

  /// 背景色
  final Color? backgroundColor;

  /// 默认圆角 4px
  final BorderRadius? borderRadius;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 背景渐变色
  final Gradient? gradient;

  /// 阴影
  final List<BoxShadow>? boxShadow;

  @override
  ThemeExtension<YlButtonConfirmTheme> copyWith({
    Color? primary,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
  }) =>
      YlButtonConfirmTheme(
        primary: primary ?? this.primary,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        borderRadius: borderRadius ?? this.borderRadius,
        padding: padding ?? this.padding,
        gradient: gradient ?? this.gradient,
        boxShadow: boxShadow ?? this.boxShadow,
      );

  @override
  ThemeExtension<YlButtonConfirmTheme> lerp(
    covariant YlButtonConfirmTheme? other,
    double t,
  ) =>
      YlButtonConfirmTheme(
        primary: Color.lerp(primary, other?.primary, t),
        backgroundColor: Color.lerp(backgroundColor, other?.backgroundColor, t),
        borderRadius: BorderRadius.lerp(borderRadius, other?.borderRadius, t),
        padding: EdgeInsetsGeometry.lerp(padding, other?.padding, t),
        gradient: Gradient.lerp(gradient, other?.gradient, t),
      );
}

/// 取消按钮
class YlButtonCancelTheme extends ThemeExtension<YlButtonCancelTheme> {
  /// 取消按钮
  const YlButtonCancelTheme({
    this.primary,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  /// 主题色
  final Color? primary;

  /// 背景色
  final Color? backgroundColor;

  /// 默认圆角 4px
  final BorderRadius? borderRadius;

  @override
  ThemeExtension<YlButtonCancelTheme> copyWith({
    Color? primary,
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) =>
      YlButtonCancelTheme(
        primary: primary ?? this.primary,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        borderRadius: borderRadius ?? this.borderRadius,
      );

  @override
  ThemeExtension<YlButtonCancelTheme> lerp(
    covariant YlButtonCancelTheme? other,
    double t,
  ) =>
      YlButtonCancelTheme(
        primary: Color.lerp(primary, other?.primary, t),
        backgroundColor: Color.lerp(backgroundColor, other?.backgroundColor, t),
        borderRadius: BorderRadius.lerp(borderRadius, other?.borderRadius, t),
      );
}

/// 自定义 BottomButton
class YlBottomButtonTheme extends ThemeExtension<YlBottomButtonTheme> {
  /// 自定义 BottomButton
  const YlBottomButtonTheme({
    this.header,
    this.footer,
  });

  /// 顶部
  final Widget? header;

  /// 底部
  final Widget? footer;

  @override
  ThemeExtension<YlBottomButtonTheme> copyWith({
    Widget? header,
    Widget? footer,
  }) =>
      YlBottomButtonTheme(
        header: header ?? this.header,
        footer: footer ?? this.footer,
      );

  @override
  ThemeExtension<YlBottomButtonTheme> lerp(
    covariant YlBottomButtonTheme? other,
    double t,
  ) =>
      YlBottomButtonTheme();
}
