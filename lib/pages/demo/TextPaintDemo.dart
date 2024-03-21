

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_text_one.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/text_painter_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:get/get.dart';

class TextPaintDemo extends StatefulWidget {

  TextPaintDemo({
    super.key, 
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TextPaintDemo> createState() => _TextPaintDemoState();
}

class _TextPaintDemoState extends State<TextPaintDemo> {

  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  final message = "ClipRect是Flutter中的一个Widget，用于限制子Widget的绘制区域，它可以让我们在一个矩形区域内绘制子Widget，而超出这个矩形区域的部分将不会被显示出来。ClipRect通常用于实现一些特殊的效果，比如圆角矩形、圆形头像等。此外，ClipRect还可以与其他小部件结合使用，例如Opacity、Transform等，实现更加丰富的效果。";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp ? null : AppBar(
        title: Text("$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildText(data: message.substring(0, 89), isExpand: true),
              buildText(data: message.substring(0, 90), isExpand: true),
              buildText(
                data: message.substring(0, 79),
                isExpand: true,
                tailingWidth: 56,
                tailing: InkWell(
                  onTap: (){
                    ddlog("异常");
                  },
                  child: Container(
                    width: 40,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    child: Text("异常"),
                  ),
                ),
              ),
              buildText(
                data: message.substring(0, 81),
                isExpand: true,
                tailingWidth: 56,
                tailing: InkWell(
                  onTap: (){
                    ddlog("异常");
                  },
                  child: Container(
                    width: 40,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    child: Text("异常"),
                  ),
                ),
              ),
              // buildText(message: message, isExpand: true),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget buildMyText() {
    return Container(
      color: ColorExt.random,
      padding: EdgeInsets.symmetric(
        horizontal: 50,
      ),
      child: CustomPaint(
        painter: MyTextPainter(
            text: message,
            textStyle: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            onPainted: (TextPainter textPainter){
              // ddlog([message,
              //   textPainter.didExceedMaxLines,
              //   textPainter.height,
              //   textPainter.computeLineMetrics().length,
              // ].join(","));
            }
        ),
      ),
    );
  }

  Widget buildText({
    required String data,
    required bool isExpand,
    Widget? tailing,
    double tailingWidth = 0,
  }) {
    return NExpandTextOne(
      data: data,
      isExpand: isExpand,
      tailing: tailing,
      tailingWidth: tailingWidth,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        final textStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );

        final textPainter = TextPainterExt.getTextPainter(
          text: data,
          textStyle: textStyle,
          maxLine: 3,
          maxWidth: (constraints.maxWidth - tailingWidth),
        );

        final isBeyond = textPainter.didExceedMaxLines;
        ddlog([data.length,
          constraints.maxWidth - tailingWidth,
          textPainter.height,
          textPainter.didExceedMaxLines,
          textPainter.computeLineMetrics().length,
        ].asMap());

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            // color: Colors.green,
            border: Border.all(color: Colors.blue),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {

              final arrowImage = isExpand ? "icon_expand_arrow_up.png" : "icon_expand_arrow_down.png";

              onToggle(){
                isExpand = !isExpand;
                setState((){});
              }

              Widget buildArrow(){
                // return Text(
                //   isExpand ? "收起" : "展开",
                //   style: TextStyle(
                //     color: context.primaryColor,
                //   ),
                // );

                return Image(
                  image: arrowImage.toAssetImage(),
                  width: 21,
                  height: 8,
                );
              }

              return Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                // horizontal: 8,
                                // vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                              ),
                              child: Text(data,
                                style: textStyle,
                                maxLines: isExpand ? null : 3,
                              ),
                            ),
                            if (isBeyond) InkWell(
                                onTap: onToggle,
                                child: Container(
                                  height: 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // color: context.primaryColor.withOpacity(0.3),
                                    // gradient: isExpand ? null : LinearGradient(
                                    //   colors: [
                                    //     Colors.red.withOpacity(0.5),
                                    //     Colors.red,
                                    //   ],
                                    //   begin: Alignment.topCenter,
                                    //   end: Alignment.bottomCenter,
                                    // ),
                                  ),
                                  child: !isExpand ? null : buildArrow(),
                                ),
                            ),
                          ],
                        ),
                      ),
                      tailing ?? SizedBox(),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Opacity(
                      opacity: !isBeyond || isExpand ? 0 : 1,
                      child: InkWell(
                        onTap: onToggle,
                        child: Container(
                          width: double.infinity,
                          height: 44,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0x99FFFFFF).withOpacity(0.6),
                                Colors.white,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: buildArrow(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        );
      }
    );
  }
}


class MyTextPainter extends CustomPainter {

  MyTextPainter({
    required this.text,
    required this.textStyle,
    this.textSpan,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
    this.textScaler = TextScaler.noScaling,
    this.maxLines,
    this.offset = const Offset(0, 0),
    this.onPainted,
  });

  final String text;
  final TextStyle textStyle;
  final TextSpan? textSpan;

  final TextAlign textAlign;
  final TextDirection? textDirection;

  final TextScaler textScaler;
  final int? maxLines;

  final Offset offset;

  final ValueChanged<TextPainter>? onPainted;

  @override
  void paint(Canvas canvas, Size size) {
    final defaultSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan ?? defaultSpan,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      textScaler: textScaler,
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    if (rect.width > 0 && rect.height > 0) {
      final paint = Paint();
      paint.color = Colors.green;
      // canvas.drawRRect(RRect(), paint);
      canvas.drawRect(rect, paint);
      // ddlog("rect: $rect");
    }

    textPainter.layout(maxWidth: size.width,);
    textPainter.paint(canvas, offset);
    onPainted?.call(textPainter);
  }

  @override
  bool shouldRepaint(MyTextPainter oldDelegate) {
    return false;
  }
}



