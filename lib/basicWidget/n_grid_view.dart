//
//  NGridView.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/5/15 15:57.
//  Copyright © 2024/5/15 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// GridView 效果
class NGridView extends StatelessWidget {
  const NGridView({
    super.key,
    this.numPerRow = 5,
    this.itemWidth = 54,
    this.runSpacing = 16,
    required this.children,
  });

  /// 每行列数
  final int numPerRow;

  /// 子项宽度
  final double itemWidth;

  /// 垂直间距
  final double runSpacing;

  /// 子项
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final spacing = (constraints.maxWidth - itemWidth * numPerRow) /
            (numPerRow - 1).truncateToDouble().toInt();

        return Wrap(
          spacing: spacing, //适配折叠屏
          runSpacing: runSpacing,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: children,
        );
      },
    );
  }
}
