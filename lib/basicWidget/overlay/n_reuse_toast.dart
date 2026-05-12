//
//  NReuseToast.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/20 18:07.
//  Copyright © 2026/4/20 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/overlay/card/n_overlay_slide_card.dart';

/// 复用 toast
class NReuseToast {
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
    Offset beginOffset = const Offset(-1, 0),
    Alignment alignment = Alignment.centerRight,
    EdgeInsets? margin = const EdgeInsets.symmetric(horizontal: 20),
    double height = 40,
    double spacing = 12,
    Color? barrierColor,
    Map<String, dynamic>? data,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onFinish,
    OverlayEntry? below,
    OverlayEntry? above,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final targetIndex = entries.lastIndexWhere((e) => e.tag == tag);
    // debugPrint(["show", tag, targetIndex, child.hashCode].join(","));
    if (targetIndex != -1) {
      _entries[targetIndex].update(
        height: height,
        spacing: spacing,
        child: child,
        data: data,
        duration: duration,
        onFinish: onFinish,
      );
      return;
    }

    if (max != null && entries.length == max) {
      removeIndex(0);
    }

    final toastEntry = NReuseToastEntry(
      tag: tag,
      height: height,
      spacing: spacing,
      child: child,
      data: data,
    );
    toastEntry.entry = OverlayEntry(
      builder: (context) {
        var top = initialTop + (entries.indexWhere((e) => e.tag == tag) + 1) * (height + spacing);
        return toastEntry.build(
          top: top,
          left: left,
          barrierColor: barrierColor,
          alignment: alignment,
          beginOffset: beginOffset,
        );
      },
    );

    overlay.insert(toastEntry.entry!, below: below, above: above);
    _entries.add(toastEntry);

    toastEntry.startTimer(duration: duration, onFinish: onFinish);
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
    item.entry?.remove();
  }

  static void clear() {
    for (var i = 0; i < _entries.length; i++) {
      removeIndex(i);
    }
  }
}

class NReuseToastEntry {
  NReuseToastEntry({
    required this.tag,
    required this.height,
    required this.spacing,
    required this.child,
    this.data,
  });

  /// tag 类型,同值复用
  final String tag;

  /// height 高度
  double height;

  /// spacing 间距
  double spacing;

  /// child 展示内容
  Widget child;

  /// data 补充参数
  Map<String, dynamic>? data;

  /// 视图
  OverlayEntry? entry;
  Timer? _timer;

  Future<void> Function()? _onDismiss;

  /// 🔥 UI 构建
  Widget build({
    required double top,
    required double left,
    Duration duration = const Duration(milliseconds: 300),
    Color? barrierColor,
    Alignment alignment = Alignment.centerLeft,
    Offset beginOffset = const Offset(-1, 0),
  }) {
    return NOverlaySlideCard(
      height: height,
      duration: duration,
      top: top,
      left: left,
      right: 0,
      alignment: alignment,
      beginOffset: beginOffset,
      child: (dismiss) {
        _onDismiss = dismiss;
        return child;
      },
    );
    // return AnimatedPositioned(
    //   duration: duration,
    //   top: top,
    //   left: left,
    //   right: 0,
    //   child: Container(
    //     margin: EdgeInsets.only(left: spacing),
    //     alignment: alignment,
    //     child: AnimatedSlide(
    //       duration: duration,
    //       curve: Curves.easeOutCubic,
    //       offset: beginOffset,
    //       child: SizedBox(
    //         height: height,
    //         child: child ??
    //             Container(
    //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //               decoration: BoxDecoration(
    //                 color: barrierColor ?? Colors.black.withOpacity(0.7),
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //               child: Text(
    //                 message,
    //                 style: const TextStyle(color: Colors.white),
    //               ),
    //             ),
    //       ),
    //     ),
    //   ),
    // );
  }

  /// 🔥 更新内容（核心）
  void update({
    required double height,
    required double spacing,
    required Widget child,
    Map<String, dynamic>? data,
    required Duration duration,
    VoidCallback? onFinish,
  }) {
    debugPrint([runtimeType, "update", tag].join(","));
    this.height = height;
    this.spacing = spacing;
    this.child = child;
    this.data = data;
    // ✅ 关键：触发重建
    entry?.markNeedsBuild();
    _timer?.cancel();
    startTimer(duration: duration, onFinish: onFinish);
  }

  void startTimer({required Duration duration, VoidCallback? onFinish}) {
    _timer = Timer(duration, () async {
      if (entry == NReuseToast.entries.first.entry) {
        await _onDismiss?.call();
      }
      NReuseToast.remove(tag);
      onFinish?.call();
    });
  }
}
