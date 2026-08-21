//
//  NFloatingDraggable.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/15 18:47.
//  Copyright © 2026/4/15 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 可拖动悬浮组件
class NFloatingDraggable extends StatefulWidget {
  const NFloatingDraggable({
    super.key,
    this.offset = const Offset(8, 100),
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 100),
    this.onFinish,
    required this.child,
  });

  /// 初始位置
  final Offset offset;

  /// 屏幕边距
  final EdgeInsets margin;

  /// 悬浮组件
  final Widget child;

  /// 松手后位置
  final ValueChanged<Offset>? onFinish;

  @override
  State<NFloatingDraggable> createState() => _NFloatingDraggableState();
}

class _NFloatingDraggableState extends State<NFloatingDraggable> {
  late Offset offset = widget.offset;

  Size? _screenSize;
  Size? _childSize;

  @override
  Widget build(BuildContext context) {
    _screenSize ??= MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  offset += details.delta;
                  setState(() {});
                },
                onPanEnd: (_) {
                  _snapToEdge();
                },
                child: _measure(
                  widget.child,
                  onChange: (size) {
                    _childSize = size;
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 吸边逻辑
  void _snapToEdge() {
    if (_screenSize == null || _childSize == null) {
      return;
    }

    final screenW = _screenSize!.width;
    final childW = _childSize!.width;

    final middleX = offset.dx + childW / 2;

    double targetX;

    if (middleX > screenW / 2) {
      /// 👉 吸附右边
      targetX = screenW - childW - widget.margin.right;
    } else {
      /// 👉 吸附左边
      targetX = widget.margin.left;
    }

    /// Y 限制（防止出界）
    final maxY = _screenSize!.height - _childSize!.height - widget.margin.bottom;
    final minY = widget.margin.top;

    final targetY = offset.dy.clamp(minY, maxY);
    offset = Offset(targetX, targetY);
    widget.onFinish?.call(offset);
    setState(() {});
  }

  /// 获取子组件尺寸
  Widget _measure(Widget child, {required Function(Size) onChange}) {
    return MeasureSize(
      onChanged: onChange,
      child: child,
    );
  }
}

class MeasureSize extends StatefulWidget {
  const MeasureSize({
    super.key,
    required this.child,
    required this.onChanged,
  });

  final Widget child;
  final Function(Size size) onChanged;

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  final _key = GlobalKey();
  Size? _oldSize;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = _key.currentContext?.size;
      if (size != null && size != _oldSize) {
        _oldSize = size;
        widget.onChanged(size);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
