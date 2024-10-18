import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';

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
    final text =
        "刚开始进行搜索，发现很多都是让在每段开始的时候采用空格进行填充，但是采用这种形式之后，不知道为何首行直接溢出了，最后采用下面方法进行实现的。";
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
            NSectionBox(
              title: "MyTextPainter",
              child: buildPaintText(),
            ),
            NSectionBox(
              title: "justify",
              child: Container(
                width: 200,
                child: RichText(
                  text: TextSpan(
                    children: [
                      // WidgetSpan(
                      //   child: Container(
                      //     width: 20, // 首行缩进的宽度
                      //     height: 0,
                      //   ),
                      // ),
                      TextSpan(
                        text: text.substring(0, 16), // 主体文本
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      )
                    ],
                  ),
                  textAlign: TextAlign.justify, // 设置两端对齐
                ),
              ),
            ),
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
