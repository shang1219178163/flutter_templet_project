

import 'package:flutter/material.dart';


class NFadeTransition extends StatefulWidget {

  NFadeTransition({
    Key? key, 
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _NFadeTransitionState createState() => _NFadeTransitionState();
}

class _NFadeTransitionState extends State<NFadeTransition> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
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