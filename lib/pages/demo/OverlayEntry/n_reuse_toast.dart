//
//  NReuseToast.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/20 18:07.
//  Copyright © 2026/4/20 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 复用 toast
class NReuseToast {
  /// 缓存
  static final List<_ReuseToastEntry> _entries = [];
  static List<_ReuseToastEntry> get entries => _entries;

  /// 展示
  ///
  /// tag 类型,同值复用
  /// message 展示内容
  /// initialTop 初始据地屏幕顶部距离
  /// margin 距离屏幕水平边距
  /// height 高度
  /// spacing 间距
  /// data 补充参数
  /// duration 动画时间
  /// onFinish 移除回调
  static void show({
    required BuildContext context,
    required String tag,
    required String message,
    Widget? child,
    double initialTop = 120,
    EdgeInsets? margin = const EdgeInsets.symmetric(horizontal: 20),
    double height = 40,
    double spacing = 12,
    Map<String, dynamic>? data,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onFinish,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final targetIndex = entries.lastIndexWhere((e) => e.tag == tag);
    if (targetIndex != -1) {
      _entries[targetIndex].update(
        height: height,
        spacing: spacing,
        message: message,
        child: child,
        data: data,
        duration: duration,
        onFinish: onFinish,
      );
      return;
    }

    final toastEntry = _ReuseToastEntry(
      tag: tag,
      height: height,
      spacing: spacing,
      message: message,
      child: child,
      data: data,
    );
    toastEntry.entry = OverlayEntry(
      builder: (context) {
        var top = initialTop + (entries.indexWhere((e) => e.tag == tag) + 1) * (height + spacing);
        return toastEntry.build(
          top: top,
          alignment: Alignment.centerLeft,
        );
      },
    );

    overlay.insert(toastEntry.entry!);
    _entries.add(toastEntry);

    toastEntry.startTimer(duration: duration, onFinish: onFinish);
  }

  /// 移除
  static void remove(String tag) {
    final targetIndex = entries.lastIndexWhere((e) => e.tag == tag);
    if (targetIndex == -1) {
      return;
    }

    final item = _entries.removeAt(targetIndex);
    item.entry?.remove();
  }
}

class _ReuseToastEntry {
  _ReuseToastEntry({
    required this.tag,
    required this.height,
    required this.spacing,
    required this.message,
    this.child,
    this.data,
  });

  final String tag;
  double height;
  double spacing;
  String message;
  Widget? child;
  Map<String, dynamic>? data;

  OverlayEntry? entry;
  Timer? _timer;

  /// 🔥 UI 构建
  Widget build({
    required double top,
    Alignment alignment = Alignment.center,
  }) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      top: top,
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.only(left: spacing),
        alignment: alignment,
        child: SizedBox(
          height: height,
          child: child ??
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
        ),
      ),
    );
  }

  /// 🔥 更新内容（核心）
  void update({
    required double height,
    required double spacing,
    required String message,
    Widget? child,
    Map<String, dynamic>? data,
    required Duration duration,
    VoidCallback? onFinish,
  }) {
    debugPrint([runtimeType, "update", message].join(","));
    this.height = height;
    this.spacing = spacing;
    this.message = message;
    this.child = child;
    this.data = data;
    // ✅ 关键：触发重建
    entry?.markNeedsBuild();
    _timer?.cancel();
    startTimer(duration: duration, onFinish: onFinish);
  }

  void startTimer({required Duration duration, VoidCallback? onFinish}) {
    _timer = Timer(duration, () {
      NReuseToast.remove(tag);
      onFinish?.call();
    });
  }
}
