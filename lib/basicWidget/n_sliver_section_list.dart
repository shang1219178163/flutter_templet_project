//
//  NScrollviewGroup.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/8 16:29.
//  Copyright © 2024/7/8 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_section.dart';

/// 分组列表
class NSliverSectionList<T> extends StatelessWidget {
  const NSliverSectionList({
    super.key,
    required this.items,
    required this.sectionBuilder,
    this.header,
    this.footer,
  });

  final List<NSliverSectionModel<T>> items;

  final Widget Function(NSliverSectionModel<T> model) sectionBuilder;

  final Widget? header;

  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: header ?? SizedBox(),
          ),
          ...items.map(sectionBuilder),
          SliverToBoxAdapter(
            child: footer ?? SizedBox(),
          ),
        ],
      ),
    );
  }
}
