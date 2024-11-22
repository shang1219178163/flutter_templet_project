//
//  DraggableFloatingButtonMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/21 16:05.
//  Copyright © 2024/11/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';

/// 创建浮动拖拽按钮
mixin DraggableFloatingButtonMixin<T extends StatefulWidget> on State<T> {
  late OverlayEntry _overlayEntry;
  final _entries = <OverlayEntry>[];

  double _left = 100.0;
  double _top = 100.0;
  double _right = 0.0;

  /// 悬浮按钮是否显示中
  bool get isFloatingButtonShow => _entries.isNotEmpty;

  @override
  void dispose() {
    floatingButtonHide();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Insert the overlay into the overlay stack when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      floatingButtonShow();
    });
  }

  OverlayEntry _createOverlayEntry({
    bool attachHorizalEdge = true,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width;
    final maxHeight = screenSize.height;

    final buttonSize = floatingButtonSize();
    final buttonHorizalHalf = buttonSize.width * 0.5;
    final buttonVerticalHalf = buttonSize.height * 0.5;

    final padding = floatingButtonPadding();
    final leftMin = max(buttonHorizalHalf, padding.left);
    final leftMax = maxWidth - max(buttonHorizalHalf, padding.right);

    final topMin = max(buttonVerticalHalf, padding.top) + buttonVerticalHalf;
    final topMax = maxHeight - max(buttonVerticalHalf, padding.bottom);

    final midX = _left + buttonSize.width / 2;
    final isLeft = midX < maxWidth * 0.5;

    return OverlayEntry(
      builder: (context) => Positioned(
        top: _top,
        left: isLeft ? _left : null,
        right: !isLeft ? _right : null,
        child: GestureDetector(
          onPanUpdate: (details) {
            // DLog.d([
            //   "onPanUpdate",
            //   details.globalPosition.dx.toStringAsFixed(2),
            //   details.globalPosition.dy.toStringAsFixed(2),
            //   bttonPadding.top.toStringAsFixed(2),
            // ].asMap());

            if (details.globalPosition.dx <= leftMin || details.globalPosition.dx >= leftMax) {
              return;
            }
            if (details.globalPosition.dy <= topMin || details.globalPosition.dy >= topMax) {
              return;
            }

            _left = details.globalPosition.dx - buttonHorizalHalf;
            _top = details.globalPosition.dy - buttonVerticalHalf;
            _right = maxWidth - _left - buttonSize.width;
            _overlayEntry.markNeedsBuild();
          },
          onPanEnd: (DragEndDetails e) {
            // debugPrint("_leftVN.value:${_leftVN.value}");
            final midX = _left + buttonSize.width / 2;
            final midY = _top + buttonSize.height / 2;

            if (attachHorizalEdge) {
              if (midX < maxWidth * 0.5) {
                _left = padding.left;
              } else {
                _left = maxWidth - buttonSize.width - padding.right;
              }
              _right = maxWidth - _left - buttonSize.width;
              _overlayEntry.markNeedsBuild();
            }
          },
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: buttonSize.width,
              height: buttonSize.height,
              child: floatingButton(),
            ),
          ),
        ),
      ),
    );
  }

  Widget floatingButton() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }

  /// 悬浮按钮尺寸
  Size floatingButtonSize() {
    return Size(60, 60);
  }

  EdgeInsets floatingButtonPadding() {
    return EdgeInsets.only(
      top: MediaQuery.of(context).viewPadding.top + kToolbarHeight,
      bottom: MediaQuery.of(context).viewPadding.bottom,
      left: 4,
      right: 4,
    );
  }

  void floatingButtonToggle() {
    if (isFloatingButtonShow) {
      floatingButtonHide();
    } else {
      floatingButtonShow();
    }
  }

  /// 展示悬浮按钮
  void floatingButtonShow() {
    _overlayEntry = _createOverlayEntry();
    _entries.add(_overlayEntry);
    Overlay.of(context).insert(_overlayEntry);
  }

  /// 隐藏(销毁)悬浮按钮
  void floatingButtonHide() {
    _entries.remove(_overlayEntry);
    _overlayEntry.remove();
  }
}
