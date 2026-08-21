//
//  NScreenManager.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/8 16:03.
//  Copyright © 2026/5/8 shang. All rights reserved.
//

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

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

  /// 设置设计图标准尺寸
  static late Size designSize;

  /// 当前主 View
  static FlutterView get current => PlatformDispatcher.instance.views.first;

  /// 由当前视图构建 [MediaQueryData]。
  static MediaQueryData get mediaQueryData => MediaQueryData.fromView(current);

  /// 屏幕宽高
  static Size get screenSize => mediaQueryData.size;

  /// 安全区域距离顶部高度(电池栏高度:有刘海的屏幕:47 没有刘海的屏幕为20)
  static double get safeAreaTop => mediaQueryData.viewPadding.top;

  /// 安全区域底部高度(有刘海的屏幕:34 没有刘海的屏幕0)
  static double get safeAreaBottom => mediaQueryData.viewPadding.bottom;

  /// 状态栏高度
  static double get statusBarHeight => safeAreaTop;

  /// appbar 高度
  static double get appBarHeight => kToolbarHeight;
  //
  /// 竖屏
  static bool get isPortrait => mediaQueryData.orientation == Orientation.portrait;

  /// 全屏视频(横屏)播放时, 左右边距
  static double videoLandscapeSpacing({double aspectRatio = 16 / 9}) {
    final videoWidth = screenSize.height * aspectRatio;
    final landscapeSpacing = (screenSize.width - videoWidth) * 0.5;
    final result = isPortrait ? 0.0 : landscapeSpacing;
    // DLog.d([isPortrait, result].join(", "));
    return result;
  }

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
      "mediaQueryData": mediaQueryData.toJson(),
      "isPortrait": isPortrait,
      "_listeners": _listeners.map((e) => e.toString()).toList(),
    };
  }

  @override
  String toString() {
    return "NScreenManager: ${toJson()}";
  }
}

/// 基于 designSize 的设计稿尺寸缩放。
extension _DesignSizeExt on num {
  /// 将设计稿横向尺寸转换
  double get w {
    final current = WidgetsBinding.instance.platformDispatcher.views.first;
    final mediaQueryData = MediaQueryData.fromView(current);
    final scale = mediaQueryData.size.width / NScreenManager.designSize.width;
    return toDouble() * scale;
  }

  /// 将设计稿垂直尺寸转换
  double get h {
    final current = WidgetsBinding.instance.platformDispatcher.views.first;
    final mediaQueryData = MediaQueryData.fromView(current);
    final scale = mediaQueryData.size.height / NScreenManager.designSize.height;
    return toDouble() * scale;
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
    final current = WidgetsBinding.instance.platformDispatcher.views.first;
    final mediaQueryData = MediaQueryData.fromView(current);
    final bottom = mediaQueryData.viewInsets.bottom.truncateToDouble();
    if (bottom > 0 && bottom <= 300) {
      debugPrint(['$runtimeType onMetricsChanged 无效数据', keyboardHeightVN.value, bottom].join(", "));
      return;
    }
    // debugPrint(['>>> $runtimeType onMetricsChanged', keyboardHeightVN.value, bottom].join(", "));
    keyboardHeightVN.value = bottom;
  }
}
