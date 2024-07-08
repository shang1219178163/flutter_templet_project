//
//  TextStyleExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/14 14:49.
//  Copyright © 2023/1/14 shang. All rights reserved.
//
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';

extension TextStyleExt on TextStyle {
  /// 自定义 copy
  TextStyle copy({
    bool inherit = true,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    ui.TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    List<ui.Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
    List<ui.FontVariation>? fontVariations,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }) {
    return TextStyle(
      inherit: inherit,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordSpacing: wordSpacing ?? this.wordSpacing,
      textBaseline: textBaseline ?? this.textBaseline,
      height: height ?? this.height,
      leadingDistribution: leadingDistribution ?? this.leadingDistribution,
      locale: locale ?? this.locale,
      foreground: foreground ?? this.foreground,
      background: background ?? this.background,
      shadows: shadows ?? this.shadows,
      fontFeatures: fontFeatures ?? this.fontFeatures,
      fontVariations: fontVariations ?? this.fontVariations,
      decoration: decoration ?? this.decoration,
      decorationColor: decorationColor ?? this.decorationColor,
      decorationStyle: decorationStyle ?? this.decorationStyle,
      decorationThickness: decorationThickness ?? this.decorationThickness,
      debugLabel: debugLabel ?? this.debugLabel,
      fontFamily: fontFamily ?? this.fontFamily,
      fontFamilyFallback: fontFamilyFallback ?? this.fontFamilyFallback,
      package: package,
      overflow: overflow ?? this.overflow,
    );
  }

  /// h1
  TextStyle get h1 {
    return copy(
      fontSize: 32,
      fontWeight: FontWeight.w500,
    );
  }

  /// h2
  TextStyle get h2 {
    return copy(
      fontSize: 24,
      fontWeight: FontWeight.w500,
    );
  }

  /// h3
  TextStyle get h3 {
    return copy(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );
  }

  /// h4
  TextStyle get h4 {
    return copy(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  /// h5
  TextStyle get h5 {
    return copy(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  /// h6
  TextStyle get h6 {
    return copy(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }
}

extension ParagraphStyleExt on ParagraphStyle {
  ui.ParagraphStyle fromText(Text text) {
    var textStyle = text.style;

    var paragraphStyle = ui.ParagraphStyle(
      textAlign: text.textAlign ?? TextAlign.start,
      textDirection: text.textDirection ?? TextDirection.ltr,
      maxLines: text.maxLines,
      textHeightBehavior: text.textHeightBehavior ?? TextHeightBehavior(),
      fontFamily: textStyle?.fontFamily,
      fontSize: textStyle?.fontSize,
      height: textStyle?.height,
      fontWeight: textStyle?.fontWeight,
      fontStyle: textStyle?.fontStyle,
      locale: textStyle?.locale,
      ellipsis: '...',
    );
    return paragraphStyle;
  }
}
