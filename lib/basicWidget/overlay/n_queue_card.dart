//
//  NQueueCard.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/20 18:07.
//  Copyright © 2026/4/20 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/overlay/card/n_overlay_animated_slide.dart';

/// 复用 toast
class NQueueCard {
  /// 缓存
  static final List<NReuseToastEntry> _entries = [];
  static List<NReuseToastEntry> get entries => _entries;

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
    required Widget child,
    int? max,
    double initialTop = 120,
    double left = 10,
    double right = 10,
    Offset beginOffset = const Offset(-1, 0),
    Alignment alignment = Alignment.centerLeft,
    double height = 40,
    double spacing = 12,
    Map<String, dynamic>? data,
    Duration duration = const Duration(seconds: 2),
    Duration slideDuration = const Duration(milliseconds: 300),
    VoidCallback? onRemove,
    OverlayEntry? below,
    OverlayEntry? above,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final targetIndex = entries.lastIndexWhere((e) => e.tag == tag);
    // debugPrint(["show", tag, targetIndex, child.hashCode].join(","));
    if (targetIndex != -1) {
      _entries[targetIndex].update(
        child: child,
        data: data,
        duration: duration,
        onRemove: onRemove,
      );
      return;
    }

    if (max != null && entries.length == max) {
      removeIndex(0);
    }

    final toastEntry = NReuseToastEntry(tag: tag, child: child, data: data);
    toastEntry.entry = OverlayEntry(
      builder: (context) {
        var top = initialTop + (entries.indexWhere((e) => e.tag == tag) + 1) * (height + spacing);
        return AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          top: top,
          left: left,
          right: right,
          child: SizedBox(
            height: height,
            child: toastEntry.build(
              alignment: alignment,
              beginOffset: beginOffset,
              duration: slideDuration,
            ),
          ),
        );
      },
    );

    overlay.insert(toastEntry.entry!, below: below, above: above);
    _entries.add(toastEntry);

    toastEntry.startTimer(duration: duration, onRemove: onRemove);
  }

  /// 移除
  static void remove(String tag) {
    final targetIndex = entries.lastIndexWhere((e) => e.tag == tag);
    if (targetIndex == -1) {
      return;
    }
    removeIndex(targetIndex);
  }

  static void removeIndex(int index) {
    final item = _entries.removeAt(index);
    item.dispose();
  }

  static void clear() {
    while (_entries.isNotEmpty) {
      removeIndex(0);
    }
  }
}

class NReuseToastEntry {
  NReuseToastEntry({
    required this.tag,
    required Widget child,
    this.data,
    this.entry,
  }) : childVN = ValueNotifier(child);

  /// tag 类型,同值复用
  final String tag;

  /// 当前展示内容（同 tag 更新时替换）
  final ValueNotifier<Widget> childVN;

  /// data 补充参数
  Map<String, dynamic>? data;

  /// 视图
  OverlayEntry? entry;

  Timer? _timer;

  Future<void> Function()? _onDismiss;

  /// 🔥 UI 构建
  Widget build({
    Duration duration = const Duration(milliseconds: 300),
    Alignment alignment = Alignment.centerLeft,
    Offset beginOffset = const Offset(-1, 0),
  }) {
    return NOverlayAnimatedSlide(
      key: ValueKey(tag),
      duration: duration,
      alignment: alignment,
      beginOffset: beginOffset,
      child: (dismiss) {
        _onDismiss = dismiss;
        return ValueListenableBuilder<Widget>(
          valueListenable: childVN,
          builder: (context, child, _) => child,
        );
      },
    );
  }

  /// 🔥 更新内容（核心）
  void update({
    required Widget child,
    Map<String, dynamic>? data,
    required Duration duration,
    VoidCallback? onRemove,
  }) {
    // debugPrint([runtimeType, "update", tag].join(","));
    this.data = data;
    // 通过 ValueNotifier 刷新内容，避免仅 markNeedsBuild 时子树不更新
    childVN.value = child;
    _timer?.cancel();
    startTimer(duration: duration, onRemove: onRemove);
  }

  void startTimer({required Duration duration, VoidCallback? onRemove}) {
    _timer = Timer(duration, () async {
      if (NQueueCard.entries.isNotEmpty && entry == NQueueCard.entries.first.entry) {
        await _onDismiss?.call();
      }
      NQueueCard.remove(tag);
      onRemove?.call();
    });
  }

  void dispose() {
    _timer?.cancel();
    entry?.remove();
    entry = null;
    childVN.dispose();
  }
}
