//
//  NScrollviewGroup.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/8 16:29.
//  Copyright © 2024/7/8 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';

/// 基于 SliverList 的分组组件
class NSliverSection<T> extends StatefulWidget {
  const NSliverSection({
    super.key,
    required this.model,
    this.isExpand = true,
    this.headerHeight = 40,
    this.headerBuilder,
    required this.itembuilder,
  });

  /// section 模型
  final NSliverSectionModel<T> model;

  /// 展开/折叠
  final bool isExpand;

  /// header 高度
  final double headerHeight;

  /// header 构建器
  final Widget Function(
      BuildContext context, double offset, bool overlapsContent)? headerBuilder;

  /// 子项构建器
  final NullableIndexedWidgetBuilder itembuilder;

  @override
  State<NSliverSection<T>> createState() => _NSliverSectionState<T>();
}

class _NSliverSectionState<T> extends State<NSliverSection<T>> {
  late bool isExpand = widget.isExpand;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        NSliverPersistentHeaderBuilder(
          pinned: true,
          min: widget.headerHeight,
          max: widget.headerHeight,
          builder: (context, double shrinkOffset, bool overlapsContent) {
            final header = widget.headerBuilder
                    ?.call(context, shrinkOffset, overlapsContent) ??
                Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.black.withOpacity(0.15),
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    widget.model.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
            return InkWell(
              onTap: () {
                isExpand = !isExpand;
                setState(() {});
              },
              child: header,
            );
          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            widget.itembuilder,
            childCount: isExpand ? widget.model.items.length : 0,
          ),
        ),
      ],
    );
  }
}

/// NSliverListSection 对应的数据模型
class NSliverSectionModel<T> {
  NSliverSectionModel({
    required this.name,
    this.items = const [],
  });

  final String name;
  final List<T> items;
}
