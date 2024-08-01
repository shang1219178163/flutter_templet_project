import 'package:flutter/material.dart';

class NFadeTransition extends StatefulWidget {
  NFadeTransition({
    super.key,
    this.duration = const Duration(seconds: 1),
    required this.child,
  });

  final Widget child;

  final Duration duration;

  @override
  _NFadeTransitionState createState() => _NFadeTransitionState();
}

class _NFadeTransitionState extends State<NFadeTransition>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _animation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(_controller);

  @override
  void initState() {
    super.initState();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
