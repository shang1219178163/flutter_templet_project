//
//  NBoderText.dart
//  projects
//
//  Created by shang on 2026/4/28 14:49.
//  Copyright © 2026/4/28 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 带描边的字符串显示
class NBoderText extends StatelessWidget {
  const NBoderText({
    super.key,
    required this.text,
    this.fontSize = 20,
    this.fontFamily = 'DDINPRO',
    this.fontStyle,
    this.fontWeight = FontWeight.w700,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textColor = const Color(0xFFFFD876),
    this.textBorderColor = const Color(0xFFDD9700),
    this.textStyleBuilder,
    this.boderTextStyleBuilder,
  });

  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final FontStyle? fontStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? textColor;
  final Color? textBorderColor;
  final TextStyle? Function(TextStyle style)? textStyleBuilder;
  final TextStyle? Function(TextStyle style)? boderTextStyleBuilder;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      height: 0.9,
      // backgroundColor: Colors.green,
    );

    final textStyleNew = textStyleBuilder?.call(textStyle) ?? textStyle;

    if (textBorderColor == null) {
      return Text(
        text,
        style: textStyleNew,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final boderTextStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      height: 0.9,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = textBorderColor!,
    );

    final boderTextStyleNew = boderTextStyleBuilder?.call(boderTextStyle) ?? boderTextStyle;
    return Stack(
      children: [
        Text(
          text,
          style: boderTextStyleNew,
          maxLines: maxLines,
          overflow: overflow,
        ),
        Text(
          text,
          style: textStyleNew,
          maxLines: maxLines,
          overflow: overflow,
        ),
      ],
    );
  }
}
