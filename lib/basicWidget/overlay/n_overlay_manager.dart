//
//  NOverlayManager.dart
//  projects
//
//  Created by shang on 2026/2/26 17:21.
//  Copyright © 2026/2/26 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/tool_util.dart';

/// Overlay 管理器
@Deprecated("已弃用,请使用 NOverlayDialog")
class NOverlayManager {
  NOverlayManager._internal();

  static final NOverlayManager instance = NOverlayManager._internal();

  /// 当前 OverlayEntry 列表
  static final List<OverlayEntry> _entries = [];

  /// 当前是否有 Toast 显示
  static bool get isShowing => _entries.isNotEmpty;

  // Timer? _autoHideTimer;

  /// 刷新当前 Overlay，不销毁 Entry
  static void rebuild() {
    for (final OverlayEntry entry in _entries) {
      entry.markNeedsBuild();
    }
  }

  /// 移除所有 Toast
  static void clear() {
    // _autoHideTimer?.cancel();
    // _autoHideTimer = null;

    for (final entry in _entries) {
      entry.remove();
    }
    _entries.clear();
  }

  /// 显示 Toast
  static void show(
    BuildContext context, {
    Duration duration = const Duration(seconds: 2),
    bool autoDismiss = true,
    required WidgetBuilder builder,
  }) {
    // 1️⃣ 先清空已有 Toast
    clear();

    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = OverlayEntry(builder: builder);

    _entries.add(entry);
    overlay.insert(entry);

    // 2️⃣ 自动移除
    if (autoDismiss) {
      Future.delayed(duration, clear);
      // _autoHideTimer?.cancel();
      // _autoHideTimer = Timer(duration, hideAll);
    }
  }

  /// toast
  static void toast({
    BuildContext? context,
    Duration duration = const Duration(milliseconds: 1500),
    bool autoDismiss = true,
    double offset = 0,
    Color? backgroudColor = const Color(0x99000000),
    Color? color = const Color(0xFFFFFFFF),
    required String message,
    WidgetBuilder? builder,
  }) {
    NOverlayManager.show(
      context ?? ToolUtil.navigator.context,
      builder: builder ??
          (_) {
            return NOverlayContent(
              message: message,
              offset: offset,
              color: color,
              backgroudColor: backgroudColor,
            );
          },
    );
  }
}

class NOverlayContent extends StatelessWidget {
  const NOverlayContent({
    super.key,
    required this.message,
    this.alignment = Alignment.center,
    this.offset = 0,
    this.backgroudColor = const Color(0xFF000000),
    this.color = const Color(0xFFFFFFFF),
    this.child,
  });

  final String message;
  final Alignment alignment;
  final double offset;
  final Color? backgroudColor;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: Offset(0, offset),
        child: child ??
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroudColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'PingFang SC',
                ),
                textAlign: TextAlign.center,
              ),
            ),
      ),
    );
  }
}
