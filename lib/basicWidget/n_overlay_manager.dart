//
//  NOverlayManager.dart
//  flutter_templet_project
//
//  Created by shang on 2026/2/26 17:21.
//  Copyright © 2026/2/26 shang. All rights reserved.
//

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Overlay 管理器
class NOverlayManager {
  NOverlayManager._internal();

  static final NOverlayManager instance = NOverlayManager._internal();

  static final _globalContext = Get.context;

  /// 当前 OverlayEntry 列表
  static final List<OverlayEntry> _entries = [];
  static List<OverlayEntry> get entries => _entries;

  /// 当前弹窗
  static OverlayEntry? get last {
    if (_entries.isEmpty) {
      return null;
    }
    return _entries.last;
  }

  /// 当前是否有 Toast 显示
  static bool get isLoading => _entries.isNotEmpty;

  static void insert(OverlayEntry entry, {OverlayEntry? below, OverlayEntry? above}) {
    final overlay = Overlay.of(_globalContext!, rootOverlay: true);
    _entries.add(entry);
    overlay.insert(entry, below: below, above: above);
  }

  /// 移除所有 Toast
  static void removeAll() {
    for (final entry in _entries) {
      if (entry.mounted) {
        entry.remove();
      }
    }
    _entries.clear();
  }

  /// 显示 Toast
  static void show({
    Duration duration = const Duration(seconds: 2),
    bool autoDismiss = true,
    required Widget child,
  }) {
    // 1️⃣ 先清空已有 Toast
    removeAll();

    final entry = OverlayEntry(builder: (_) => child);
    insert(entry);
    // 2️⃣ 自动移除
    if (autoDismiss) {
      Future.delayed(duration, removeAll);
    }
  }

  static OverlayEntry? _current;

  /// 展示动画
  static void showAnimation({
    BuildContext? context,
    Duration duration = const Duration(seconds: 2),
    required Widget Function(VoidCallback onHide) bulder,
  }) {
    final contextNew = context ?? _globalContext;
    // 移除旧的
    // ✅ 安全移除旧的
    // if (_current != null && _current!.mounted) {
    //   _current!.remove();
    // }
    removeAll();

    final controller = AnimationController(
      vsync: Navigator.of(contextNew!),
      duration: const Duration(milliseconds: 350),
    );

    late OverlayEntry entry;

    controller.addListener(() {
      Future.microtask(() {
        if (entry.mounted) {
          entry.markNeedsBuild();
        }
      });
    });

    onHide() async {
      if (!entry.mounted) {
        return;
      }
      await controller.reverse();
      entry.remove();
      controller.dispose();
    }

    entry = OverlayEntry(
      builder: (_) {
        final t = CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ).value;

        return Positioned(
          bottom: 100 * t,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: t,
            child: Transform.scale(
              scale: 0.9 + 0.1 * t,
              child: bulder(onHide),
            ),
          ),
        );
      },
    );

    _current = entry;
    insert(entry);
    // final overlayState = Overlay.of(context, rootOverlay: true);
    // overlayState.insert(entry);
    controller.forward();
    Future.delayed(duration, onHide);
  }

  /// sheet
  static void sheet({
    BuildContext? context,
    Duration duration = const Duration(seconds: 2),
    double height = 500,
    double radius = 16,
    bool onBarrier = true,
    required Widget Function(VoidCallback onHide) bulder,
  }) {
    final contextNew = context ?? _globalContext;
    removeAll();

    final controller = AnimationController(
      vsync: Navigator.of(contextNew!),
      duration: const Duration(milliseconds: 350),
    );

    late OverlayEntry entry;
    controller.addListener(() {
      Future.microtask(() {
        if (entry.mounted) {
          entry.markNeedsBuild();
        }
      });
    });

    onHide() async {
      if (!entry.mounted) {
        return;
      }
      await controller.reverse();
      entry.remove();
      controller.dispose();
    }

    entry = OverlayEntry(
      builder: (_) {
        final t = CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ).value;

        final offsetY = (1 - t) * height;
        return Stack(
          children: [
            // 1️⃣ 背景遮罩
            GestureDetector(
              onTap: onBarrier ? onHide : null,
              child: Opacity(
                opacity: 0.4 * t,
                child: Container(color: Colors.black),
              ),
            ),
            AnimatedBuilder(
              animation: controller,
              child: Material(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(radius),
                ),
                clipBehavior: Clip.antiAlias,
                // color: Colors.white,
                child: RepaintBoundary(
                  child: bulder(onHide),
                ),
              ),
              builder: (_, cachedChild) {
                return AnimatedPositioned(
                  duration: controller.duration ?? Duration.zero,
                  left: 0,
                  right: 0,
                  bottom: -offsetY,
                  height: height,
                  child: cachedChild!,
                );
              },
            ),
            // AnimatedPositioned(
            //   duration: controller.duration ?? Duration.zero,
            //   left: 0,
            //   right: 0,
            //   bottom: -offsetY,
            //   height: height,
            //   child: Material(
            //     borderRadius: BorderRadius.vertical(
            //       top: Radius.circular(radius),
            //     ),
            //     clipBehavior: Clip.antiAlias,
            //     // color: Colors.white,
            //     child: RepaintBoundary(
            //       child: bulder(onHide),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );

    _current = entry;
    insert(entry);
    controller.forward();
    // Future.delayed(duration, onHide);
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
