import 'package:flutter/material.dart';

class NScaleButton extends StatefulWidget {
  const NScaleButton({
    super.key,
    this.enabled = true,
    required this.builder,
  });

  final bool enabled;

  final Widget Function(AnimationController animationController) builder;

  @override
  State<NScaleButton> createState() => _NScaleButtonState();
}

class _NScaleButtonState extends State<NScaleButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Listener(
        onPointerUp: (e) async {
          if (!widget.enabled) {
            return;
          }
          // if (_controller.isCompleted) {
          //   _controller.reverse();
          // } else {
          //   _controller.forward();
          // }
          await _controller.forward();
          await _controller.reverse();
        },
        child: widget.builder(_controller),
      ),
    );
  }
}
