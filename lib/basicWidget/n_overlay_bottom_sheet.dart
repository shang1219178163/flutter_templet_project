import 'dart:async';
import 'package:flutter/material.dart';

/// OverlayEntry 封装为 BottomSheet,避免路由事件
class NOverlayBottomSheet {
  NOverlayBottomSheet._();

  static OverlayEntry? _entry;
  static AnimationController? _controller;

  static bool get _isShowing => _entry != null;

  /// 显示 BottomSheet
  static void show(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = false,
    bool dismissOnTapBarrier = true,
  }) {
    if (_isShowing) {
      hide(immediately: true);
    }

    final overlay = Overlay.of(context, rootOverlay: true);

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top;

    final maxHeight = isScrollControlled ? screenHeight - topPadding : screenHeight * 0.5;

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
              onTap: dismissOnTapBarrier ? hide : null,
              child: FadeTransition(
                opacity: animation,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),

            // ===== BottomSheet =====
            _BottomSheetContainer(
              animation: animation,
              maxHeight: maxHeight,
              child: child,
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!);
    _controller!.forward();
  }

  /// 隐藏 BottomSheet
  static Future<void> hide({bool immediately = false}) async {
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
/// BottomSheet 外壳（系统级实现）
/// ===============================
class _BottomSheetContainer extends StatelessWidget {
  const _BottomSheetContainer({
    required this.animation,
    required this.maxHeight,
    required this.child,
  });

  final Animation<double> animation;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child, // ⭐ child 不参与动画，避免反复 build
      builder: (context, cachedChild) {
        return FractionalTranslation(
          translation: Offset(0, 1 - animation.value),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                ),
                child: Material(
                  elevation: 12,
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: cachedChild,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
