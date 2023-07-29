

import 'package:flutter/material.dart';

/// 滑动动画构造器
class SlideTransitionBuilder extends StatefulWidget {

  SlideTransitionBuilder({
    Key? key,
    this.duration = const Duration(milliseconds: 350),
    this.alignment = Alignment.bottomCenter,
    this.hasFade = true,
    this.child,
  }) : super(key: key);

  /// 目标位置
  final Alignment alignment;
  /// 动画时间
  final Duration duration;
  /// 是否有 fade 动画
  final bool hasFade;
  /// 子组件
  final Widget? child;

  @override
  _SlideTransitionBuilderState createState() => _SlideTransitionBuilderState();
}

class _SlideTransitionBuilderState extends State<SlideTransitionBuilder> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation;

  Tween<Offset> get tween {
    // debugPrint("widget.alignment:${widget.alignment} ${widget.alignment.y}");
    if ([-1, 1].contains(widget.alignment.y)) {
      return Tween<Offset>(
        begin: Offset(0, widget.alignment.y),
        end: const Offset(0, 0.0),
      );
    }

    if ([-1, 1].contains(widget.alignment.x)) {
      return Tween<Offset>(
        begin: Offset(widget.alignment.x, 0),
        end: const Offset(0, 0.0),
      );
    }

    return Tween<Offset>(
      begin: Offset(0, 0),
      end: const Offset(0, 0.0),
    );
  }

  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();

    _offsetAnimation = tween.animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Align(
      alignment: widget.alignment,
      child: widget.child ?? Container(
        height: 300,
        width: 300,
        color: Colors.red,
        child: FlutterLogo(size: 200,),
      ),
    );
    if (widget.hasFade) {
      content = FadeTransition(
        opacity: _fadeAnimation,
        child: content,
      );
    }

    return SlideTransition(
      position: _offsetAnimation,
      child: content,
    );
  }

}
