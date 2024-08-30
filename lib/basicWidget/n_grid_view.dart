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

/// GridView 效果,动态宽度
class NGridViewOne extends StatelessWidget {
  const NGridViewOne({
    super.key,
    this.numPerRow = 4,
    this.spacing = 9,
    this.runSpacing = 16,
    this.radius = 4,
    this.itemHeight,
    required this.children,
    this.onAdd,
    this.onDelete,
  });

  ///每页列数
  final int numPerRow;

  /// 子项间距
  final double spacing;

  /// 子项垂直间距
  final double runSpacing;

  /// 子项高度
  final double? itemHeight;

  /// 子项圆角
  final double radius;

  /// 子项数组
  final List<Widget> children;

  final Widget? onAdd;

  final Widget? onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = constraints.maxWidth;
        final itemWidth = (maxWidth - spacing * (numPerRow - 1)) / numPerRow;

        // final spacing = (constraints.maxWidth - itemWidth * numPerRow) /
        //     (numPerRow - 1).truncateToDouble().toInt();

        Widget buildItem({required Widget child}) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: child,
            ),
          );
        }

        return Wrap(
          spacing: spacing, //适配折叠屏
          runSpacing: runSpacing,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: [
            ...children.map((e) {
              return buildItem(child: e);
              // return ClipRRect(
              //   borderRadius: BorderRadius.circular(radius),
              //   child: SizedBox(
              //     width: itemWidth,
              //     height: itemWidth,
              //     child: e,
              //   ),
              // );
            }).toList(),
            onAdd != null ? buildItem(child: onAdd!) : const SizedBox(),
            onDelete != null ? buildItem(child: onDelete!) : const SizedBox(),
          ],
        );
      },
    );
  }
}
