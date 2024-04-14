//
//  FunctionExt.dart
//  flutter_templet_project
//
//  Created by shang on 3/29/23 3:06 PM.
//  Copyright © 3/29/23 shang. All rights reserved.
//


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/util/Debounce.dart';

final _debounce = Debounce();

extension FunctionExt on Function{
  /// 同 Function.apply
  static apply(
      Function function,
      List<dynamic>? positionalArguments,
      [Map<String, dynamic>? namedArguments]
  ) {
    final arguments = namedArguments?.map((key, value) => MapEntry(Symbol(key), value));
    return Function.apply(function, positionalArguments, arguments);
  }

  ///效果同 Function.apply
  applyNew({
    List<dynamic>? positionalArguments,
    Map<String, dynamic>? namedArguments,
  }) {
    final arguments = namedArguments?.map((key, value) => MapEntry(Symbol(key), value));
    return Function.apply(this, positionalArguments, arguments);
  }

  /// 防抖
  debounce({
    Duration duration = const Duration(milliseconds: 500),
    List<dynamic>? positionalArguments,
    Map<String, dynamic>? namedArguments,
  }){
    _debounce.delay = duration;
    return _debounce.call(() {
      applyNew(positionalArguments: positionalArguments, namedArguments: namedArguments);
    });

  }

}


extension VoidCallbackExt on VoidCallback {

  /// 延迟执行
  Future delayed({
    Duration duration = const Duration(milliseconds: 500),
  }) => Future.delayed(duration, this);

  /// 防抖
  void debounce({
    Duration duration = const Duration(milliseconds: 500),
  }){
    _debounce.delay = duration;
    _debounce(() => this());
  }

}


class DebounceNew {
  DebounceNew({
    this.delay = const Duration(milliseconds: 500),
  });

  Duration delay;

  Timer? _timer;

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  bool get isRunning => _timer?.isActive ?? false;

  void cancel() => _timer?.cancel();
}