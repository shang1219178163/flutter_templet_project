
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

/// 图片拉伸
class ImageStretchDemo extends StatefulWidget {

  ImageStretchDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _ImageStretchDemoState createState() => _ImageStretchDemoState();
}

class _ImageStretchDemoState extends State<ImageStretchDemo> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
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
    return buildMyWidgetCanvas();

    final message = "这里的气泡背景是作为Container的背景展示的，在Container外层需要再套一层ConstrainedBox，并设置最小高度minHeight，否则当当只有一行文字的时候背景图片无法显示.";
    return Column(
      children: [
        Container(
          width: 200,
          height: 70,
          margin: EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.blue),
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(
                'assets/images/bg_chat_bubble.png',
              ),
            )
          ),
        ),
        Container(
          // margin: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(vertical: 40),
          constraints: BoxConstraints(
            minHeight: 50,
            maxWidth: 200,
          ),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.blue),
            image: DecorationImage(
              fit: BoxFit.contain,
              // fit: BoxFit.fill,
              // colorFilter: ColorFilter.mode(Colors.red, BlendMode.dst),
              centerSlice: Rect.fromLTRB(2, 18, 2, 18),
              image: AssetImage(
                'assets/images/bg_chat_bubble.png',
              ),
            )
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 20,
              maxWidth: 150,
            ),
            child: Text(message, maxLines: 3,),
          ).toColoredBox(),
        ),
        // Container(
        //   // margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        //   // padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        //   // constraints: BoxConstraints(
        //   //   minHeight: 50,
        //   //   // maxWidth: 200,
        //   // ),
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     // color: Colors.red,
        //     border: Border.all(color: Colors.blue),
        //     image: DecorationImage(
        //       fit: BoxFit.scaleDown,
        //       // fit: BoxFit.fill,
        //       // colorFilter: ColorFilter.mode(Colors.red, BlendMode.dst),
        //       centerSlice: Rect.fromLTRB(2, 18, 2, 18),
        //       image: AssetImage(
        //         'assets/images/icon_heart.png',
        //       ),
        //       // image: AssetImage(
        //       //   'assets/images/weiqi.png',
        //       // ),
        //     )
        //   ),
        //   child: ConstrainedBox(
        //     constraints: BoxConstraints(
        //       // minHeight: 50,
        //       maxWidth: 200,
        //     ),
        //     child: Text(message,),
        //   ).toColoredBox(),
        // ),

        Container(
          width: 170,
          height: 120,
          margin: EdgeInsets.symmetric(vertical: 40),
          child: AssetImageStretch(
            child: Text(
              'Flutter 聊一会'*9,
              style: TextStyle(color: Colors.red),
            ).toColoredBox(),
          )
        ),

      ],
    );
  }

  buildMyWidgetCanvas() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
            ),
            child: AssetImageStretch(
              center: const Rect.fromLTRB(33.0, 20.0, 30.0, 36.0),
              child: buildText(),
            )
        ),
        Container(
          height: 28,
          margin: EdgeInsets.symmetric(vertical: 40),
          // constraints: BoxConstraints(
          //   maxWidth: 80,
          // ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
          ),
          child: AssetImageStretch(
            path: "assets/images/bg_service.png",
            center: const Rect.fromLTRB(12, 4, 38, 4),
            child: buildText(),
          )
        ),
      ],
    );
  }

  Widget buildText() {
    return Text(
      // '聊一块钱的!'*1,
      'Flutter 聊一块钱的!'*2,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ).toColoredBox();
  }

}


class AssetImageStretch extends StatelessWidget {
  const AssetImageStretch({
    super.key,
    this.path = "assets/images/bg_chat_bubble.png",
    this.center = const Rect.fromLTRB(33.0, 15.0, 30.0, 36.0),
    required this.child,
    this.loading,
    this.error,
  });

  final String path;
  final Widget? loading;
  final Widget? error;

  final Widget? child;

  final Rect center;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageFromAssets(path),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loading ?? const Text('加载中');
        }

        final data = snapshot.data;
        if (data == null) {
          return error ?? const Text('加载失败');
        }

        return CustomPaint(
          painter: AssetImageStretchPainter(
            data,
            // center: center,
            center: Rect.fromLTWH(center.left, center.top, 1, 1),
          ),
          child: Container(
            margin: EdgeInsets.only(
              left: center.left,
              top: center.top,
              right: center.right,
              bottom: center.bottom,
            ),
            child: child,
          ),
        );
      },
    );
  }

  Future<ui.Image> getImageFromAssets(String path) async {
    final immutableBuffer = await rootBundle.loadBuffer(path);
    final codec = await ui.instantiateImageCodecFromBuffer(
      immutableBuffer,
    );
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

class AssetImageStretchPainter extends CustomPainter {
  const AssetImageStretchPainter(this.image, {required this.center});
  final ui.Image image;
  final Rect center;

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawImageNine(image, center, Offset.zero & size, Paint());
    canvas.drawImageNine(image, center, Offset.zero & size, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
