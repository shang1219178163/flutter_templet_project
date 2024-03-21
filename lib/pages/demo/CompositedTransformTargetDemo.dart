
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_list_view_segment_control.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/alignment_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


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


  Alignment followerAnchor = Alignment.centerLeft;
  Alignment targetAnchor = Alignment.centerRight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Get.to(() => CustomSlideDemo());
          },)
        ).toList(),
        elevation: 0,
        bottom: buildTab(),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.yellow,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          alignment: Alignment.center,
          child: GestureDetector(
            // onTap: _toggleOverlay,
            // onPanStart: (e) => _showOverlay(),
            // onPanEnd: (e) => _hideOverlay(),
            // onPanUpdate: updateIndicator,
            onLongPressStart: (e) => _showOverlay(),
            onLongPressEnd: (e) => _hideOverlay(),
            onLongPressMoveUpdate: updateIndicatorLongPress,
            child: CompositedTransformTarget(
              link: layerLink,
              child: Image.asset(
                "assets/images/avatar.png",
                width: 80, height: 80,
              ).toColoredBox(),
            ),
          ),
        ),
      ),
    );
  }

  ///设置单个宽度
  Widget buildListViewHorizontal({
    String title = "",
    required ValueChanged<int> onChanged,
    int index = 0
  }) {
    var items = AlignmentExt.allCases.map((e) => e.toString().split(".").last).toList();
    return Row(
      children: [
        if(title.isNotEmpty)NText(title),
        Expanded(
          child: NListViewSegmentControl(
            items: items,
            // itemWidths: itemWiths,
            selectedIndex: index,
            onValueChanged: (val){
              debugPrint(val.toString());
              onChanged.call(val);
            }
          ),
        ),
      ],
    );
  }

  PreferredSize buildTab() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.greenAccent,
          // border: Border.all(color: Colors.yellow),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildListViewHorizontal(
              title: "Target:",
              onChanged: (int value) {
                targetAnchor = AlignmentExt.allCases[value];
                debugPrint("targetAnchor: $targetAnchor");
                _overlayEntry.markNeedsBuild();
              }
            ),
            SizedBox(height: 8,),
            buildListViewHorizontal(
              title: "Follower:",
              onChanged: (int value) {
                followerAnchor = AlignmentExt.allCases[value];
                debugPrint("followerAnchor: $followerAnchor");
                _overlayEntry.markNeedsBuild();
              }
            ),
          ],
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
    _overlayEntry.remove();
  }

  void updateIndicator(DragUpdateDetails details) {
    indicatorOffset = details.localPosition;
    _overlayEntry.markNeedsBuild();
  }


  void updateIndicatorLongPress(LongPressMoveUpdateDetails details) {
    indicatorOffset = details.localPosition;
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry(Offset localPosition) {
    indicatorOffset = localPosition;
    return OverlayEntry(
      builder: (BuildContext context) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: layerLink,
          // offset: indicatorOffset,
          followerAnchor: followerAnchor,
          targetAnchor: targetAnchor,
          // offset: Offset(5,0),
          child: Material(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5)
              ),
              padding: const EdgeInsets.all(10),
              width: 50,
              height: 100,
              child: const Text("toly",style: TextStyle(color: Colors.white),)
            ),
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
  OverlayEntry? _overlayEntry;

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
    _overlayEntry = OverlayEntry(
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
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void updateIndicator(DragUpdateDetails details) {
    indicatorOffset = getIndicatorOffset(details.localPosition);
    _overlayEntry?.markNeedsBuild();
  }

  void hideIndicator(DragEndDetails details) {
    _overlayEntry?.remove();
  }


}