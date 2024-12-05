//
//  DraggableFloatingButtonMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/21 16:05.
//  Copyright © 2024/11/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:yaml/yaml.dart';

/// 浮动拖拽按钮配置类
class DraggableFloatingButtonConfig {
  DraggableFloatingButtonConfig({
    this.globalPosition,
    required this.buttonMargin,
    required this.buttonSize,
    required this.button,
    this.expandedButtonSize,
    this.expandedButton,
    this.onButton,
    this.rotationY = true,
  });

  /// 悬浮按钮外边距
  EdgeInsets buttonMargin;

  Offset? globalPosition;

  /// 悬浮按钮尺寸
  Size buttonSize;

  /// 悬浮按钮
  Widget button;

  VoidCallback? onButton;

  /// 悬浮按钮尺寸
  Size? expandedButtonSize;

  /// 悬浮按钮
  Widget? expandedButton;

  /// Y 轴旋转
  bool? rotationY;

  DraggableFloatingButtonConfig copyWith({
    Offset? globalPosition,
    EdgeInsets? buttonMargin,
    Size? buttonSize,
    Widget? button,
    Size? expandedButtonSize,
    Widget? expandedButton,
    VoidCallback? onButton,
    bool? rotationY,
  }) {
    return DraggableFloatingButtonConfig(
      globalPosition: globalPosition ?? this.globalPosition,
      buttonMargin: buttonMargin ?? this.buttonMargin,
      buttonSize: buttonSize ?? this.buttonSize,
      button: button ?? this.button,
      expandedButtonSize: expandedButtonSize ?? this.expandedButtonSize,
      expandedButton: expandedButton ?? this.expandedButton,
      onButton: onButton ?? this.onButton,
      rotationY: rotationY ?? this.rotationY,
    );
  }
}

/// 浮动拖拽按钮
mixin DraggableFloatingButtonMixin<T extends StatefulWidget> on State<T> {
  late OverlayEntry _overlayEntry;
  final _entries = <OverlayEntry>[];

  double _left = 100.0;

  double _top = 120.0;

  double _right = 0.0;

  /// 悬浮按钮是否显示中
  bool get isFloatingButtonShow => _entries.isNotEmpty;

  bool _isExpanded = false;

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

    var button = draggableFloatingButtonConfig.button;
    var expandedButton = draggableFloatingButtonConfig.expandedButton ?? button;
    var currButton = (_isExpanded ? expandedButton : button);

    var buttonSize = draggableFloatingButtonConfig.buttonSize;
    var expandedButtonSize = draggableFloatingButtonConfig.expandedButtonSize ?? buttonSize;
    var currButtonSize = _isExpanded ? expandedButtonSize : buttonSize;
    var buttonHorizalHalf = currButtonSize.width * 0.5;
    var buttonVerticalHalf = currButtonSize.height * 0.5;

    var padding = draggableFloatingButtonConfig.buttonMargin;
    var leftMin = max(buttonHorizalHalf, padding.left);
    var leftMax = maxWidth - max(buttonHorizalHalf, padding.right);

    var topMin = max(buttonVerticalHalf, padding.top) + buttonVerticalHalf;
    var topMax = maxHeight - max(buttonVerticalHalf, padding.bottom);

    final defaultPosition = draggableFloatingButtonConfig.globalPosition ?? Offset(maxWidth, 120);
    _top = defaultPosition.dy;
    _left = defaultPosition.dx;
    _right = maxWidth - defaultPosition.dx;

    var midX = _left + currButtonSize.width / 2;
    var isLeft = midX < maxWidth * 0.5;

    return OverlayEntry(
      builder: (context) => Positioned(
        top: _top,
        left: isLeft ? _left : null,
        right: !isLeft ? _right : null,
        child: GestureDetector(
          onPanStart: (d) {
            isLeft = d.globalPosition.dx < maxWidth * 0.5;
            // DLog.d("onPanStart isLeft: $isLeft, $d");
          },
          onPanUpdate: (details) {
            if (details.globalPosition.dx <= leftMin || details.globalPosition.dx >= leftMax) {
              return;
            }
            if (details.globalPosition.dy <= topMin || details.globalPosition.dy >= topMax) {
              return;
            }

            _left = details.globalPosition.dx - buttonHorizalHalf;
            _top = details.globalPosition.dy - buttonVerticalHalf;
            _right = maxWidth - _left - currButtonSize.width;
            _overlayEntry.markNeedsBuild();
          },
          onPanEnd: (DragEndDetails e) {
            // debugPrint("_leftVN.value:${_leftVN.value}");
            final midX = _left + currButtonSize.width / 2;
            final midY = _top + currButtonSize.height / 2;

            final isLeftTmp = midX < maxWidth * 0.5;
            if (attachHorizalEdge) {
              if (isLeftTmp) {
                _left = padding.left;
              } else {
                _left = maxWidth - currButtonSize.width - padding.right;
              }
              _right = maxWidth - _left - currButtonSize.width;
              _overlayEntry.markNeedsBuild();

              if (!_isExpanded && draggableFloatingButtonConfig.rotationY == true) {
                var radians = isLeftTmp != isLeft ? pi : 0.0;
                currButton = Transform(
                  transform: Matrix4.rotationY(radians),
                  alignment: Alignment.center,
                  child: currButton,
                );
              }
            }
          },
          child: Material(
            color: Colors.transparent,
            shape: Border.all(color: Colors.red),
            child: SizedBox(
              width: currButtonSize.width,
              height: currButtonSize.height,
              child: InkWell(
                onTap: _onMarkNeedsBuild,
                child: currButton,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// DraggableFloatingButtonMixin 拖拽按钮配置类
  // DraggableFloatingButtonConfig get draggableFloatingButtonConfig => throw UnimplementedError("❌$this 未实现 draggableFloatingButtonConfig");
  DraggableFloatingButtonConfig get draggableFloatingButtonConfig {
    return DraggableFloatingButtonConfig(
      buttonSize: _floatingButtonSize(),
      buttonMargin: _floatingButtonMargin(),
      button: _floatingButton(),
    );
  }

  Widget _floatingButton() {
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
  Size _floatingButtonSize() {
    return Size(60, 60);
  }

  EdgeInsets _floatingButtonMargin() {
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

  void _onMarkNeedsBuild() {
    if (draggableFloatingButtonConfig.expandedButton == null) {
      draggableFloatingButtonConfig.onButton?.call();
      return;
    }
    _isExpanded = !_isExpanded;
    floatingButtonHide();
    floatingButtonShow();
  }
}
