import 'package:flutter/material.dart';

/// sliver Group 组件
class NSliverAxisGroup extends StatelessWidget {
  const NSliverAxisGroup({
    super.key,
    this.axis = Axis.vertical,
    required this.slivers,
  });

  final Axis? axis;

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    if (axis != Axis.vertical) {
      return SliverCrossAxisGroup(slivers: slivers);
    }
    return SliverMainAxisGroup(slivers: slivers);
  }
}
