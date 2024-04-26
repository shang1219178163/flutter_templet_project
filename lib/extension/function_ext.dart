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

final _debounceMap = <Function, Debounce>{};

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
    return _debounce(() {
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
    var debounceFn = _debounceMap[this];
    if (debounceFn == null) {
      debounceFn = Debounce();
      _debounceMap[this] = debounceFn;
    }
    debounceFn.delay = duration;
    debounceFn(() => this());
  }

  /// 认证
  ///
  /// onAuth 返回认证状态
  /// onUnauth 未认证回调
  auth({
    required bool Function() onAuth,
    VoidCallback? onUnauth,
  }) {
    final hadAuth = onAuth();
    if (!hadAuth) {
      return (){
        onUnauth?.call();
      };
    }
    return this;
  }
}


extension ValueChangedExt<T> on ValueChanged<T> {

  /// 防抖
  debounce({
    required T value,
    Duration duration = const Duration(milliseconds: 500),
  }){
    _debounce.delay = duration;
    _debounce(() => this.call(value));
  }
}

