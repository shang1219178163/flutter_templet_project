
import 'package:flutter/material.dart';


class CompositedTransformTargetDemo extends StatefulWidget {

  CompositedTransformTargetDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _CompositedTransformTargetDemoState createState() => _CompositedTransformTargetDemoState();
}

class _CompositedTransformTargetDemoState extends State<CompositedTransformTargetDemo> {

  final LayerLink layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool show = false;
  Offset indicatorOffset = const Offset(0, 0);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: GestureDetector(
        onTap: _toggleOverlay,
        // onPanStart: (e) => _showOverlay(),
        // onPanEnd: (e) => _hideOverlay(),
        // onPanUpdate: updateIndicator,
        child: CompositedTransformTarget(
          link: layerLink,
          child: Image.asset(
            "assets/images/avatar.png",
            width: 80, height: 80,
          ),
        ),
      ),
    );
  }


  void _toggleOverlay() {
    if (!show) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
    show = !show;
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry(indicatorOffset);
    Overlay.of(context).insert(_overlayEntry);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
  }

  void updateIndicator(DragUpdateDetails details) {
    indicatorOffset = details.localPosition;
    _overlayEntry.markNeedsBuild();
  }


  OverlayEntry _createOverlayEntry(Offset localPosition) {
    indicatorOffset = localPosition;
    return OverlayEntry(
      builder: (BuildContext context) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: layerLink,
          // offset: indicatorOffset,
          followerAnchor: Alignment.centerLeft,
          targetAnchor: Alignment.centerRight,
          offset: Offset(5,0),
          child: Material(
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(10),
                width: 50,
                child: const Text("toly",style: TextStyle(color: Colors.white),)),
          ),
        ),
      ),
    );
  }
}


class CustomSlideDemo extends StatefulWidget {
  const CustomSlideDemo({Key? key}) : super(key: key);
  @override
  _CustomSlideDemoState createState() => _CustomSlideDemoState();
}
class _CustomSlideDemoState extends State {

  final double indicatorWidth = 24.0;
  final double indicatorHeight = 300.0;
  final double slideHeight = 200.0;
  final double slideWidth = 400.0;
  final LayerLink layerLink = LayerLink();
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: Center(
        child: CompositedTransformTarget(
          link: layerLink,
          child: Container(
            width: slideWidth,
            height: slideHeight,
            color: Colors.blue.withOpacity(0.2),
            child: GestureDetector(
              onPanStart: showIndicator,
              onPanUpdate: updateIndicator,
              onPanEnd: hideIndicator,
            ),
          ),
        ),
      ),
    );
  }

  Offset indicatorOffset = const Offset(0, 0);
  Offset getIndicatorOffset(Offset dragOffset) {
    final x = (dragOffset.dx - (indicatorWidth / 2.0))
        .clamp(0.0, slideWidth - indicatorWidth);
    final y = (slideHeight - indicatorHeight) / 2.0;
    return Offset(x, y);
  }

  void showIndicator(DragStartDetails details) {
    indicatorOffset = getIndicatorOffset(details.localPosition);
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: 0.0,
          left: 0.0,
          child: SizedBox(
            width: indicatorWidth,
            height: indicatorHeight,
            child: CompositedTransformFollower(
              offset: indicatorOffset,
              link: layerLink,
              child: Container(
                color: Colors.blue,
              ),
            )
          ),
        );
      },
    );
    Overlay.of(context)?.insert(overlayEntry!);
  }

  void updateIndicator(DragUpdateDetails details) {
    indicatorOffset = getIndicatorOffset(details.localPosition);
    overlayEntry?.markNeedsBuild();
  }

  void hideIndicator(DragEndDetails details) {
    overlayEntry?.remove();
  }


}