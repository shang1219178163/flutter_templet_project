//
//  SectionHeader.dart
//  flutter_templet_project
//
//  Created by shang on 4/3/23 2:18 PM.
//  Copyright © 4/3/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class Header extends StatelessWidget{

  const Header({
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

  Header.h1({
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

  Header.h2({
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

  Header.h3({
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

  Header.h4({
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

  Header.h5({
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

  Header.h6({
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


class SectionHeader extends StatelessWidget{

  const SectionHeader({
    Key? key,
    this.title = '',
    this.text,
    this.style = const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    this.padding = const EdgeInsets.all(8),
    this.alignment = Alignment.centerLeft,
    this.divider,
    required this.child,
  }) : super(key: key);

  final String title;
  final Text? text;
  final TextStyle? style;
  final EdgeInsets padding;
  final Alignment alignment;

  final Widget? divider;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        divider ?? Divider(),
        Header.h5(title: title, text: text, style: style, padding: padding, alignment: alignment,),
        child,
      ],
    );
  }

}

