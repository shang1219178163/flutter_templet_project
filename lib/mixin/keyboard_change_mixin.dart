//
//  KeyboardMixin.dart
//  flutter_templet_project
//
//  Created by shang on 3/17/23 5:28 PM.
//  Copyright © 3/17/23 shang. All rights reserved.
//


// import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';


mixin KeyboardChangeMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {

  var _isVisible = false;

  double get _bottom {
    final result = MediaQuery.of(context).viewInsets.bottom;
    return result;
  }

  @override
  void dispose() {
    /// 销毁
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    /// 初始化
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) {
      return;
    }

    final temp = _bottom > 0;
    if (_isVisible == temp) {
      return;
    }
    _isVisible = temp;
    onKeyboardChanged(_isVisible);
  }

  void onKeyboardChanged(bool visible) {
    throw UnimplementedError("❌: $this 未实现 onKeyboardChanged");
  }

}
