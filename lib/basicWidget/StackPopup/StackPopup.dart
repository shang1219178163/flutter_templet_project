import 'package:flutter/material.dart';

class StackPopupController {
  OverlayEntry? _entry;

  bool get isShowing => _entry != null;

  void dismiss() {
    _entry?.remove();
    _entry = null;
  }

  void show({
    required BuildContext context,
    required Alignment from,
    required WidgetBuilder builder,
    Color backgroundColor = const Color(0x66000000),
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
    required Widget child,
  }) {
    if (_entry != null) {
      return;
    }
    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            child,
            Positioned.fill(
              child: _StackPopup(
                from: from,
                builder: builder,
                backgroundColor: backgroundColor,
                duration: duration,
                curve: curve,
                onDismiss: dismiss,
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }
}

class _StackPopup extends StatefulWidget {
  const _StackPopup({
    required this.from,
    required this.builder,
    required this.backgroundColor,
    required this.duration,
    required this.curve,
    required this.onDismiss,
  });

  final Alignment from;
  final WidgetBuilder builder;
  final Color backgroundColor;
  final Duration duration;
  final Curve curve;
  final VoidCallback onDismiss;

  @override
  State<_StackPopup> createState() => _StackPopupState();
}

class _StackPopupState extends State<_StackPopup> with SingleTickerProviderStateMixin {
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

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _offset = Tween<Offset>(
      begin: Offset(widget.from.x.sign, widget.from.y.sign),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.builder(context);
    if (widget.from == Alignment.center) {
      return FadeTransition(
        opacity: _opacity,
        child: content,
      );
    }
    return SlideTransition(
      position: _offset,
      child: content,
    );
  }
}
