//
//  NOverlayDialog.dart
//  flutter_templet_project
//
//  Created by shang on 2026/3/4 18:47.
//  Copyright © 2026/3/4 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Dialog & Sheet & Drawer & Toast
class NOverlayDialog {
  NOverlayDialog._();

  static OverlayEntry? _entry;
  static AnimationController? _controller;

  static bool get isShowing => _entry != null;

  /// 隐藏
  static Future<void> dismiss({bool immediately = false}) async {
    if (!isShowing) {
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

  /// 显示 BottomSheet
  static void show(
    BuildContext context, {
    required Widget child,
    Alignment from = Alignment.bottomCenter,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    VoidCallback? onBarrier,
    bool hideBarrier = false,
    Duration? autoDismissDuration,
  }) {
    if (isShowing) {
      dismiss(immediately: true);
    }

    final overlay = Overlay.of(context, rootOverlay: true);
    _controller = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 300),
    );

    final animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    Widget content = child;
    // ⭐ 中心弹窗：Fade
    if (from == Alignment.center) {
      content = FadeTransition(
        opacity: animation.drive(
          CurveTween(curve: Curves.easeOut),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
          child: content,
        ),
      );
    } else {
      // ⭐ 其余方向：Slide
      content = FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: Offset(from.x.sign, from.y.sign),
              end: Offset.zero,
            ).chain(
              CurveTween(curve: curve),
            ),
          ),
          child: content,
        ),
      );
    }

    content = Align(
      alignment: from,
      child: content,
    );

    _entry = OverlayEntry(
      builder: (context) {
        if (hideBarrier) {
          return content;
        }

        return Stack(
          children: [
            // ===== Barrier =====
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: barrierDismissible ? dismiss : onBarrier,
              child: FadeTransition(
                opacity: animation,
                child: Container(
                  color: barrierColor,
                ),
              ),
            ),
            content,
          ],
        );
      },
    );

    overlay.insert(_entry!);
    _controller?.forward();
    if (autoDismissDuration != null) {
      Future.delayed(autoDismissDuration, dismiss);
    }
  }

  /// 显示
  static void sheet(
    BuildContext context, {
    required Widget child,
    Alignment from = Alignment.bottomCenter,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
    bool hideBarrier = false,
    Duration? autoDismissDuration,
  }) {
    return show(
      context,
      child: child,
      from: from,
      duration: duration,
      curve: curve,
      hideBarrier: hideBarrier,
      autoDismissDuration: autoDismissDuration,
    );
  }

  static void drawer(
    BuildContext context, {
    double widthFactor = 0.8,
    required Widget child,
    Alignment from = Alignment.centerRight,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
    bool hideBarrier = false,
    Duration? autoDismissDuration,
  }) {
    return show(
      context,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: child,
      ),
      from: from,
      duration: duration,
      curve: curve,
      hideBarrier: hideBarrier,
      autoDismissDuration: autoDismissDuration,
    );
  }

  /// 显示 toast
  static void toast(
    BuildContext context, {
    Widget? child,
    String message = "",
    EdgeInsets margin = const EdgeInsets.only(bottom: 34),
    Alignment from = Alignment.center,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
    bool hideBarrier = true,
    Duration? autoDismissDuration = const Duration(milliseconds: 2000),
  }) {
    final childDefault = Material(
      color: Colors.black.withOpacity(0.7),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    return show(
      context,
      child: Padding(
        padding: margin,
        child: child ?? childDefault,
      ),
      from: from,
      duration: duration,
      curve: curve,
      hideBarrier: hideBarrier,
      autoDismissDuration: autoDismissDuration,
    );
  }

  /// 显示 loadding
  static void loadding(
    BuildContext context, {
    Widget? indicator,
    Widget? child,
    String message = "",
    EdgeInsets margin = const EdgeInsets.only(bottom: 34),
    Alignment from = Alignment.center,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
    bool hideBarrier = true,
    Duration? autoDismissDuration,
  }) {
    final childDefault = Material(
      color: Colors.black.withOpacity(0.7),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            indicator ?? CupertinoActivityIndicator(radius: 16, color: Colors.white),
            if (child != null) child,
          ],
        ),
      ),
    );
    return show(
      context,
      child: Padding(
        padding: margin,
        child: childDefault,
      ),
      from: from,
      duration: duration,
      curve: curve,
      hideBarrier: hideBarrier,
      autoDismissDuration: autoDismissDuration,
    );
  }
}
