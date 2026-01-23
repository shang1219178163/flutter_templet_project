//
//  NListViewSeparated.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/21 18:59.
//  Copyright © 2026/1/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 带表头表尾的列表
class NListViewSeparated extends ListView {
  NListViewSeparated({
    super.key,
    Widget? header,
    Widget? footer,
    required IndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    required int itemCount,
    super.controller,
    super.physics,
    super.padding,
    super.shrinkWrap,
    super.reverse,
    super.primary,
    super.cacheExtent,
    super.keyboardDismissBehavior,
  }) : super.builder(
          itemCount: _calcItemCount(itemCount, header, footer),
          itemBuilder: (context, index) {
            final hasHeader = header != null;
            final hasFooter = footer != null;
            if (hasHeader && index == 0) {
              return header;
            }
            if (hasFooter && index == _calcItemCount(itemCount, header, footer) - 1) {
              return footer;
            }

            final itemIndex = index - (hasHeader ? 1 : 0);
            if (itemIndex.isOdd) {
              return separatorBuilder(context, itemIndex ~/ 2);
            }
            return itemBuilder(context, itemIndex ~/ 2);
          },
        );

  static int _calcItemCount(
    int itemCount,
    Widget? header,
    Widget? footer,
  ) {
    final core = itemCount == 0 ? 0 : itemCount * 2 - 1;
    return core + (header != null ? 1 : 0) + (footer != null ? 1 : 0);
  }
}
