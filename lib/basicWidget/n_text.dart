import 'package:flutter/material.dart';


class NText extends StatelessWidget {

  const NText({
  	Key? key,
  	required this.data,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.fontSize,
    this.fontColor,
    this.fontWeight,
    this.backgroundColor,
    this.letterSpacing,
    this.wordSpacing,
  }) : super(key: key);

  final String data;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? fontColor;

  final Color? backgroundColor;
  final double? letterSpacing;
  final double? wordSpacing;

  @override
  Widget build(BuildContext context) {
    return Text(data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: fontColor,
        backgroundColor: backgroundColor,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      ),
    );
  }
}
