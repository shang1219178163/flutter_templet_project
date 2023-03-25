//
//  NnSliverPersistentHeaderDelegate.dart
//  flutter_templet_project
//
//  Created by shang on 2/3/23 6:05 PM.
//  Copyright © 2/3/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';


class NNSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const NNSliverPersistentHeaderDelegate({
    Key? key,
    this.min = 60,
    this.max = 80,
    required this.builder,
  });

  final double min;
  final double max;

  final Widget Function(BuildContext context, double offset, bool overlapsContent) builder;

  
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
    return this.min != oldDelegate.min || this.max != oldDelegate.max || this.builder != oldDelegate.builder;
  }
}

/// SliverPersistentHeader
class NNSliverPersistentHeader extends StatelessWidget {

  const NNSliverPersistentHeader({
  	Key? key,
  	this.title,
    this.pinned = true,
    this.floating = false,
    this.min = 60,
    this.max = 80,
    required this.builder,
  }) : super(key: key);

  final String? title;

  final bool pinned;

  final bool floating;

  final double min;

  final double max;

  final Widget Function(BuildContext context, double offset, bool overlapsContent) builder;


  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: NNSliverPersistentHeaderDelegate(
        min: min,
        max: max,
        builder: builder,
      ),
    );
  }
}

