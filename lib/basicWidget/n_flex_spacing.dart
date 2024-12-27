//
//  FlexSpacing.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/5 16:19.
//  Copyright © 2024/9/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 分割
class NFlexSeparated extends Flex {
  NFlexSeparated({
    super.key,
    required super.direction,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    super.clipBehavior,
    required List<Widget> children,
    required Widget Function(int index) separatedBuilder,
  }) : super(
          children: [
            ...children.map((e) {
              final i = children.indexOf(e);
              final hasSeparated = e != children.last;

              return Flex(
                direction: direction,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  e,
                  if (hasSeparated) separatedBuilder(i),
                ],
              );
            }),
          ],
        );

  factory NFlexSeparated.spacing({
    Key? key,
    required Axis direction,
    Clip clipBehavior,
    CrossAxisAlignment crossAxisAlignment,
    MainAxisAlignment mainAxisAlignment,
    MainAxisSize mainAxisSize,
    TextBaseline? textBaseline,
    TextDirection? textDirection,
    VerticalDirection verticalDirection,
    double spacing,
    required List<Widget> children,
  }) = _NFlexSpacing;
}

class _NFlexSpacing extends NFlexSeparated {
  _NFlexSpacing({
    super.key,
    required super.direction,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    super.clipBehavior,
    required List<Widget> children,
    double spacing = 0,
  }) : super(
          children: children,
          separatedBuilder: (i) => SizedBox(
            width: direction == Axis.horizontal ? spacing : 0,
            height: direction == Axis.vertical ? spacing : 0,
          ),
        );
}
