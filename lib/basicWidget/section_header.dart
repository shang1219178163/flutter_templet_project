import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget{

  const SectionHeader({
    Key? key,
    this.title = '',
    this.text,
    this.style = const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    this.padding = const EdgeInsets.all(8),
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  final String title;
  final Text? text;
  final TextStyle? style;
  final EdgeInsets padding;
  final Alignment alignment;

  SectionHeader.h1({
    Key? key,
    String title = '',
    Text? text,
    TextStyle? style = const TextStyle(fontSize: 36.0, fontWeight: FontWeight.w500),
    EdgeInsets padding = const EdgeInsets.all(8),
    Alignment alignment = Alignment.centerLeft,
  }) : this(
      key: key,
      title: title,
      text: text,
      padding: padding,
      alignment: alignment,
      style: style
    );

  SectionHeader.h2({
    Key? key,
    String title = '',
    Text? text,
    TextStyle? style = const TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500),
    EdgeInsets padding = const EdgeInsets.all(8),
    Alignment alignment = Alignment.centerLeft,
  }) : this(
    key: key,
    title: title,
    text: text,
    padding: padding,
    alignment: alignment,
    style: style
  );

  SectionHeader.h3({
    Key? key,
    String title = '',
    Text? text,
    TextStyle? style = const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
    EdgeInsets padding = const EdgeInsets.all(8),
    Alignment alignment = Alignment.centerLeft,
  }) : this(
    key: key,
    title: title,
    text: text,
    padding: padding,
    alignment: alignment,
    style: style
  );

  SectionHeader.h4({
    Key? key,
    String title = '',
    Text? text,
    TextStyle? style = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
    EdgeInsets padding = const EdgeInsets.all(8),
    Alignment alignment = Alignment.centerLeft,
  }) : this(
    key: key,
    title: title,
    text: text,
    padding: padding,
    alignment: alignment,
    style: style
  );

  SectionHeader.h5({
    Key? key,
    String title = '',
    Text? text,
    TextStyle? style = const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    EdgeInsets padding = const EdgeInsets.all(8),
    Alignment alignment = Alignment.centerLeft,
  }) : this(
    key: key,
    title: title,
    text: text,
    padding: padding,
    alignment: alignment,
    style: style
  );

  SectionHeader.h6({
    Key? key,
    String title = '',
    Text? text,
    TextStyle? style = const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
    EdgeInsets padding = const EdgeInsets.all(8),
    Alignment alignment = Alignment.centerLeft,
  }) : this(
    key: key,
    title: title,
    text: text,
    padding: padding,
    alignment: alignment,
    style: style
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: text ?? Text(
          title,
          style: style,
        ),
      ),
    );
  }

}