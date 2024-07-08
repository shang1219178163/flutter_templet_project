//
//  NScrollviewGroup.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/8 16:29.
//  Copyright © 2024/7/8 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 基于 SliverList 的分组组件
class NSliverListSection<T> extends StatelessWidget {
  const NSliverListSection({
    super.key,
    required this.model,
    this.headerDelegate,
    required this.itembuilder,
  });
  final NSliverListSectionModel<T> model;

  final SliverPersistentHeaderDelegate? headerDelegate;

  final NullableIndexedWidgetBuilder itembuilder;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: headerDelegate ?? _HeaderDelegate(title: model.name),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            itembuilder,
            childCount: model.items.length,
          ),
        ),
      ],
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HeaderDelegate({required this.title});
  final String title;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.grey,
      padding: const EdgeInsets.only(left: 20),
      child: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return title != oldDelegate.title;
  }
}

/// NSliverListSection 对应的数据模型
class NSliverListSectionModel<T> {
  final String name;
  final List<T> items;

  const NSliverListSectionModel({required this.name, this.items = const []});
}
