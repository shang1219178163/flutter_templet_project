import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

class TapRegionDemo extends StatefulWidget {
  TapRegionDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<TapRegionDemo> createState() => _TapRegionDemoState();
}

class _TapRegionDemoState extends State<TapRegionDemo> {
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
            TapRegion(
              onTapInside: (tap) {
                debugPrint('On Tap Inside!!');
              },
              onTapOutside: (tap) {
                debugPrint('On Tap Outside!!');
              },
              child: OutlinedButton(
                  onPressed: () {
                    ToastUtil.show("text");
                  },
                  child: Text("$widget")),
            )
          ],
        ),
      ),
    );
  }
}
