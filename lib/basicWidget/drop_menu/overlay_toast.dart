import 'package:flutter/material.dart';

class OverlayToast {
  static final OverlayToast _instance = OverlayToast._();
  OverlayToast._();
  factory OverlayToast() => _instance;
  static OverlayToast get instance => _instance;

  OverlayEntry? _entry;

  dismiss() {
    _entry?.remove();
    _entry = null;
  }

  void show(
    BuildContext context, {
    required Widget child,
    Duration showDuration = const Duration(milliseconds: 800),
    Duration fadeDuration = const Duration(milliseconds: 350),
    Tween<Offset>? offset,
    bool autoDismiss = true,
  }) {
    dismiss();

    late AnimationController controller;

    _entry = OverlayEntry(
      builder: (context) {
        if (!autoDismiss) {
          return child;
        }
        return _AnimatedOverlay(
          showDuration: showDuration,
          fadeDuration: fadeDuration,
          offset: offset,
          onInit: (c) => controller = c,
          onDispose: dismiss,
          child: child,
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }
}

/// 显示然后消失图层
class _AnimatedOverlay extends StatefulWidget {
  const _AnimatedOverlay({
    required this.child,
    required this.showDuration,
    required this.fadeDuration,
    required this.onInit,
    required this.onDispose,
    this.offset,
  });

  final Widget child;
  final Duration showDuration;
  final Duration fadeDuration;
  final ValueChanged<AnimationController> onInit;
  final VoidCallback onDispose;

  final Tween<Offset>? offset;

  @override
  State<_AnimatedOverlay> createState() => _AnimatedOverlayState();
}

class _AnimatedOverlayState extends State<_AnimatedOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    _controller = AnimationController(vsync: this, duration: widget.fadeDuration);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _offset = (widget.offset ?? Tween(begin: const Offset(0, 0), end: const Offset(0, 0.05))).animate(_opacity);

    widget.onInit(_controller);
    _controller.forward();

    Future.delayed(widget.showDuration, () async {
      if (!mounted) {
        return;
      }
      await _controller.reverse();
      widget.onDispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _opacity,
          child: SlideTransition(
            position: _offset,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
