import 'package:flutter/material.dart';

/// 悬浮组件
class NSuspension extends StatefulWidget {
  NSuspension({
    Key? key,
    required this.child,
    required this.bgChild,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.padding = EdgeInsets.zero,
    this.childSize = const Size(100, 100),
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

  @override
  _NSuspensionState createState() => _NSuspensionState();
}

class _NSuspensionState extends State<NSuspension> {
  final _topVN = ValueNotifier(0.0);
  final _leftVN = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: widget.alignment,
        textDirection: widget.textDirection,
        fit: widget.fit,
        clipBehavior: widget.clipBehavior,
        children: [
          widget.bgChild,
          buildSuspension(
            child: widget.child,
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
          ),
        ],
      );
    });
  }

  buildSuspension(
      {required Widget child,
      required double maxWidth,
      required double maxHeight}) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _topVN,
          _leftVN,
        ]),
        child: child,
        builder: (context, child) {
          return Positioned(
              top: _topVN.value,
              left: _leftVN.value,
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
                  if (_topVN.value >
                          (maxHeight -
                              widget.childSize.height -
                              widget.padding.bottom) &&
                      e.delta.dy > 0) {
                    return;
                  }
                  // 下边
                  if (_leftVN.value >
                          (maxWidth -
                              widget.childSize.width -
                              widget.padding.right) &&
                      e.delta.dx > 0) {
                    return;
                  }
                  _topVN.value += e.delta.dy;
                  _leftVN.value += e.delta.dx;
                  // debugPrint("xy:${_leftVN.value},${_topVN.value}");
                },
                child: child,
              ));
        });
  }
}
