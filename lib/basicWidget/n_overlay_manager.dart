//
//  NOverlayManager.dart
//  flutter_templet_project
//
//  Created by shang on 2026/2/26 17:21.
//  Copyright © 2026/2/26 shang. All rights reserved.
//

import 'dart:async';
import 'package:flutter/material.dart';

/// Overlay 管理器
class NOverlayManager {
  NOverlayManager._internal();

  static final NOverlayManager instance = NOverlayManager._internal();

  /// 当前 OverlayEntry 列表
  final List<OverlayEntry> _entries = [];

  /// 当前是否有 Toast 显示
  bool get isShowing => _entries.isNotEmpty;

  // Timer? _autoHideTimer;

  /// 显示 Toast
  void show(
    BuildContext context, {
    required Widget child,
    Duration duration = const Duration(seconds: 2),
    bool autoDismiss = true,
  }) {
    // 1️⃣ 先清空已有 Toast
    hideAll();

    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = OverlayEntry(builder: (_) => child);

    _entries.add(entry);
    overlay.insert(entry);

    // 2️⃣ 自动移除
    if (autoDismiss) {
      Future.delayed(duration, hideAll);
      // _autoHideTimer?.cancel();
      // _autoHideTimer = Timer(duration, hideAll);
    }
  }

  /// 移除所有 Toast
  void hideAll() {
    // _autoHideTimer?.cancel();
    // _autoHideTimer = null;

    for (final entry in _entries) {
      entry.remove();
    }
    _entries.clear();
  }
}

class NOverlayContent extends StatelessWidget {
  const NOverlayContent({
    super.key,
    required this.message,
    this.offset = 0,
    this.backgroudColor = const Color(0xFF000000),
    this.color = const Color(0xFFFFFFFF),
  });

  final String message;
  final double offset;
  final Color? backgroudColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(0, offset),
        child: Container(
          // margin: EdgeInsets.only(bottom: 300),
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
