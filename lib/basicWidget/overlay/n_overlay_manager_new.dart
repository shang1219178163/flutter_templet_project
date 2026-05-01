//
//  NOverlayManager.dart
//  projects
//
//  Created by shang on 2026/2/26 17:21.
//  Copyright © 2026/2/26 shang. All rights reserved.
//

import 'dart:async';
import 'package:flutter/material.dart';

/// Overlay 管理器
class NOverlayManagerNew {
  NOverlayManagerNew._internal();
  static final NOverlayManagerNew instance = NOverlayManagerNew._internal();

  /// 当前 OverlayEntry 列表
  static final List<OverlayEntry> _entries = [];

  /// 当前是否有 Toast 显示
  static bool get isShowing => _entries.isNotEmpty;

  static Timer? _autoHideTimer;

  /// 移除所有 Toast
  static void removeAll() {
    _autoHideTimer?.cancel();
    _autoHideTimer = null;

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
    removeAll();

    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = OverlayEntry(builder: builder);

    _entries.add(entry);
    overlay.insert(entry);

    // 2️⃣ 自动移除
    if (autoDismiss) {
      _autoHideTimer?.cancel();
      _autoHideTimer = Timer(duration, removeAll);
    }
  }
}
