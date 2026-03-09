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
    this.scrollDirection = Axis.vertical,
    this.crossAxisCount = 4,
    this.crossAxisSpacing = 9,
    this.mainAxisSpacing = 16,
    this.cacheExtent,
    this.visibleHeightRatio,
    this.radius = 4,
    this.itemWidth,
    this.itemHeight,
    required this.children,
    this.addItem,
    this.deleteItem,
    this.itemBuilder,
  });

  final Axis scrollDirection;

  /// 每行列数
  final int crossAxisCount;

  /// 子项间距
  final double crossAxisSpacing;

  /// 子项垂直间距
  final double mainAxisSpacing;

  final double? cacheExtent;

  /// 可视高度: 宽度的倍数
  final double? visibleHeightRatio;

  /// 子项宽度, 为空则自动利用最大宽度
  final double? itemWidth;

  /// 子项高度
  final double? itemHeight;

  /// 子项圆角
  final double radius;

  /// 子项数组
  final List<Widget> children;

  /// 自定义添加
  final Widget? addItem;

  /// 自定义删除
  final Widget? deleteItem;

  /// 子项自定义
  final Widget Function(Widget? item, double itemWidth)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.truncateToDouble();
        var spacingNew = crossAxisSpacing;
        var itemWidthNew = (maxWidth - spacingNew * (crossAxisCount - 1)) / crossAxisCount;
        if (itemWidth != null && itemWidth! > 0 == true) {
          itemWidthNew = itemWidth!.truncateToDouble();
          spacingNew = (maxWidth - itemWidthNew * crossAxisCount) / (crossAxisCount - 1).truncateToDouble();
        }

        Widget buildItem({required Widget child}) {
          return itemBuilder?.call(child, itemWidthNew) ??
              ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: SizedBox(
                  width: itemWidthNew,
                  height: itemHeight,
                  child: child,
                ),
              );
        }

        if (visibleHeightRatio == null) {
          return Wrap(
            spacing: spacingNew, //适配折叠屏
            runSpacing: mainAxisSpacing,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: [
              ...children.map((e) => buildItem(child: e)).toList(),
              if (addItem != null) buildItem(child: addItem!),
              if (deleteItem != null) buildItem(child: deleteItem!),
            ],
          );
        }

        return Container(
          width: maxWidth,
          height: maxWidth * visibleHeightRatio!,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            removeLeft: true,
            removeRight: true,
            child: GridView.custom(
              physics: ClampingScrollPhysics(),
              scrollDirection: scrollDirection,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                (context, i) {
                  final e = children[i];
                  return buildItem(child: e);
                },
                childCount: children.length,
              ),
              cacheExtent: cacheExtent,
            ),
          ),
        );
      },
    );
  }
}
