import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/canvas_image_loader/n_canvas_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_chat_bubble.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

/// 图片拉伸
class ImageStretchDemo extends StatefulWidget {
  ImageStretchDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ImageStretchDemoState createState() => _ImageStretchDemoState();
}

class _ImageStretchDemoState extends State<ImageStretchDemo> {
  final message = "这里的气泡背景是作为Container的背景展示的，在Container外层需要再套一层ConstrainedBox，并设置最小高度minHeight，否则当当只有一行文字的时候背景图片无法显示.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          NCanvasNetworkImage(
            url: AppRes.image.urls.random ?? "",
            width: 200,
            height: 100,
          ),
          buildChatBubble(child: Text(message.substring(0, 30))),
          RotatedBox(
            quarterTurns: 2,
            child: buildChatBubble(
              child: RotatedBox(quarterTurns: 2, child: Text(message)),
            ),
          ),
        ].map((e) {
          return Container(
            padding: EdgeInsets.only(bottom: 16),
            child: e,
          );
        }).toList(),
      ),
    );
  }

  Widget buildChatBubble({required Widget child}) {
    return NChatBubble(
      imagePath: Assets.messageBubble1,
      metrics: NChatBubbleMetrics(
        imageSize: const Size(58, 44),
        safeInset: const EdgeInsets.fromLTRB(23, 20, 19, 11),
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
