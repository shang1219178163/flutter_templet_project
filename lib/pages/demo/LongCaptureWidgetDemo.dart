
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


/// 长截图
class LongCaptureWidgetDemo extends StatefulWidget {

  LongCaptureWidgetDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _LongCaptureWidgetDemoState createState() => _LongCaptureWidgetDemoState();
}

class _LongCaptureWidgetDemoState extends State<LongCaptureWidgetDemo> {


  final _shareKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed,)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return buildCapture(key: _shareKey);
  }

  buildCapture({GlobalKey? key}) {
    return SingleChildScrollView(
      child: RepaintBoundary(
        key: key,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              NHeader.h1(title: "长截图", alignment: Alignment.center,),
              ...List.generate(19, (index) => Container(
                  color: ColorExt.random,
                  height: 90,
                )
              ),
              NHeader.h2(title: "长截图 Footer",),
            ]
          ),
        ),
      ),
    );
  }

  onPressed() async {
    // debugPrint(e)
    final image = await _shareKey.currentContext?.toImage(pixelRatio: 2);
    final imageWidget = await _shareKey.currentContext?.toImageWidget(pixelRatio: 2);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(30),
        color: Colors.white,
        child: imageWidget,
      ),
    );
  }

}