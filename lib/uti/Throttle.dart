

import 'package:flutter/foundation.dart';

/// 事件节流
class Throttle {
  Throttle({
    this.milliseconds = 1000,
  });

  int milliseconds;

  int? _lastActionTime;

  call(VoidCallback cb) {
    if (_lastActionTime == null) {
      cb();
      _lastActionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - _lastActionTime! > milliseconds) {
        cb();
        _lastActionTime = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}
