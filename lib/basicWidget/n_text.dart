import 'package:flutter/material.dart';

class NText extends StatelessWidget {
  const NText(
    this.data, {
    super.key,
    this.textAlign,
    this.maxLines = 1000,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap,
    this.style,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.backgroundColor,
    this.letterSpacing,
    this.wordSpacing,
    this.decoration = TextDecoration.none,
  });

  final String data;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  final Color? backgroundColor;
  final double? letterSpacing;
  final double? wordSpacing;

  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    // final softWrap = (maxLines != null && maxLines! > 1);

    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: style ??
          TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            backgroundColor: backgroundColor,
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            decoration: decoration,
          ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('data', data));
    properties.add(EnumProperty<TextAlign?>('textAlign', textAlign));
    properties.add(IntProperty('maxLines', maxLines));
    properties.add(EnumProperty<TextOverflow?>('overflow', overflow));
    properties.add(DiagnosticsProperty<bool?>('softWrap', softWrap));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(DoubleProperty('fontSize', fontSize));
    properties.add(DiagnosticsProperty<FontWeight?>('fontWeight', fontWeight));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('letterSpacing', letterSpacing));
    properties.add(DoubleProperty('wordSpacing', wordSpacing));
    properties.add(DiagnosticsProperty<TextDecoration?>('decoration', decoration));
  }
}
