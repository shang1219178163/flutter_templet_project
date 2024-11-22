//
//  OverlayMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/22 08:51.
//  Copyright © 2024/11/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_adaptive_text.dart';
import 'package:flutter_templet_project/basicWidget/n_slide_transition_builder.dart';

/// 创建浮动拖拽按钮
mixin OverlayMixin<T extends StatefulWidget> on State<T> {
  OverlayState get _overlayState => Overlay.of(context);

  /// overlay 层集合
  final List<OverlayEntry> _entries = [];
  List<OverlayEntry> get entries => _entries;

  /// 当前弹窗
  OverlayEntry? get currentOverlayEntry {
    if (_entries.isEmpty) {
      return null;
    }
    return _entries[_entries.length - 1];
  }

  /// 有 OverlayEntry 显示中
  bool get isLoading => _entries.isNotEmpty;

  /// OverlayEntry 弹窗展示
  OverlayEntry? showEntry({
    bool isReplace = false,
    bool maintainState = false,
    required Widget child,
  }) {
    if (isReplace) {
      hideEntry();
    }

    final overlayEntry = OverlayEntry(
      maintainState: maintainState,
      builder: (_) => child,
    );

    _overlayState.insert(overlayEntry);
    _entries.add(overlayEntry);
    return overlayEntry;
  }

  /// OverlayEntry 弹窗移除
  hideEntry({duration = const Duration(milliseconds: 350)}) {
    if (currentOverlayEntry == null) {
      return;
    }
    Future.delayed(duration, () {});
    currentOverlayEntry?.remove();
    _entries.remove(currentOverlayEntry!);
  }

  /// OverlayEntry 清除
  clearEntrys() {
    for (final entry in _entries) {
      entry.remove();
    }
    _entries.clear();
  }

  /// 展示 OverlayEntry 弹窗
  showToast(
    String message, {
    Alignment alignment = Alignment.center,
    Duration duration = const Duration(milliseconds: 2000),
    bool barrierDismissible = true,
    Color? barrierColor = Colors.transparent,
    VoidCallback? onBarrier,
    bool isLast = false,
    Widget? child,
  }) {
    Widget content = NAdaptiveText(
      data: message,
      alignment: alignment,
      child: child,
    );

    if (barrierColor != null) {
      content = Stack(
        children: [
          Material(
            color: barrierColor ?? Colors.black.withOpacity(0.1),
            child: InkWell(
              onTap: onBarrier,
              child: Container(
                decoration: BoxDecoration(
                  color: barrierColor,
                ),
              ),
            ),
          ),
          content,
        ],
      );
    }
    showEntry(child: content);

    if (barrierDismissible) {
      Future.delayed(duration, hideEntry);
    }
  }

  /// 滑进滑出弹窗
  presentModalView({
    bool isReplace = false,
    bool maintainState = false,
    Alignment alignment = Alignment.bottomCenter,
    Duration duration = const Duration(milliseconds: 350),
    bool barrierDismissible = true,
    required Widget Function(BuildContext context, VoidCallback onHide) builder,
  }) {
    final globalKey = GlobalKey<NSlideTransitionBuilderState>();

    onHide() async {
      if (alignment != Alignment.center) {
        await globalKey.currentState?.controller.reverse();
      }
      hideEntry();
    }

    showEntry(
      isReplace: isReplace,
      maintainState: maintainState,
      child: Material(
        color: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: !barrierDismissible ? null : onHide,
          child: NSlideTransitionBuilder(
            key: globalKey,
            alignment: alignment,
            duration: duration,
            hasFade: false,
            child: builder(context, onHide),
          ),
        ),
      ),
    );
  }
}
