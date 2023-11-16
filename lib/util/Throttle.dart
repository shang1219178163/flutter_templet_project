

import 'package:flutter/foundation.dart';

/// 事件节流
class Throttle {
  Throttle({
    this.delay = const Duration(milliseconds: 1000),
  });

  final Duration delay;

  int? _lastActionTime;

  call(VoidCallback cb) {
    if (_lastActionTime == null) {
      cb();
      _lastActionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - _lastActionTime! > delay.inMilliseconds) {
        cb();
        _lastActionTime = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}
