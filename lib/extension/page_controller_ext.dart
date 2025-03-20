//
//  PageControllerExt.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/16 16:33.
//  Copyright © 2025/1/16 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

extension PageControllerExt on PageController {
  /// 跳转到对应位子
  Future<void> toPage(
    int page, {
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.ease,
  }) async {
    if (!hasClients) {
      return;
    }
    if (duration == Duration.zero) {
      jumpToPage(page);
    } else {
      await animateToPage(page, duration: duration, curve: curve);
    }
  }
}
