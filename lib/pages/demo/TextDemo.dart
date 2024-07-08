import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'dart:ui' as ui;

import 'package:flutter_templet_project/extension/widget_ext.dart';

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
        Text(
          'Hello, Flutter developers! This is a '
          'sample text to demonstrate '
          'ParagraphStyle.',
          style: DefaultTextStyle.of(context).style,
          maxLines: 1000,
        ),
      ),
    );
  }
}

class MyTextPainter extends CustomPainter {
  MyTextPainter(
    this.text,
  );
  final Text text;

  @override
  void paint(Canvas canvas, Size size) {
    if (text.data?.isNotEmpty != true) {
      return;
    }
    var textStyle = text.style;

    var paragraphStyle = ui.ParagraphStyle(
      textAlign: text.textAlign ?? TextAlign.start,
      textDirection: text.textDirection ?? TextDirection.ltr,
      maxLines: text.maxLines,
      textHeightBehavior: text.textHeightBehavior ?? TextHeightBehavior(),
      fontFamily: textStyle?.fontFamily,
      fontSize: textStyle?.fontSize,
      height: textStyle?.height,
      fontWeight: textStyle?.fontWeight,
      fontStyle: textStyle?.fontStyle,
      locale: textStyle?.locale,
      ellipsis: '...',
    );

    var paragraphBuilder = ui.ParagraphBuilder(paragraphStyle);
    if (textStyle != null) {
      paragraphBuilder.pushStyle(ui.TextStyle(
        color: Colors.black,
      ));
    }
    paragraphBuilder.addText(text.data ?? "");

    var paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: size.width));

    canvas.drawParagraph(paragraph, Offset(0, 0));
  }

  @override
  bool shouldRepaint(MyTextPainter oldDelegate) {
    return text != oldDelegate.text;
  }
}
