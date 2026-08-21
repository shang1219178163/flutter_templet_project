import 'package:flutter/material.dart';

class NAnimatedBreathing extends StatefulWidget {
  const NAnimatedBreathing({
    super.key,
    required this.onTap,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
  });

  final VoidCallback onTap;
  final Widget child;

  final Duration duration;

  @override
  State<NAnimatedBreathing> createState() => _NAnimatedBreathingState();
}

class _NAnimatedBreathingState extends State<NAnimatedBreathing>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  bool _pressed = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );

    /// 无限往返
    _controller.repeat(reverse: true);
  }

  /// App 生命周期
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _startBreathing();
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _stopBreathing();
        break;
    }
  }

  void _startBreathing() {
    if (!_pressed && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  void _stopBreathing() {
    // debugPrint(["_stopBreathing", _pressed, _controller.isAnimating].join(", "));
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  Future<void> _handleTap() async {
    /// 点击时暂停呼吸
    _pressed = true;
    _stopBreathing();
    try {
      widget.onTap();
    } finally {
      /// 恢复呼吸
      _pressed = false;
      if (mounted) {
        _startBreathing();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleTap,
          child: widget.child,
        ),
        builder: (_, child) {
          final opacity = 0.92 + (_controller.value * 0.08);
          return Transform.scale(
            scale: _scale.value,
            child: AnimatedOpacity(
              duration: widget.duration,
              opacity: opacity,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
