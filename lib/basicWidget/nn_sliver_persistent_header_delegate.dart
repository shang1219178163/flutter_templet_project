//
//  NnSliverPersistentHeaderDelegate.dart
//  flutter_templet_project
//
//  Created by shang on 2/3/23 6:05 PM.
//  Copyright © 2/3/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NNSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {

  final double min;
  final double max;

  final Widget child;

  const NNSliverPersistentHeaderDelegate({
  	Key? key,
    required this.min,
    required this.max,
    required this.child,
  });


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  //SliverPersistentHeader最大高度
  @override
  double get maxExtent => max;

  //SliverPersistentHeader最小高度
  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant NNSliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}