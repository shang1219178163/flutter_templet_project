//
//  TimerExt.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/7 09:36.
//  Copyright © 2024/6/7 shang. All rights reserved.
//

import 'dart:async';
import 'dart:ui';

extension TimerExt on Timer {
  /// 重试
  /// count 每次重试最大次数
  /// duration 重试间隔
  /// onTimerEnd 倒计时结束也没有成功过
  /// onFunction 需要重试的方法
  /// condition 停止重试条件
  static Timer onTry({
    int count = 3,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onTimerEnd,
    required VoidCallback onFunction,
    required bool Function() condition,
  }) {
    return Timer.periodic(duration, (t) {
      count--;
      if (condition()) {
        t.cancel();
        return;
      }
      if (count < 0) {
        t.cancel();
        // YLog.d("Timer 结束");
        onTimerEnd?.call();
        return;
      }
      // YLog.d("重试 $count");
      onFunction();
    });
  }
}
