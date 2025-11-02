import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/mixin/asset_resource_mixin.dart';

/// TextStyle 研究
class TextDemo extends StatefulWidget {
  TextDemo({super.key, this.title});

  final String? title;

  @override
  State<TextDemo> createState() => _TextDemoState();
}

class _TextDemoState extends State<TextDemo> with AssetResourceMixin {
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
    final text = "刚开始进行搜索，发现很多都是让在每段开始的时候采用空格进行填充，但是采用这种形式之后，不知道为何首行直接溢出了，最后采用下面方法进行实现"
        "的。";

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
                // width: 200,
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Container(
                          width: 28, // 首行缩进的宽度
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: text, // 主体文本
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      )
                    ],
                  ),
                  textAlign: TextAlign.justify, // 设置两端对齐
                ),
              ),
            ),
            buildTextTransform(),
            NSectionBox(
              title: "fontFamilyFallback",
              child: buildFont(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaintText() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
      ),
      child: CustomPaint(
        size: Size.fromHeight(60),
        painter: MyTextPainter(
          Text(
            'Hello, Flutter developers! This is a '
            'sample text to demonstrate '
            'ParagraphStyle.',
            style: DefaultTextStyle.of(context).style,
            maxLines: 1000,
          ),
        ),
      ),
    );
  }

  Widget buildTextTransform() {
    final sliderVN = ValueNotifier(0.0);
    return NSectionBox(
      title: "Matrix4.skewX",
      mainAxisSize: MainAxisSize.min,
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: sliderVN,
            builder: (context, value, child) {
              return Container(
                color: Colors.black,
                child: Transform(
                  alignment: Alignment.bottomLeft,
                  transform: Matrix4.skewX(-value),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xFFE8581C),
                    child: Text('Apartment for rent!'),
                  ),
                ),
              );
            },
          ),
          NSlider(
            max: 100,
            leading: Text('倾斜角度'),
            onChanged: (double value) {
              debugPrint('NNSlider onChangeEnd: $value');
              sliderVN.value = value / 100;
            },
            trailingBuilder: (context, value) {
              final result = "${value.toStringAsFixed(0)}%";
              return Text(result);
            },
          ),
        ],
      ),
    );
  }

  Widget buildFont() {
    return Container(
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          height: 2,
          // fontFamily: 'PingFang SC',
          // fontFamilyFallback: [
          //   "PingFang SC",
          //   "Heiti SC",
          //   "Roboto",
          //   'NotoSansSC', // 思源黑体
          //   'Microsoft YaHei', // 微软雅黑 (Windows)
          //   'Arial', // 通用英文字体
          //   'Helvetica', // 备选英文字体
          //   'sans-serif', // 通用字体族
          // ],
        ),
        child: Column(
          children: [
            Text(
              'AaBbCcDd 我是中文 123456 -- w100',
              style: TextStyle(fontWeight: FontWeight.w100),
            ),
            Text(
              'AaBbCcDd 我是中文 123456 -- w200',
              style: TextStyle(fontWeight: FontWeight.w200),
            ),
            Text(
              'AaBbCcDd 我是中文 123456 -- w300',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            Text(
              'AaBbCcDd 我是中文 123456 -- w400',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            Text(
              'AaBbCcDd 我是中文 123456 -- w500',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'AaBbCcDd 我是中文 123456 -- w600',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'AaBbCcDd 我是中文 123456 -- w700',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              'AaBbCcDd 我是中文 123456 -- w800',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            Text(
              'AaBbCcDd 我是中文 123456 -- w900',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
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

    var paragraph = paragraphBuilder.build()..layout(ui.ParagraphConstraints(width: size.width));

    canvas.drawParagraph(paragraph, Offset(0, 0));
  }

  @override
  bool shouldRepaint(MyTextPainter oldDelegate) {
    return text != oldDelegate.text;
  }
}
