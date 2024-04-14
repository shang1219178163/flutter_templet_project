

import 'dart:async';

import 'package:flutter/foundation.dart';

/// 搜索框防抖
class Debounce {
  Debounce({
    this.delay = const Duration(milliseconds: 500),
  });

  Duration delay;

  Timer? _timer;

  call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  bool get isRunning => _timer?.isActive ?? false;

  void cancel() => _timer?.cancel();
}

// final _debounce = Debounce(milliseconds: 500);
//
// onTextChange(String text) {
//   _debounce(() => print(text));
// }



// /// 函数防抖
// ///
// /// [func]: 要执行的方法
// /// [delay]: 要迟延的时长
// Function debounce(
//     Function func, [
//       Duration delay = const Duration(milliseconds: 2000),
//     ]) {
//   Timer? timer;
//   return () {
//     timer?.cancel();
//     timer = Timer(delay, () {
//       func();
//     });
//   };
// }