//
//  NnSliverPersistentHeaderDelegate.dart
//  flutter_templet_project
//
//  Created by shang on 2/3/23 6:05 PM.
//  Copyright © 2/3/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 自定义 SliverPersistentHeaderDelegate
class NSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  NSliverPersistentHeaderDelegate({
    this.min = 48,
    this.max = 80,
    required this.builder,
  });

  /// 默认 48 是 TabBar 的默认高度
  double min;
  double max;

  Widget Function(BuildContext context, double offset, bool overlapsContent)
      builder;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  //SliverPersistentHeader最大高度
  @override
  double get maxExtent => max;

  //SliverPersistentHeader最小高度
  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant NSliverPersistentHeaderDelegate oldDelegate) {
    return min != oldDelegate.min ||
        max != oldDelegate.max ||
        builder != oldDelegate.builder;
  }
}

/// 自定义 SliverPersistentHeader
class NSliverPersistentHeaderBuilder extends SliverPersistentHeader {
  NSliverPersistentHeaderBuilder({
    Key? key,
    double max = 48,
    double min = 48,
    bool pinned = false,
    bool floating = false,
    required Widget Function(
            BuildContext context, double shrinkOffset, bool overlapsContent)
        builder,
  }) : super(
          key: key,
          pinned: pinned,
          floating: floating,
          delegate: NSliverPersistentHeaderDelegate(
            max: max,
            min: min,
            builder: builder,
          ),
        );
}
