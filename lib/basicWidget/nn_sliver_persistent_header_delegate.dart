//
//  NnSliverPersistentHeaderDelegate.dart
//  flutter_templet_project
//
//  Created by shang on 2/3/23 6:05 PM.
//  Copyright © 2/3/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

typedef NNSliverPersistentHeaderBuilder = Widget Function(BuildContext context, double shrinkOffset, bool overlapsContent);

class NNSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const NNSliverPersistentHeaderDelegate({
    Key? key,
    required this.min,
    required this.max,
    required this.builder,
  });

  final double min;
  final double max;

  final NNSliverPersistentHeaderBuilder builder;

  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  //SliverPersistentHeader最大高度
  @override
  double get maxExtent => max;

  //SliverPersistentHeader最小高度
  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant NNSliverPersistentHeaderDelegate oldDelegate) {
    return this.builder != oldDelegate.builder || this.min != oldDelegate.min || this.max != oldDelegate.max;
  }
}