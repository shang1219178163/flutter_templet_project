import 'package:flutter/material.dart';

class EndBounceScrollPhysics extends BouncingScrollPhysics {
  const EndBounceScrollPhysics({super.parent});

  @override
  EndBounceScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return EndBounceScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.minScrollExtent) {
      // 不允许回弹(横轴左边界，纵轴顶部）
      return value - position.minScrollExtent;
    }
    // 留默认回弹(横轴右边界，纵轴底部）
    return super.applyBoundaryConditions(position, value);
  }
}
