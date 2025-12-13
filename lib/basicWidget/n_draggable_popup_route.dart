import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class NDraggablePopupRoute<T> extends PopupRoute<T> {
  NDraggablePopupRoute({
    required this.builder,
    required this.from,
    this.backgroundColor = const Color(0x66000000),
  });

  final WidgetBuilder builder;
  final Alignment from;
  final Color backgroundColor;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      color: backgroundColor,
      child: const SizedBox.expand(),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final content = DraggablePopup(
      alignment: from,
      child: builder(context),
    );

    if (from == Alignment.center) {
      return FadeTransition(opacity: animation, child: content);
    }

    return SlideTransition(
      position: animation.drive(
        Tween(begin: Offset(from.x.sign, from.y.sign), end: Offset.zero),
      ),
      child: content,
    );
  }

  @override
  String? get barrierLabel => "$runtimeType";
}

class DraggablePopup extends StatefulWidget {
  const DraggablePopup({
    super.key,
    required this.child,
    required this.alignment,
  });

  final Widget child;
  final Alignment alignment;

  @override
  State<DraggablePopup> createState() => _DraggablePopupState();
}

class _DraggablePopupState extends State<DraggablePopup> {
  final _controller = _PopupDragController();

  @override
  Widget build(BuildContext context) {
    final axis = _dragAxis(widget.alignment);

    return GestureDetector(
      onVerticalDragUpdate: (d) {
        if (axis != Axis.vertical) {
          return;
        }
        _controller.update(d.delta.dy);
        setState(() {});
      },
      onVerticalDragEnd: (d) {
        if (axis != Axis.vertical) {
          return;
        }
        _handleEnd(context);
      },
      onHorizontalDragUpdate: (d) {
        if (axis != Axis.horizontal) {
          return;
        }
        _controller.update(d.delta.dx);
        setState(() {});
      },
      onHorizontalDragEnd: (d) {
        if (axis != Axis.horizontal) {
          return;
        }
        _handleEnd(context);
      },
      child: Transform.translate(
        offset: axis == Axis.vertical ? Offset(0, _controller.offset) : Offset(_controller.offset, 0),
        child: widget.child,
      ),
    );
  }

  void _handleEnd(BuildContext context) {
    if (_controller.offset.abs() > 120) {
      Navigator.of(context).pop(); // ✅ 拖拽关闭
    } else {
      _controller.reset();
      setState(() {}); // 回弹
    }
  }

  Axis _dragAxis(Alignment a) {
    if (a == Alignment.center) {
      return Axis.vertical; // 无所谓
    }
    if (a.x.abs() > a.y.abs()) {
      return Axis.horizontal;
    }
    return Axis.vertical;
  }

  bool _isPositive(Alignment a) {
    return a.x + a.y > 0;
  }
}

class _PopupDragController {
  double offset = 0;
  bool isDragging = false;

  void update(double delta) {
    offset += delta;
  }

  void reset() {
    offset = 0;
    isDragging = false;
  }
}
