import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DrawImageNineDemo extends StatefulWidget {

  final String? title;

  const DrawImageNineDemo({ Key? key, this.title}) : super(key: key);


  @override
  _DrawImageNineDemoState createState() => _DrawImageNineDemoState();
}

class _DrawImageNineDemoState extends State<DrawImageNineDemo> {
  late ui.Image image;
  bool isImageloaded = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: _buildImage(),
        )
    );
  }

  Future <Null> init() async {
    try {
      final data = await rootBundle.load('images/weiqi.png');
      var bytes = Uint8List.view(data.buffer);
      image = await loadImage(bytes);
      setState(() {
        isImageloaded = true;
      });
    }
    catch (e) {
    }

  }

  Future<ui.Image> loadImage(Uint8List bytes) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget _buildImage() {
    final screenSize = MediaQuery.of(context).size;
    if (isImageloaded) {
      return CustomPaint(
        // size: screenSize,
        size: Size(screenSize.width, screenSize.width),
        painter: ImageEditor(image: image),
      );
    } else {
      return Center(child: Text('loading'));
    }
  }
}


class ImageEditor extends CustomPainter {

  ui.Image image;

  ImageEditor({
    required this.image,
  });


  @override
  void paint(Canvas canvas, Size size) {

    print('paint');
    print('paint size $size');
    print('paint center ${size.center(Offset.zero)}');

    // Paint paint = Paint();
    // canvas.drawImage(image, Offset.zero, Paint());

    // Rect src = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    // Rect dst = Rect.fromLTWH(0, 0, 300, 300);
    // canvas.drawImageRect(image, src, dst, Paint());

    var center = Rect.fromCenter(
        center: size.center(Offset.zero),
        width: 50,
        height: 50
    );
    print('paint center $center');

    var dst = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width.toDouble() *1,
      height: size.height.toDouble() *1,
    );
    canvas.drawImageNine(image, center, dst, Paint());

    // Rect rect = Rect.fromCenter(center: Offset(200,200), width: 200, height: 200);
    var paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth=2;
    canvas.drawRect(center, paint);

  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}