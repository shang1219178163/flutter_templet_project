//
//  NOverlayDialog.dart
//  flutter_templet_project
//
//  Created by shang on 2026/3/4 18:47.
//  Copyright © 2026/3/4 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NOverlayDialog {
  NOverlayDialog._();

  static OverlayEntry? _entry;
  static AnimationController? _controller;

  static bool get _isShowing => _entry != null;

  /// 显示 Dialog
  static void show(
    BuildContext context, {
    EdgeInsets margin = const EdgeInsets.all(0),
    required Widget child,
    bool dismissOnTapBarrier = true,
  }) {
    if (_isShowing) {
      dismiss(immediately: true);
    }

    final overlay = Overlay.of(context, rootOverlay: true);

    _controller = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 200),
    );

    final animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // ===== Barrier =====
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: dismissOnTapBarrier ? dismiss : null,
              child: FadeTransition(
                opacity: animation,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),

            // ===== Dialog =====
            _DialogContainer(
              animation: animation,
              child: child,
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!);
    _controller!.forward();
  }

  /// 隐藏 Dialog
  static Future<void> dismiss({bool immediately = false}) async {
    if (!_isShowing) {
      return;
    }

    final controller = _controller;
    final entry = _entry;

    _controller = null;
    _entry = null;

    if (immediately || controller == null) {
      entry?.remove();
      controller?.dispose();
      return;
    }

    await controller.reverse();
    entry?.remove();
    controller.dispose();
  }
}

/// ===============================
/// Dialog 外壳（系统 showDialog 等价）
/// ===============================
class _DialogContainer extends StatelessWidget {
  const _DialogContainer({
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child, // ⭐ child 缓存，不随动画 rebuild
      builder: (_, cachedChild) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.9,
              end: 1.0,
            ).animate(animation),
            child: Material(
              type: MaterialType.transparency,
              child: Center(
                child: cachedChild,
                // child: Material(
                //   elevation: 24,
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(12),
                //   clipBehavior: Clip.antiAlias,
                //   child: cachedChild,
                // ),
              ),
            ),
          ),
        );
      },
    );
  }
}
