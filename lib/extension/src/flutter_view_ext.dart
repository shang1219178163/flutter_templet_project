import 'dart:ui';

import 'package:flutter/widgets.dart';

/// FlutterView 扩展。
extension FlutterViewExt on FlutterView {
  /// 当前主视图。
  static FlutterView get current {
    return WidgetsBinding.instance.platformDispatcher.views.first;
  }

  /// 由当前视图构建 [MediaQueryData]。
  MediaQueryData get mediaQueryData {
    return MediaQueryData.fromView(this);
  }
}
