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
  /// h1
  TextStyle get h1 {
    return copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w500,
    );
  }

  /// h2
  TextStyle get h2 {
    return copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w500,
    );
  }

  /// h3
  TextStyle get h3 {
    return copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );
  }

  /// h4
  TextStyle get h4 {
    return copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  /// h5
  TextStyle get h5 {
    return copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  /// h6
  TextStyle get h6 {
    return copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }
}

extension ParagraphStyleExt on ParagraphStyle {
  /// Text 转 ParagraphStyle
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
