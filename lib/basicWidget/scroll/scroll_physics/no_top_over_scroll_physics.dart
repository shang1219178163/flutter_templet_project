//
//  NoTopOverScrollPhysics.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/16 12:17.
//  Copyright © 2026/1/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NoTopOverScrollPhysics extends ScrollPhysics {
  const NoTopOverScrollPhysics({super.parent});

  @override
  NoTopOverScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NoTopOverScrollPhysics(parent: buildParent(ancestor));
  }

  /// 1️⃣ 手指拖动阶段
  /// 禁止在顶部继续向下拖
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // 已在顶部 && 继续向下拖
    if (position.pixels <= position.minScrollExtent && offset > 0) {
      return offset;
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }

  /// 2️⃣ 边界阶段（防止惯性/回弹）
  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // 顶部越界（value < min）
    if (value < position.minScrollExtent) {
      return value - position.minScrollExtent;
    }

    // ❗底部完全放行
    return super.applyBoundaryConditions(position, value);
  }

  /// ③ 明确声明：允许用户滚动（否则 BottomSheet 会抢）
  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}
