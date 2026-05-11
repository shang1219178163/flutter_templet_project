//
//  NestedHandoffScrollPhysics.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/16 14:53.
//  Copyright © 2026/1/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';

@Deprecated("已弃用, 仅测试")
class NestedHandoffScrollPhysics extends ScrollPhysics {
  const NestedHandoffScrollPhysics({super.parent});

  @override
  NestedHandoffScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NestedHandoffScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    final atTop = position.pixels <= position.minScrollExtent;
    final atBottom = position.pixels >= position.maxScrollExtent;

    // ① 在顶部，继续下拉 → 交给父 ScrollView（B）
    if (atTop && offset > 0) {
      return offset; // 不消费
    }

    // ② 在底部，继续上拉 → 交给父 ScrollView（B）
    if (atBottom && offset < 0) {
      return offset; // 不消费
    }

    // ③ 其它情况 → A 正常滚动
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // 防止 A 自己产生 overscroll / 回弹
    if (value < position.minScrollExtent) {
      return value - position.minScrollExtent;
    }
    // if (value > position.maxScrollExtent) {
    //   return value - position.maxScrollExtent;
    // }
    return super.applyBoundaryConditions(position, value);
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}
