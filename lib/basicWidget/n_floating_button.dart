import 'package:flutter/material.dart';

/// 悬浮组件
class NFloatingButton extends StatefulWidget {
  NFloatingButton({
    Key? key,
    required this.child,
    required this.bgChild,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.padding = EdgeInsets.zero,
    this.childSize = const Size(100, 100),
    this.attachHorizalEdge = false,
    this.attachVerticalEdge = false,
  }) : super(key: key);

  final AlignmentGeometry alignment;

  final TextDirection? textDirection;

  final StackFit fit;

  final Clip clipBehavior;

  /// 底部组件
  final Widget bgChild;

  /// 悬浮组件
  final Widget child;

  /// 悬浮组件宽高
  final Size childSize;

  /// 距离四周边界
  final EdgeInsets padding;

  /// 横向边界吸附
  final bool attachHorizalEdge;

  /// 垂直边界吸附
  final bool attachVerticalEdge;

  @override
  _NFloatingButtonState createState() => _NFloatingButtonState();
}

class _NFloatingButtonState extends State<NFloatingButton> {
  final _topVN = ValueNotifier(0.0);
  final _leftVN = ValueNotifier(0.0);
  final _rightVN = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final maxHeight = constraints.maxHeight;

      return Stack(
        alignment: widget.alignment,
        textDirection: widget.textDirection,
        fit: widget.fit,
        clipBehavior: widget.clipBehavior,
        children: [
          widget.bgChild,
          AnimatedBuilder(
            animation: Listenable.merge([
              _topVN,
              _leftVN,
              _rightVN,
            ]),
            child: widget.child,
            builder: (context, child) {
              final midX = _leftVN.value + widget.childSize.width / 2;
              final isLeft = midX < maxWidth * 0.5;

              return Positioned(
                top: _topVN.value,
                left: isLeft ? _leftVN.value : null,
                right: !isLeft ? _rightVN.value : null,
                child: GestureDetector(
                  onTap: () {
                    debugPrint("onTap");
                  },
                  onPanUpdate: (DragUpdateDetails e) {
                    // debugPrint("e.delta:${e.delta.dx},${e.delta.dy}");

                    //用户手指滑动时，更新偏移，重新构建
                    //顶部
                    if (_topVN.value < widget.padding.top && e.delta.dy < 0) {
                      return;
                    }
                    // 左边
                    if (_leftVN.value < widget.padding.left && e.delta.dx < 0) {
                      return;
                    }
                    // 右边
                    if (_topVN.value > (maxHeight - widget.childSize.height - widget.padding.bottom) &&
                        e.delta.dy > 0) {
                      return;
                    }
                    // 下边
                    if (_leftVN.value > (maxWidth - widget.childSize.width - widget.padding.right) && e.delta.dx > 0) {
                      return;
                    }
                    _topVN.value += e.delta.dy;
                    _leftVN.value += e.delta.dx;
                    _rightVN.value = maxWidth - _leftVN.value - widget.childSize.width;
                    debugPrint("xy:${_topVN.value},${_leftVN.value},${_rightVN.value}");
                  },
                  onPanEnd: (DragEndDetails e) {
                    // debugPrint("_leftVN.value:${_leftVN.value}");
                    final midX = _leftVN.value + widget.childSize.width / 2;
                    final midY = _topVN.value + widget.childSize.height / 2;

                    if (widget.attachHorizalEdge) {
                      if (midX < maxWidth * 0.5) {
                        _leftVN.value = widget.padding.left;
                      } else {
                        _leftVN.value = maxWidth - widget.childSize.width - widget.padding.right;
                      }
                    }

                    if (widget.attachVerticalEdge) {
                      if (midY < maxHeight * 0.5) {
                        _topVN.value = widget.padding.top;
                      } else {
                        _topVN.value = maxHeight - widget.childSize.height - widget.padding.bottom;
                      }
                    }
                  },
                  child: child,
                ),
              );
            },
          )
        ],
      );
    });
  }
}
