import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/asset_image_stretch.dart';
import 'package:flutter_templet_project/extension/text_painter_ext.dart';

import 'package:flutter_templet_project/extension/widget_ext.dart';

/// 图片拉伸
class ImageStretchDemo extends StatefulWidget {
  ImageStretchDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ImageStretchDemoState createState() => _ImageStretchDemoState();
}

class _ImageStretchDemoState extends State<ImageStretchDemo> {
  final message =
      "这里的气泡背景是作为Container的背景展示的，在Container外层需要再套一层ConstrainedBox，并设置最小高度minHeight，否则当当只有一行文字的时候背景图片无法显示.";

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
      // floatingActionButton: FloatingActionButton.small(
      //   onPressed: (){
      //
      //   },
      //   child: Icon(Icons.search)
      // ),
    );
  }

  buildBody() {
    return Column(
      children: [
        buildChatBubble(child: Text(message.substring(0, 30)).toColoredBox()),
        RotatedBox(
          quarterTurns: 2,
          child: buildChatBubble(
            child: RotatedBox(
                quarterTurns: 2, child: Text(message).toColoredBox()),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
          // padding: EdgeInsets.fromLTRB(8, 10, 10, 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            image: DecorationImage(
              centerSlice: Rect.fromLTRB(20, 20, 20, 20),
              image: AssetImage(
                'assets/images/bg_service.png',
              ),
            ),
          ),
          constraints: BoxConstraints(
            // minHeight: 18,
            maxWidth: 250,
          ),
          child: Text(
            'Flutter 聊一会' * 3,
            maxLines: 3,
            softWrap: true,
            style: TextStyle(color: Colors.red),
          ).toColoredBox(),
        ),
        Flexible(
          child: Text('Very texttttttttttttt').toColoredBox(),
        ),
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final text = 'Flutter 聊一会' * 3;

          final textStyle = TextStyle(color: Colors.red);
          final textPainter = TextPainterExt.getTextPainter(
            text: text,
            textStyle: textStyle,
            maxLine: 1,
            maxWidth: constraints.maxWidth,
          );
          final numberOfLines = textPainter.computeLineMetrics().length;
          final lineMetric = textPainter.computeLineMetrics()[0];
          final textWidth = lineMetric.width;

          debugPrint("textWidth:$textWidth");

          return Stack(
            children: [
              Container(
                  // margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  // padding: EdgeInsets.fromLTRB(8, 8, 8, 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                  ),
                  constraints: BoxConstraints(
                    minHeight: 14,
                    // maxHeight: lineMetric.height*lineMetric.lineNumber,
                    maxWidth: textWidth + 10 + 30,
                  ).loosen(),
                  child: Image(
                    image: AssetImage(
                      'assets/images/bg_service.png',
                    ),
                  )),
              Positioned(
                top: 8,
                // bottom: 8,
                left: 10,
                right: 30,
                child: Text(
                  text,
                  maxLines: 1,
                  // softWrap: true,
                  overflow: TextOverflow.fade,
                  style: textStyle,
                ).toColoredBox(),
              ),
            ],
          );
        }),
        Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: AssetImageStretch(
              child: Text(
                'Flutter 聊一会' * 2,
                softWrap: true,
                style: TextStyle(color: Colors.red),
              ).toColoredBox(),
            )),
        Container(
            // margin: EdgeInsets.symmetric(vertical: 40),
            child: AssetImageStretch(
          path: 'assets/images/bg_service.png',
          center: Rect.fromLTRB(8, 8, 35, 8),
          child: Text(
            'Flutter 聊一会' * 2,
            style: TextStyle(color: Colors.red),
          ).toColoredBox(),
        )),
      ],
    );
  }

  Widget buildChatBubble({required Widget child}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(16, 10, 10, 10),
      decoration: BoxDecoration(
          image: DecorationImage(
        centerSlice: Rect.fromLTRB(20, 20, 38, 38),
        image: AssetImage(
          'assets/images/bg_chat_bubble_to.png',
        ),
      )),
      constraints: BoxConstraints(
        minHeight: 50,
        maxWidth: 250,
      ),
      child: child,
    );
  }

  Widget buildText() {
    return Text(
      // '聊一块钱的!'*1,
      'Flutter 聊一块钱的!' * 2,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
