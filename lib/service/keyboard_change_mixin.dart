//
//  KeyboardMixin.dart
//  flutter_templet_project
//
//  Created by shang on 3/17/23 5:28 PM.
//  Copyright © 3/17/23 shang. All rights reserved.
//


// import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';


mixin KeyboardChangeMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {

  bool _isVisible = false;

  double get bottom {
    return MediaQuery.of(context).viewInsets.bottom;
    // return WidgetsBinding.instance?.window.viewInsets.bottom ?? 0;
    // return EdgeInsets.fromWindowPadding(
    //   WidgetsBinding.instance?.window.viewInsets ?? ui.WindowPadding.zero,
    //   WidgetsBinding.instance?.window.devicePixelRatio ?? 0,
    // ).bottom;
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
    if (!mounted) return;

    final temp = bottom > 0;
    if (_isVisible == temp) return;
    _isVisible = temp;
    onKeyboardChanged(_isVisible);
  }

  void onKeyboardChanged(bool visible);

}
