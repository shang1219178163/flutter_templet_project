import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_header.dart';

class OverlayPortalDemo extends StatefulWidget {
  OverlayPortalDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<OverlayPortalDemo> createState() => _OverlayPortalDemoState();
}

class _OverlayPortalDemoState extends State<OverlayPortalDemo> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
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
            NSectionHeader(
              title: "OverlayPortal",
              child: buildOverlayPortal(),
            ),
          ],
        ),
      ),
    );
  }

  final _portalController = OverlayPortalController();

  Widget buildOverlayPortal() {
    return TextButton(
      onPressed: _portalController.toggle,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
        child: OverlayPortal(
          controller: _portalController,
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
          child: const Text('Press to show/hide tooltip'),
        ),
      ),
    );
  }
}
