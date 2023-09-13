import 'package:flutter/material.dart';


class NText extends StatelessWidget {

  const NText(this.data,{
  	Key? key,
  	// required this.data,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.backgroundColor,
    this.letterSpacing,
    this.wordSpacing,
    this.decoration = TextDecoration.none,
  }) : super(key: key);

  final String data;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  final Color? backgroundColor;
  final double? letterSpacing;
  final double? wordSpacing;

  final TextDecoration? decoration;


  @override
  Widget build(BuildContext context) {
    final softWrap = (maxLines != null && maxLines! > 1);

    return Text(data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: TextStyle(
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
}
