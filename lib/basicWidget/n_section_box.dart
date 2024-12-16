//
//  SectionHeader.dart
//  flutter_templet_project
//
//  Created by shang on 4/3/23 2:18 PM.
//  Copyright © 4/3/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NSectionBox extends StatelessWidget {
  const NSectionBox({
    Key? key,
    this.title = '',
    this.text,
    this.style = const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.alignment = Alignment.centerLeft,
    this.divider,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.start,
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
            child: text ?? Text(title, style: style),
          ),
        ),
        Padding(
          padding: padding,
          child: child,
        ),
        divider ?? Divider(height: 0.5),
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
