

import 'package:flutter/material.dart';

class NSizeTransition extends StatefulWidget {

  NSizeTransition({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _NSizeTransitionState createState() => _NSizeTransitionState();
}

class _NSizeTransitionState extends State<NSizeTransition> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
  );
  // late final Animation<double> _animation = Tween(
  //   begin: 0.0,
  //   end: 1.0,
  // ).animate(_controller);

  @override
  void initState() {
    super.initState();

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      //偏移量
      axisAlignment: 0.0,
      //动画控制
      sizeFactor: _controller,
      axis: Axis.vertical,
      child: widget.child,
    );
  }
}