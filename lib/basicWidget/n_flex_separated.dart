//
//  FlexSpacing.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/5 16:19.
//  Copyright © 2024/9/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 带分隔的 Flex 组件
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
    double spacing = 0,
    Widget Function(int index)? separatedBuilder,
  }) : super(
          children: [
            ...children
                .map((e) {
                  final i = children.indexOf(e);
                  final hasSeparated = e != children.last;
                  // final separated = separatedBuilder?.call(i);
                  // DLog.d("NFlexSeparated: ${e.runtimeType}, $hasSeparated");

                  return <Widget>[
                    e,
                    if (hasSeparated)
                      separatedBuilder?.call(i) ??
                          SizedBox(
                            width: direction == Axis.horizontal ? spacing : 0,
                            height: direction == Axis.vertical ? spacing : 0,
                          ),
                  ];
                })
                .toList()
                .flatMap(),
          ],
        );
}

extension _ListNewExt<E> on List<List<Widget>> {
  /// 二维数组降维一维数组
  List<E> flatMap() {
    final items = this as List<List<E>>;
    var list = <E>[];
    for (final e in items) {
      list.addAll(e);
    }
    return list;
  }
}
