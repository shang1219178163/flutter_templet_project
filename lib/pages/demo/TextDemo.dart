import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'dart:ui' as ui;

/// TextStyle 研究
class TextDemo extends StatefulWidget {
  TextDemo({super.key, this.title});

  final String? title;

  @override
  State<TextDemo> createState() => _TextDemoState();
}

class _TextDemoState extends State<TextDemo> {
  final _scrollController = ScrollController();

  final textDecorations = [
    TextDecoration.none,
    TextDecoration.underline,
    TextDecoration.overline,
    TextDecoration.lineThrough,
  ];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...textDecorations.map((e) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "$e",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    decoration: e,
                    backgroundColor: Colors.blue.withOpacity(0.12),
                  ),
                ),
              );
            }).toList(),
            buildPaintText(),
          ],
        ),
      ),
    );
  }

  Widget buildPaintText() {
    return CustomPaint(
      size: Size(300, 200),
      painter: MyTextPainter(
          'Hello, Flutter developers! This is a sample text to demonstrate '
          'ParagraphStyle.',
          style: ui.TextStyle()),
    );
  }
}

class MyTextPainter extends CustomPainter {
  MyTextPainter(
    this.text, {
    this.style,
  });
  final String text;
  final ui.TextStyle? style;

  @override
  void paint(Canvas canvas, Size size) {
    var paragraphStyle = ui.ParagraphStyle(
      // textAlign: TextAlign.center,
      // maxLines: null,
      // ellipsis: '...',
      textDirection: TextDirection.ltr,
      // fontWeight: FontWeight.bold,
      fontSize: 17,
    );

    var textStyle = style ??
        ui.TextStyle(
          color: Colors.black,
        );

    var paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(text);

    if (style != null) {
      paragraphBuilder.pushStyle(style! as ui.TextStyle);
    }

    var paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: size.width));

    canvas.drawParagraph(paragraph, Offset(0, 0));
  }

  @override
  bool shouldRepaint(MyTextPainter oldDelegate) {
    return text != oldDelegate.text;
  }
}
