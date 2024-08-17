import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

class SvgaImageDemo extends StatefulWidget {
  final String? title;

  const SvgaImageDemo({Key? key, this.title}) : super(key: key);

  @override
  _SvgaImageDemoState createState() => _SvgaImageDemoState();
}

class _SvgaImageDemoState extends State<SvgaImageDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      child: SVGASimpleImage(
          resUrl:
              "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"),
    );
  }
}
