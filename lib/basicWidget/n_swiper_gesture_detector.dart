//
//  NSwiperGestureDetector.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/23 15:07.
//  Copyright © 2025/1/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 扫动手势
class NSwiperGestureDetector extends StatelessWidget {
  const NSwiperGestureDetector({
    super.key,
    this.direction = Axis.horizontal,
    required this.onPre,
    required this.onNext,
    required this.child,
  });

  /// 方向
  final Axis direction;

  /// 后退
  final VoidCallback onPre;

  /// 前进
  final VoidCallback onNext;

  /// 组件
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: onDragEnd,
      onVerticalDragEnd: onDragEnd,
      child: child,
    );
  }

  void onDragEnd(DragEndDetails details) {
    final primaryVelocity = details.primaryVelocity;
    DLog.d("滑: $primaryVelocity");
    if (primaryVelocity == null) {
      return;
    }

    // Swiping in right direction.
    if (primaryVelocity > 0) {
      onPre();
    }

    // Swiping in left direction.
    if (primaryVelocity < 0) {
      onNext();
    }
  }
}
