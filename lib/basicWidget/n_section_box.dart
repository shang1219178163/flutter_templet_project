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
    super.key,
    this.title = '',
    this.text,
    this.style = const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.alignment = Alignment.centerLeft,
    this.divider,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.hide = false,
    this.decoration,
    required this.child,
  });

  final String title;
  final Text? text;
  final TextStyle? style;
  final EdgeInsets padding;
  final Alignment alignment;

  final Widget? divider;

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  final bool hide;

  final Decoration? decoration;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (hide) {
      return SizedBox();
    }
    final content = Column(
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
          child: text ?? Text(title, style: style),
        ),
        Padding(
          padding: padding,
          child: child,
        ),
        divider ?? Divider(height: 0.5),
      ],
    );
    if (decoration == null) {
      return content;
    }
    return DecoratedBox(
      decoration: decoration!,
      child: content,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(DiagnosticsProperty<Alignment>('alignment', alignment));
    properties.add(EnumProperty<MainAxisAlignment>('mainAxisAlignment', mainAxisAlignment));
    properties.add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize));
    properties.add(EnumProperty<CrossAxisAlignment>('crossAxisAlignment', crossAxisAlignment));
    properties.add(DiagnosticsProperty<bool>('hide', hide));
    properties.add(DiagnosticsProperty<Decoration?>('decoration', decoration));
  }
}
