import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';

class OverlayPortalDemo extends StatefulWidget {
  OverlayPortalDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<OverlayPortalDemo> createState() => _OverlayPortalDemoState();
}

class _OverlayPortalDemoState extends State<OverlayPortalDemo> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            NSectionBox(
              title: "OverlayPortal",
              child: buildOverlayPortal(),
            ),
            // NSectionBox(
            //   title: "OverlayPortal.overlayChildLayoutBuilder",
            //   child: buildOverlayChildLayoutBuilder(),
            // ),
          ],
        ),
      ),
    );
  }

  final portalController = OverlayPortalController();

  Widget buildOverlayPortal() {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
      child: TextButton(
        onPressed: portalController.toggle,
        child: OverlayPortal(
          controller: portalController,
          overlayChildBuilder: (BuildContext context) {
            return Positioned(
              right: 30,
              bottom: 30,
              child: Container(
                width: 300,
                height: 200,
                color: Colors.amberAccent,
                child: Text('tooltip'),
              ),
            );
          },
          child: Text('show/hide'),
        ),
      ),
    );
  }

  // /// Flutter3.38
  // Widget buildOverlayChildLayoutBuilder() {
  //   return Center(
  //     child: OverlayPortal.overlayChildLayoutBuilder(
  //       controller: _controller,
  //       /// ****可以配置 root****
  //       overlayLocation: OverlayChildLocation.rootOverlay,
  //       child: ElevatedButton(
  //         onPressed: () => _controller.toggle(),
  //         child: const Text('点我显示浮层'),
  //       ),
  //       overlayChildBuilder: (context, info) {
  //         return Material(
  //           elevation: 6,
  //           color: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Container(
  //             padding: const EdgeInsets.all(16),
  //             child: const Text('这是一个浮层'),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
