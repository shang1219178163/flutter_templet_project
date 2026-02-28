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
          ],
        ),
      ),
    );
  }

  final portalController = OverlayPortalController();

  Widget buildOverlayPortal() {
    return TextButton(
      onPressed: portalController.toggle,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
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
}
