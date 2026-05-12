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
import 'package:flutter_templet_project/mixin/debounce_stream_mixin.dart';

/// 全局屏幕工具类，不依赖 BuildContext
class NScreenManager {
  NScreenManager._() {
    _init();
  }
  static final NScreenManager _instance = NScreenManager._();
  factory NScreenManager() => _instance;
  static NScreenManager get instance => _instance;

  _init() {
    _updateScreenSize();
    // 监听屏幕尺寸变化（如横竖屏切换、多窗口变化）
    PlatformDispatcher.instance.onMetricsChanged = () {
      _updateScreenSize();
      for (final listener in _listeners) {
        listener();
      }
    }.debounce100;
  }

  /// 当前主 View
  static FlutterView get current => PlatformDispatcher.instance.views.first;

  /// 屏幕宽高
  static Size get screenSize => current.physicalSize / current.devicePixelRatio;

  /// 像素比
  static double get devicePixelRatio => current.devicePixelRatio;

  /// 屏幕物理像素大小
  static Size get physicalSize => current.physicalSize;

  static ViewPadding get padding => current.padding;
  static ViewPadding get viewInsets => current.viewInsets;
  static ViewPadding get viewPadding => current.viewPadding;

  /// 键盘
  static double get keyboardHeight => (current.viewInsets.bottom / current.devicePixelRatio).truncateToDouble();

  /// 安全区域距离顶部高度(电池栏高度:有刘海的屏幕:47 没有刘海的屏幕为20)
  static double get safeAreaTop => current.viewPadding.top;

  /// 安全区域底部高度(有刘海的屏幕:34 没有刘海的屏幕0)
  static double get safeAreaBottom => current.viewPadding.bottom;

  /// 安全区高度(去除电池栏高度和 iphone底部34)
  static double get safeAreaHeight => screenSize.height - current.viewPadding.top - current.viewPadding.bottom;

  /// 状态栏高度
  static double get statusBarHeight => safeAreaTop;

  /// appbar 高度
  static double get appBarHeight => kToolbarHeight;

  /// 视图距离底边的高度(有键盘:键盘高度 + 34, 无键盘 0)
  static double get viewBottom => current.viewInsets.bottom;

  /// 竖屏
  static bool get isPortrait => current.physicalSize.height > current.physicalSize.width;

  /// 横屏
  static bool get isLandscape => !isPortrait;

  /// 全屏视频(横屏)播放时, 左右边距
  static double videoLandscapeSpacing({double aspectRatio = 16 / 9}) {
    final videoWidth = screenSize.height * aspectRatio;
    final landscapeSpacing = (screenSize.width - videoWidth) * 0.5;
    final result = isPortrait ? 0.0 : landscapeSpacing;
    // DLog.d([isPortrait, result].join(", "));
    return result;
  }

  static Size? _size;

  /// 屏幕逻辑像素大小
  static Size get size => _size ?? screenSize;

  /// 屏幕宽度
  static double get width => size.width;

  /// 屏幕高度
  static double get height => size.height;

  /// 屏幕方向
  static Orientation get orientation => width > height ? Orientation.landscape : Orientation.portrait;

  static final List<void Function()> _listeners = [];

  /// 添加监听器（页面级别订阅）
  static void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  /// 移除监听器（避免内存泄漏）
  static void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  /// 内部更新
  void _updateScreenSize() {
    _size = screenSize;
  }

  Map<String, dynamic> toJson() {
    return {
      "size": size,
      "devicePixelRatio": devicePixelRatio,
      "physicalSize": physicalSize,
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
