import 'package:flutter/cupertino.dart';

class MyScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that always lets the user scroll.
  const MyScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  MyScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return MyScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    if (position.outOfRange && position.pixels > position.maxScrollExtent) {
      return false;
    }
    return true;
  }
}
