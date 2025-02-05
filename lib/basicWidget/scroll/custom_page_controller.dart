//
//  CustomPageController.dart
//  flutter_templet_project
//
//  Created by shang on 2025/2/5 16:31.
//  Copyright © 2025/2/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 自定义 PageController 控制器
class CustomPageController extends PageController {
  CustomPageController({
    super.initialPage,
    super.onAttach,
    super.onDetach,
    this.duration,
    this.curve,
  });

  /// 跳转页面
  Duration? duration;

  /// 跳转动画曲线
  Curve? curve;

  /// 跳转页面
  Future<void> jumpPage(int page) {
    return super.animateToPage(
      page,
      duration: duration ?? Duration(milliseconds: 200),
      curve: curve ?? Curves.easeOut,
    );
  }
}
