// code from: https://github.com/matthew-carroll/flutter_ui_challenge_feature_discovery
// TODO: Use https://github.com/matthew-carroll/fluttery/blob/master/lib/src/layout_overlays.dart
import 'package:flutter/material.dart';

class AnchoredOverlay extends StatelessWidget {

  AnchoredOverlay({
    super.key,
    required this.showOverlay,
    required this.overlayBuilder,
    required this.child,
  });
  final bool showOverlay;
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OverlayBuilder(
          showOverlay: showOverlay,
          overlayBuilder: (overlayContext) {
            var box = context.findRenderObject() as RenderBox?;
            var center = box?.size.center(box.localToGlobal(const Offset(0.0, 0.0)));
            center ??= Offset(0.0, 0.0);
            return overlayBuilder(overlayContext, center);
          },
          child: child,
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('showOverlay', showOverlay));
    properties.add(ObjectFlagProperty<Widget Function(BuildContext p1, Offset anchor)>.has('overlayBuilder', overlayBuilder));
  }
}

class OverlayBuilder extends StatefulWidget {

  OverlayBuilder({
    super.key,
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  });
  final bool showOverlay;
  final WidgetBuilder overlayBuilder;
  final Widget child;

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('showOverlay', showOverlay));
    properties.add(ObjectFlagProperty<WidgetBuilder>.has('overlayBuilder', overlayBuilder));
  }
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<OverlayEntry?>('overlayEntry', overlayEntry));
    properties.add(DiagnosticsProperty<bool>('isShowingOverlay', isShowingOverlay));
  }
}

class CenterAbout extends StatelessWidget {

  CenterAbout({
    super.key,
    required this.position,
    required this.child,
  });
  final Offset position;
  final Widget child;

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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Offset>('position', position));
  }
}
