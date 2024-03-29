//
//  SectionHeader.dart
//  flutter_templet_project
//
//  Created by shang on 4/3/23 2:18 PM.
//  Copyright © 4/3/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';


class NSectionHeader extends StatelessWidget{

  const NSectionHeader({
    Key? key,
    this.title = '',
    this.text,
    this.style = const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    this.padding = const EdgeInsets.all(16),
    this.alignment = Alignment.centerLeft,
    this.divider,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.addSliverToBoxAdapter = false,
    required this.child,
  }) : super(key: key);

  final String title;
  final Text? text;
  final TextStyle? style;
  final EdgeInsets padding;
  final Alignment alignment;

  final Widget? divider;

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  final bool addSliverToBoxAdapter;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: padding.top,
            left: padding.left,
            right: padding.right,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: style,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: padding.top,
            bottom: padding.bottom,
            left: padding.left,
            right: padding.right,
          ),
          child: child,
        ),
        divider ?? Divider(),
      ],
    );
    if (addSliverToBoxAdapter) {
      content = SliverToBoxAdapter(
        child: content,
      );
    }
    return content;
  }

}

