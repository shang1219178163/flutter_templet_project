import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_popup_container.dart';

/// OverlayEntry 封装为 BottomSheet,避免路由事件
class NOverlayBottomSheet {
  NOverlayBottomSheet._();

  static OverlayEntry? _entry;
  static AnimationController? _controller;

  static bool get isShowing => _entry != null;

  /// 隐藏 BottomSheet
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
    Widget? topControl,
    Color? topControlColor,
    bool isScrollControlled = true,
    double maxHeight = 500,
    double minHeight = 200,
    double? heightFactor,
    double raius = 15,
    bool dismissOnTapBarrier = true,
    OverlayEntry? below,
    OverlayEntry? above,
    required Widget child,
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

    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
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

            // ===== BottomSheet =====
            AnimatedBuilder(
              animation: animation,
              child: NPopupContainer(
                topControl: topControl,
                topControlColor: topControlColor,
                isScrollControlled: isScrollControlled,
                maxHeight: maxHeight,
                minHeight: minHeight,
                heightFactor: heightFactor,
                raius: raius,
                child: child,
              ),
              builder: (context, cachedChild) {
                return FractionalTranslation(
                  translation: Offset(0, 1 - animation.value),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: cachedChild,
                  ),
                );
              },
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!, below: below, above: above);
    _controller!.forward();
  }
}
