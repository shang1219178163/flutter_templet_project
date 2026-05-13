//
//  NScreenManager.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/8 16:03.
//  Copyright © 2026/5/8 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/src/function_ext.dart';

/// 全局屏幕工具类，不依赖 BuildContext
class NScreenManager {
  NScreenManager._() {
    _init();
  }
  static final NScreenManager _instance = NScreenManager._();
  factory NScreenManager() => _instance;
  static NScreenManager get instance => _instance;

  _init() {
    // 监听屏幕尺寸变化（如横竖屏切换、多窗口变化）
    PlatformDispatcher.instance.onMetricsChanged = () {
      for (final listener in _listeners) {
        listener();
      }
    }.debounce100;
  }

  /// 当前主 View
  static FlutterView get current => PlatformDispatcher.instance.views.first;

  static Size? _screenSize;

  /// 屏幕宽高
  static Size get screenSize => _screenSize ?? current.physicalSize / current.devicePixelRatio;

  /// 像素比
  static double get devicePixelRatio => current.devicePixelRatio;

  static EdgeInsets get padding => EdgeInsets.fromViewPadding(current.padding, devicePixelRatio);
  static EdgeInsets get viewInsets => EdgeInsets.fromViewPadding(current.viewInsets, devicePixelRatio);
  static EdgeInsets get viewPadding => EdgeInsets.fromViewPadding(current.viewPadding, devicePixelRatio);

  static EdgeInsets get systemGestureInsets =>
      EdgeInsets.fromViewPadding(current.systemGestureInsets, devicePixelRatio);

  /// 键盘
  static double get keyboardHeight => viewInsets.bottom;

  /// 安全区域距离顶部高度(电池栏高度:有刘海的屏幕:47 没有刘海的屏幕为20)
  static double get safeAreaTop => current.viewPadding.top;

  /// 安全区域底部高度(有刘海的屏幕:34 没有刘海的屏幕0)
  static double get safeAreaBottom => current.viewPadding.bottom;

  /// 安全区高度(去除电池栏高度和 iphone底部34)
  static double get safeAreaHeight => screenSize.height - safeAreaTop - safeAreaBottom;

  /// 状态栏高度
  static double get statusBarHeight => safeAreaTop;

  /// appbar 高度
  static double get appBarHeight => kToolbarHeight;

  /// 视图距离底边的高度(有键盘:键盘高度 + 34, 无键盘 0)
  static double get viewBottom => viewInsets.bottom;

  /// 竖屏
  static bool get isPortrait => current.physicalSize.height > current.physicalSize.width;

  static Orientation get orientation => !isPortrait ? Orientation.landscape : Orientation.portrait;

  /// 全屏视频(横屏)播放时, 左右边距
  static double videoLandscapeSpacing({double aspectRatio = 16 / 9}) {
    final videoWidth = screenSize.height * aspectRatio;
    final landscapeSpacing = (screenSize.width - videoWidth) * 0.5;
    final result = isPortrait ? 0.0 : landscapeSpacing;
    // DLog.d([isPortrait, result].join(", "));
    return result;
  }

  /// 屏幕方向

  static final List<void Function()> _listeners = [];

  /// 添加监听器（页面级别订阅）
  static void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  /// 移除监听器（避免内存泄漏）
  static void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  Map<String, dynamic> toJson() {
    return {
      "screenSize": screenSize,
      "devicePixelRatio": devicePixelRatio,
      "orientation": orientation,
      "_listeners": _listeners.map((e) => e.toString()).toList(),
    };
  }

  @override
  String toString() {
    return "NScreenManager: ${toJson()}";
  }
}

/// 键盘高度改变mixin
mixin KeyboardHeightChangedMixin<T extends StatefulWidget> on State<T> {
  // /// 键盘高低
  // final keyboardHeightVN = ValueNotifier(0.0);

  /// 键盘高低
  ValueNotifier<double> _keyboardHeightVN = ValueNotifier(0.0);
  ValueNotifier<double> get keyboardHeightVN => _keyboardHeightVN;
  set keyboardHeightVN(ValueNotifier<double> value) {
    _keyboardHeightVN = value;
  }

  @override
  void dispose() {
    NScreenManager.removeListener(_onLtr);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    NScreenManager.addListener(_onLtr);
  }

  _onLtr() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final bottom = (view.viewInsets.bottom / view.devicePixelRatio).truncateToDouble();
    if (bottom > 0 && bottom <= 300) {
      debugPrint(['$runtimeType onMetricsChanged 无效数据', keyboardHeightVN.value, bottom].join(", "));
      return;
    }
    // debugPrint(['>>> $runtimeType onMetricsChanged', keyboardHeightVN.value, bottom].join(", "));
    keyboardHeightVN.value = bottom;
  }
}
