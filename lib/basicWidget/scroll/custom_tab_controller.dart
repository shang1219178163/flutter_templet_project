//
//  CustomTabController.dart
//  flutter_templet_project
//
//  Created by shang on 2025/2/5 16:30.
//  Copyright © 2025/2/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 自定义 TabController 控制器
class CustomTabController extends TabController {
  CustomTabController({
    int initialIndex = 0,
    Duration? animationDuration,
    required super.length,
    required TickerProvider vsync,
  }) : super(initialIndex: initialIndex, animationDuration: animationDuration, vsync: vsync);

  @override
  set index(int value) {
    if (indexIsChanging) {
      return;
    }
    super.index = value;
  }

  @override
  void animateTo(int value, {Duration? duration, Curve curve = Curves.ease}) {
    if (indexIsChanging) {
      return;
    }
    return super.animateTo(value, duration: duration, curve: curve);
  }
}
