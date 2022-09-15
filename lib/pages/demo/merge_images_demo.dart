import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MergeImagesDemo extends StatefulWidget {

  final String? title;

  MergeImagesDemo({ Key? key, this.title}) : super(key: key);


  @override
  _MergeImagesDemoState createState() => _MergeImagesDemoState();
}

class _MergeImagesDemoState extends State<MergeImagesDemo> {

  GlobalKey _globalKey = GlobalKey();
  GlobalKey repaintBoundaryKey1 = GlobalKey(debugLabel: 'gk1');
  GlobalKey repaintBoundaryKey2 = GlobalKey(debugLabel: 'gk2');
  GlobalKey repaintBoundaryKey3 = GlobalKey(debugLabel: 'gk3');

  Widget? imageMerged;
  ImageProvider? _imageProvider;

  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            TextButton(
              onPressed: () => {
                // print("保存")
                // storeImageNew().then((val) => { print("保存 ${val}")})
                _compositePic().then((val) => { print("保存")})
                // _capturePng().then((val) => { print("保存")})
              },
              child: Text('保存', style: TextStyle(color: Colors.white),)
            ),
            TextButton(
              onPressed: () => {
                _compositePicNew()
                  .then((pngBytes) => {
                    // imageMerged = Image.memory(pngBytes!, width: 200, height: 600);
                    // setState(() {});
                  })
              },
              child: Text('保存三', style: TextStyle(color: Colors.white),)
            ),
            TextButton(
              onPressed: () => {
                [repaintBoundaryKey1,
                  repaintBoundaryKey2,
                  repaintBoundaryKey3
                ].forEach((e) => {print("repaintBoundaryKey:${e.currentContext?.findRenderObject()}")})
              },
              child: Text('key3', style: TextStyle(color: Colors.white),)
            ),
          ],
        ),
        body: _buildBodyNew(),
    );
  }

  _buildBodyNew(){
    final screenSize = MediaQuery.of(this.context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          if(imageMerged != null) imageMerged!,
          Text('合成图片'),
          RepaintBoundary(
            key: repaintBoundaryKey1,
            child: Image.asset(
              'images/bg_alp.png',
              fit: BoxFit.cover,
              width: screenSize.width,
              height: screenSize.height * 0.25,
            ),
          ),
          RepaintBoundary(
            key: repaintBoundaryKey3,
            child: Image.asset(
              'images/sha_qiu.png',
              fit: BoxFit.cover,
              width: screenSize.width,
              height: screenSize.height,
            ),
          ),
          RepaintBoundary(
            key: repaintBoundaryKey2,
            child: Image.asset(
              'images/bg_ocean.png',
              fit: BoxFit.cover,
              width: screenSize.width,
              height: screenSize.height,
            ),
          ),
        ],
      ),
    );
  }

  Future<ui.Image> _capturePic(GlobalKey key) async {
    BuildContext buildContext = key.currentContext!;
    print("key:${key}:${buildContext}");
    RenderRepaintBoundary boundary = buildContext.findRenderObject() as RenderRepaintBoundary;
    // if (boundary.debugNeedsPaint) {
    //   await Future.delayed(Duration(milliseconds: 20));
    //   return _capturePic(key);
    // }
    ui.Image image = await boundary.toImage(pixelRatio: 2);

    // ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List? pngBytes = byteData?.buffer.asUint8List() ?? Uint8List(10);
    // ui.Image img = ui.Image.memory(pngBytes);
    return image;
  }

  /// 合成截图
  Future<Uint8List?> _compositePicNew() async {
      try {
        ui.Image one = await _capturePic(repaintBoundaryKey1);
        ui.Image two = await _capturePic(repaintBoundaryKey2);
        ui.Image three = await _capturePic(repaintBoundaryKey3);

        print("three: ${three.width} ${three.height}");
        int totalWidth = one.width > two.width ? one.width : two.width;
        // int totalHeight = one.height + two.height + 20.h.toInt();
        // int totalHeight = one.height + two.height;
        //初始化画布
        ui.PictureRecorder recorder = ui.PictureRecorder();
        final paint = Paint();
        Canvas canvas = Canvas(recorder);
        //画第一张图
        canvas.drawRect(Rect.fromLTWH(
            0,
            0,
            totalWidth * 1.0,
            one.height * 1.0), paint);
        canvas.drawImage(one, Offset((totalWidth - one.width) / 2, 0), paint);
        //画第二张图
        paint.shader = null;
        paint.color = Colors.red;
        canvas.drawRect(Rect.fromLTWH(
            0,
            one.height * 1.0,
            totalWidth * 1.0,
            two.height * 1.0), paint);
        canvas.drawImage(two, Offset((totalWidth - two.width) / 2, one.height + 12), paint);
        //画第三张图
        canvas.drawRect(Rect.fromLTWH(
          0,
          one.height * 1.0 + two.height * 1.0,
          totalWidth * 1.0,
            two.height * 1.0), paint);
        canvas.drawImage(three, Offset((totalWidth - two.width) / 2, one.height + two.height + 12), paint);

        ui.Image image = await recorder.endRecording().toImage(totalWidth, one.height + two.height + two.height + 24);
        //获取合成的图片
        // ui.Image image = await recorder.endRecording().toImage(totalWidth, one.height + two.height + 24);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List? pngBytes = byteData?.buffer.asUint8List();

        imageMerged = Image.memory(pngBytes!, width: 400, height: 1200);
        setState(() {});

        return pngBytes;
      } catch (e) {
        print(e);
      }
      return null;
    }

  /// 合成截图
  Future<Uint8List?> _compositePic() async {
    try {
      ui.Image? one = await _capturePic(repaintBoundaryKey1);
      ui.Image? two = await _capturePic(repaintBoundaryKey2);
      print("two: ${two.width} ${two.height}");
      int totalWidth = one.width > two.width ? one.width : two.width;
      // int totalHeight = one.height + two.height + 20.h.toInt();
      int totalHeight = one.height + two.height;
      //初始化画布
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas canvas = Canvas(recorder);
      final paint = Paint();
      //画第一张图
      canvas.drawRect(Rect.fromLTWH(
        0,
        0,
        totalWidth * 1.0,
        one.height * 1.0), paint);
      canvas.drawImage(one, Offset((totalWidth - one.width) / 2, 0), paint);
      //画第二张图
      paint.shader = null;
      paint.color = Colors.red;
      canvas.drawRect(Rect.fromLTWH(
        0,
        one.height * 1.0,
        totalWidth * 1.0,
          (totalHeight - one.height)*1.0), paint);
      canvas.drawImage(two, Offset((totalWidth - two.width) / 2, one.height + 12), paint);
      //获取合成的图片
      ui.Image image = await recorder.endRecording().toImage(totalWidth, totalHeight);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      imageMerged = Image.memory(pngBytes!, width: 400, height: 600);
      setState(() {});

      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }
  // Future<Uint8List> createImageFromWidget(Widget widget, {Duration? wait, Size? logicalSize, Size? imageSize}) async {
  //   final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
  //
  //   logicalSize ??= ui.window.physicalSize / ui.window.devicePixelRatio;
  //   imageSize ??= ui.window.physicalSize;
  //
  //   assert(logicalSize.aspectRatio == imageSize.aspectRatio);
  //
  //   final RenderView renderView = RenderView(
  //     window: u.window,
  //     child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
  //     configuration: ViewConfiguration(
  //       size: logicalSize,
  //       devicePixelRatio: 1.0,
  //     ),
  //   );
  //
  //   final PipelineOwner pipelineOwner = PipelineOwner();
  //   final BuildOwner buildOwner = BuildOwner();
  //
  //   pipelineOwner.rootNode = renderView;
  //   renderView.prepareInitialFrame();
  //
  //   final RenderObjectToWidgetElement<RenderBox> rootElement = RenderObjectToWidgetAdapter<RenderBox>(
  //     container: repaintBoundary,
  //     child: widget,
  //   ).attachToRenderTree(buildOwner);
  //
  //   buildOwner.buildScope(rootElement);
  //
  //   if (wait != null) {
  //     await Future.delayed(wait);
  //   }
  //
  //   buildOwner.buildScope(rootElement);
  //   buildOwner.finalizeTree();
  //
  //   pipelineOwner.flushLayout();
  //   pipelineOwner.flushCompositingBits();
  //   pipelineOwner.flushPaint();
  //
  //   final ui.Image image = await repaintBoundary.toImage(pixelRatio: imageSize.width / logicalSize.width);
  //   final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   return byteData?.buffer.asUint8List() ?? Uint8List(10);
  // }

}