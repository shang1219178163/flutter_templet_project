import 'dart:ui';

import 'package:flutter/cupertino.dart';

/// 全局屏幕工具类，不依赖 BuildContext
class ScreenManager {
  static final ScreenManager _instance = ScreenManager._();
  ScreenManager._() {
    _init();
  }
  factory ScreenManager() => _instance;
  static ScreenManager get instance => _instance;

  _init() {
    _updateScreenSize();
    // 监听屏幕尺寸变化（如横竖屏切换、多窗口变化）
    PlatformDispatcher.instance.onMetricsChanged = () {
      _updateScreenSize();
      for (final listener in _listeners) {
        listener(_size);
      }
    };
  }

  static Size _size = const Size(0, 0);

  /// 屏幕逻辑像素大小
  static Size get size => _size;

  /// 屏幕宽度
  static double get width => _size.width;

  /// 屏幕高度
  static double get height => _size.height;

  /// 屏幕像素密度
  static double get devicePixelRatio => PlatformDispatcher.instance.views.first.devicePixelRatio;

  /// 屏幕物理像素大小
  static Size get physicalSize => PlatformDispatcher.instance.views.first.physicalSize;

  /// 屏幕方向
  static Orientation get orientation => width > height ? Orientation.landscape : Orientation.portrait;

  static final List<void Function(Size size)> _listeners = [];

  /// 添加监听器（页面级别订阅）
  static void addListener(void Function(Size size) listener) {
    _listeners.add(listener);
  }

  /// 移除监听器（避免内存泄漏）
  static void removeListener(void Function(Size size) listener) {
    _listeners.remove(listener);
  }

  /// 内部更新
  void _updateScreenSize() {
    final view = PlatformDispatcher.instance.views.first;
    _size = view.physicalSize / view.devicePixelRatio;
  }

  @override
  String toString() {
    final map = {
      "size": size,
      "devicePixelRatio": devicePixelRatio,
      "physicalSize": physicalSize,
      "orientation": orientation,
      "_listeners": _listeners.map((e) => e.toString()).toList(),
    };

    return "ScreenManager: $map";
  }
}
