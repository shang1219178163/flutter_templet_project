

import 'package:flutter/cupertino.dart';

class SliverPersistentHeaderBuilder extends SliverPersistentHeaderDelegate {
  final double max;
  final double min;
  final Widget Function(BuildContext context, double offset, bool overlapsContent) builder;

  SliverPersistentHeaderBuilder({
    this.max = 120,
    this.min = 80,
    required this.builder
  }) : assert(max >= min);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderBuilder oldDelegate) =>
      max != oldDelegate.max ||
          min != oldDelegate.min ||
          builder != oldDelegate.builder;
}
