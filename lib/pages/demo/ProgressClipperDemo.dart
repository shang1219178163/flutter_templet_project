import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/CircleSectorProgressIndicator.dart';

class ProgressClipperDemo extends StatefulWidget {
  ProgressClipperDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ProgressClipperDemo> createState() => _ProgressClipperDemoState();
}

class _ProgressClipperDemoState extends State<ProgressClipperDemo> {
  final _scrollController = ScrollController();

  final progressVN = ValueNotifier(0.0);

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
                  onPressed: onPressed,
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
            // buildProgress(),
            CircleSectorProgressIndicator(
              width: 120,
              height: 180,
              progressVN: progressVN,
              // child: Image.asset(
              //   'assets/images/404.png',
              //   fit: BoxFit.cover,
              // ),
            ),
          ],
        ),
      ),
    );
  }

  onPressed() {
    final tmp = progressVN.value + 0.1;
    if (tmp >= 0.99) {
      progressVN.value = 0.0;
    } else {
      progressVN.value = tmp;
    }
  }

  buildProgress({double width = 120, double height = 160}) {
    return ValueListenableBuilder(
        valueListenable: progressVN,
        builder: (context, value, child) {
          debugPrint("value: $value");
          final precent = (value * 100).toInt().toStringAsFixed(0);
          final precentStr = "$precent%";

          return Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/bg.png',
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
              ClipPath(
                clipper: CircleSectorProgressClipper(
                  progress: value,
                ),
                child: Container(
                  width: width,
                  height: height,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Positioned(
                child: Text(
                  precentStr,
                  style: TextStyle(color: Color(0xffEDFBFF), fontSize: 24),
                ),
              )
            ],
          );
        });
  }
}
