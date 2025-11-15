import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class OverlayDemoOne extends StatefulWidget {
  OverlayDemoOne({super.key, this.title});

  final String? title;

  @override
  State<OverlayDemoOne> createState() => _OverlayDemoOneState();
}

class _OverlayDemoOneState extends State<OverlayDemoOne> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    overlayEntry?.remove(); //移除
    overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),
            OutlinedButton(
              onPressed: () {
                clickShow();
              },
              child: Text("show"),
            )
          ],
        ),
      ),
    );
  }

  OverlayEntry? overlayEntry;
  double overlayWidth = 100;
  Offset offset = Offset.zero;

  double get screenWidth => context.screenSize.width;

  clickShow() {
    if (overlayEntry != null) {
      return;
    }
    overlayEntry ??= _showOverlay();
    //往Overlay中插入插入OverlayEntry
    Overlay.of(context).insert(overlayEntry!);
  }

  OverlayEntry _showOverlay() {
    var overlayEntry = OverlayEntry(builder: (context) {
      //外层使用Positioned进行定位，控制在Overlay中的位置
      // 控制不可拖出屏幕外
      var dx = 110.0;
      var dy = 110.0;

      if ((offset.dx > 0) && ((offset.dx + overlayWidth) < ScreenUtil().screenWidth)) {
        dx = offset.dx;
      } else if ((offset.dx + overlayWidth) >= ScreenUtil().screenWidth) {
        dx = ScreenUtil().screenWidth - overlayWidth;
      } else {
        dx = 0;
      }

      if ((offset.dy > 0) && ((offset.dy + overlayWidth) < ScreenUtil().screenHeight)) {
        dy = offset.dy;
      } else if ((offset.dy + overlayWidth) >= ScreenUtil().screenHeight) {
        dy = ScreenUtil().screenWidth - overlayWidth;
      } else {
        dy = 0;
      }

      return Positioned(
        top: dy,
        left: dx,
        child: Draggable(
          feedback: feedback(),
          childWhenDragging: childWhenDragging(), //拖动过程回调
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            this.offset = offset;
            setState(() {});
          },
          child: _contentBody(),
        ),
      );
    });
    return overlayEntry;
  }

  Widget childWhenDragging() {
    return Container(
      color: Colors.blueAccent,
      width: overlayWidth,
      height: overlayWidth,
    );
  }

  Widget _contentBody() {
    return Container(
      color: Colors.red,
      width: overlayWidth,
      height: overlayWidth,
    );
  }

  Widget feedback() {
    return Container(
      color: Colors.green,
      width: overlayWidth * 1.5,
      height: overlayWidth * 1.5,
    );
  }
}
