import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class MyCustomScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that always lets the user scroll.
  const MyCustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  MyCustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return MyCustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    DLog.d([offset.toStringAsFixed(1)]);
    return offset * 0.5; // 阻尼
  }

  /// ③ 明确声明：允许用户滚动（否则 BottomSheet 会抢）
  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    DLog.d([position.pixels.toStringAsFixed(1)]);
    if (position.outOfRange && position.pixels > position.maxScrollExtent) {
      return false;
    }
    return true;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.minScrollExtent) {
      return value - position.minScrollExtent;
    }
    return 0;
  }
}
