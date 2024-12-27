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
class FloatingButtonConfig {
  FloatingButtonConfig({
    this.globalPosition,
    required this.buttonMargin,
    required this.buttonSize,
    required this.button,
    this.expandedButtonSize,
    this.expandedButton,
    this.rotationY = true,
    this.draggable = true,
    this.onChanged,
  });

  /// 悬浮按钮外边距
  final EdgeInsets buttonMargin;

  final Offset? globalPosition;

  /// 悬浮按钮尺寸
  final Size buttonSize;

  /// 悬浮按钮
  final Widget Function(VoidCallback onToggle) button;

  /// 悬浮按钮尺寸
  final Size? expandedButtonSize;

  /// 悬浮按钮
  final Widget Function(VoidCallback onToggle)? expandedButton;

  /// Y 轴旋转
  final bool? rotationY;

  /// 是否可拖拽
  final bool? draggable;

  /// 改变回调
  final ValueChanged<bool>? onChanged;

  FloatingButtonConfig copyWith({
    Offset? globalPosition,
    EdgeInsets? buttonMargin,
    Size? buttonSize,
    Widget Function(VoidCallback onToggle)? button,
    Size? expandedButtonSize,
    Widget Function(VoidCallback onToggle)? expandedButton,
    VoidCallback? onButton,
    bool? rotationY,
    bool? draggable,
    ValueChanged<bool>? onChanged,
  }) {
    return FloatingButtonConfig(
      globalPosition: globalPosition ?? this.globalPosition,
      buttonMargin: buttonMargin ?? this.buttonMargin,
      buttonSize: buttonSize ?? this.buttonSize,
      button: button ?? this.button,
      expandedButtonSize: expandedButtonSize ?? this.expandedButtonSize,
      expandedButton: expandedButton ?? this.expandedButton,
      rotationY: rotationY ?? this.rotationY,
      draggable: draggable ?? this.draggable,
      onChanged: onChanged ?? this.onChanged,
    );
  }
}

/// 浮动拖拽按钮
mixin FloatingButtonMixin<T extends StatefulWidget> on State<T> {
  late OverlayEntry _overlayEntry;
  final _entries = <OverlayEntry>[];
  List<OverlayEntry> get entries => _entries;

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
      if (!mounted) {
        return;
      }

      final screenSize = MediaQuery.of(context).size;
      final maxWidth = screenSize.width;

      final defaultPosition = floatingButtonConfig.globalPosition ?? Offset(maxWidth, 120);
      _top = defaultPosition.dy;
      _left = defaultPosition.dx;
      _right = maxWidth - defaultPosition.dx;

      floatingButtonShow();
    });
  }

  OverlayEntry _createOverlayEntry({
    bool attachHorizalEdge = true,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width;
    final maxHeight = screenSize.height;

    var button = floatingButtonConfig.button;
    var expandedButton = floatingButtonConfig.expandedButton ?? button;
    Widget currButton = (_isExpanded ? expandedButton(_rebuild) : button(_rebuild));

    var buttonSize = floatingButtonConfig.buttonSize;
    var expandedButtonSize = floatingButtonConfig.expandedButtonSize ?? buttonSize;
    var currButtonSize = _isExpanded ? expandedButtonSize : buttonSize;
    var buttonHorizalHalf = currButtonSize.width * 0.5;
    var buttonVerticalHalf = currButtonSize.height * 0.5;

    var padding = floatingButtonConfig.buttonMargin;
    var leftMin = max(buttonHorizalHalf, padding.left);
    var leftMax = maxWidth - max(buttonHorizalHalf, padding.right);

    var topMin = max(buttonVerticalHalf, padding.top) + buttonVerticalHalf;
    var topMax = maxHeight - max(buttonVerticalHalf, padding.bottom);

    var midX = _left + currButtonSize.width / 2;
    var isLeft = midX < maxWidth * 0.5;

    return OverlayEntry(
      builder: (context) => Positioned(
        top: _top,
        left: isLeft ? _left : null,
        right: !isLeft ? _right : null,
        // bottom: 0,
        child: GestureDetector(
          onPanStart: (d) {
            isLeft = d.globalPosition.dx < maxWidth * 0.5;
            // DLog.d("onPanStart isLeft: $isLeft, $d");
          },
          onPanUpdate: (details) {
            if (floatingButtonConfig.draggable != true) {
              return;
            }

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
            if (floatingButtonConfig.draggable != true) {
              return;
            }

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

              if (!_isExpanded && floatingButtonConfig.rotationY == true) {
                var radians = isLeftTmp != isLeft ? pi : 0.0;
                currButton = AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.rotationY(radians),
                  transformAlignment: Alignment.center,
                  alignment: isLeftTmp ? Alignment.centerLeft : Alignment.centerRight,
                  child: currButton,
                );
              }
            }
          },
          child: Material(
            color: Colors.transparent,
            // shape: Border.all(color: Colors.red),
            child: SizedBox(
              width: currButtonSize.width,
              height: currButtonSize.height,
              child: currButton,
            ),
          ),
        ),
      ),
    );
  }

  /// DraggableFloatingButtonMixin 拖拽按钮配置类
  FloatingButtonConfig get floatingButtonConfig {
    return FloatingButtonConfig(
      buttonMargin: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top + kToolbarHeight,
        bottom: MediaQuery.of(context).viewPadding.bottom + kBottomNavigationBarHeight,
        left: 4,
        right: 4,
      ),
      buttonSize: Size(60, 60),
      button: (onToggle) => Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Icon(
            Icons.circle_notifications_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }

  /// 悬浮按钮展示/隐藏切换
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
    // _entries.remove(_overlayEntry);
    // _overlayEntry.remove();
    final list = [...entries];
    for (final e in list) {
      _entries.remove(e);
      e.remove();
    }
  }

  /// 插入新 OverlayEntry
  insertOverlayEntry(int index, OverlayEntry overlayEntry) {
    if (_entries.contains(overlayEntry)) {
      return;
    }
    _entries.insert(index, overlayEntry);
    Overlay.of(context).insert(overlayEntry);
  }

  /// 溢出 OverlayEntry
  hideOverlayEntry(int index) {
    // assert(index < entries.length, "索引必须 小于数组长度");
    if (index >= entries.length) {
      return false;
    }
    final e = entries[index];
    _entries.remove(e);
    e.remove();
  }

  void _rebuild() {
    if (floatingButtonConfig.expandedButton == null) {
      floatingButtonConfig.onChanged?.call(_isExpanded);
      return;
    }
    _isExpanded = !_isExpanded;
    floatingButtonConfig.onChanged?.call(_isExpanded);
    floatingButtonHide();
    floatingButtonShow();
  }
}
