// code from: https://github.com/matthew-carroll/flutter_ui_challenge_feature_discovery
// TODO: Use https://github.com/matthew-carroll/fluttery/blob/master/lib/src/layout_overlays.dart
import 'package:flutter/material.dart';

class AnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
  final Widget child;

  AnchoredOverlay({
    super.key,
    required this.showOverlay,
    required this.overlayBuilder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {

          return OverlayBuilder(
            showOverlay: showOverlay,
            overlayBuilder: (BuildContext overlayContext) {
              var box = context.findRenderObject() as RenderBox?;
              var center = box?.size.center(box.localToGlobal(const Offset(0.0, 0.0)));
              center ??= Offset(0.0, 0.0);
              return overlayBuilder(overlayContext, center!);
            },
            child: child,
          );
        }
      ),
    );
  }
}

class OverlayBuilder extends StatefulWidget {
  final bool showOverlay;
  final WidgetBuilder overlayBuilder;
  final Widget child;

  OverlayBuilder({
    super.key,
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  });

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  late OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay) {
      hideOverlay();
    }

    super.dispose();
  }

  bool get isShowingOverlay => overlayEntry != null;

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: widget.overlayBuilder,
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  void hideOverlay() {
    debugPrint('hideOverlay');
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay && widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CenterAbout extends StatelessWidget {
  final Offset position;
  final Widget child;

  CenterAbout({
    super.key,
    required this.position,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}