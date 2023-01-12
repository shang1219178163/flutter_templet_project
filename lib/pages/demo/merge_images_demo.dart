import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/extension/image_ext.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';

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
  // GlobalKey repaintBoundaryKey = GlobalKey(debugLabel: 'gk');

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
                _compositePic().then((pngBytes) {
                  imageMerged = Image.memory(pngBytes!, width: 200, height: 600);
                  setState(() {});
                })
                // _capturePng().then((val) => { print("保存")})
              },
              child: Text('保存', style: TextStyle(color: Colors.white),)
            ),
            TextButton(
              onPressed: () => {
                _compositePicNew().then((pngBytes) {
                    imageMerged = Image.memory(pngBytes!, width: 400, height: 1200);
                    setState(() {});
                  })
              },
              child: Text('保存三', style: TextStyle(color: Colors.white),)
            ),
            TextButton(
              onPressed: () {
                final keys = [
                  repaintBoundaryKey1,
                  repaintBoundaryKey2,
                  repaintBoundaryKey3
                ];
                _compositePics(keys).then((pngBytes) {
                  imageMerged = Image.memory(pngBytes!, width: 400, height: 600);
                  setState(() {});
                });
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
      key: _globalKey,
      child: Column(
        children: [
          if(imageMerged != null) imageMerged!,
          Text('合成图片'),
          _buildItem(
            repaintBoundary: RepaintBoundary(
                key: repaintBoundaryKey1,
                child: Image.asset(
                  'images/bg_alp.png',
                  fit: BoxFit.cover,
                  width: screenSize.width,
                  height: screenSize.height * 0.25,
                ),
              ),
            callback: (step){
              print("callback:${step}");

              var items = ['a', 'b', 'c', 'd'];
              final itemsNew = items.exchange(1, 2);
              print("exchange:${itemsNew}");


              var list = [1, 2, 3, 4, 5];
              // list.replaceRange(1, 1, [6]);
              print("${list.join(', ')}");
              list[1] = list[2];
              list[2] = list[1];
              print("2_${list.join(', ')}");
            },
          ),
          _buildItem(
            repaintBoundary: RepaintBoundary(
              key: repaintBoundaryKey3,
              child: Image.asset(
                'images/sha_qiu.png',
                fit: BoxFit.cover,
                width: screenSize.width,
                height: screenSize.height,
              ),
            ),
            callback: (step){
              print("callback:${step}");
            },
          ),
          _buildItem(
            repaintBoundary: RepaintBoundary(
              key: repaintBoundaryKey2,
              child: Image.asset(
                'images/bg_ocean.png',
                fit: BoxFit.cover,
                width: screenSize.width,
                height: screenSize.height,
              ),
            ),
            callback: (step){
              print("callback:${step}");
            },
          ),
        ],
      ),
    );
  }

  _buildItem({
    required RepaintBoundary repaintBoundary,
    void Function(int step)? callback,
  }) {
    final screenSize = MediaQuery.of(this.context).size;
    final moveBtnSize = 40.0;
    final radius = 8.0;
    return Stack(
      children: [
        repaintBoundary,
        Positioned(
          top: 15,
          left: 15,
          child: Column(
            children: [
              Container(
                width: moveBtnSize,
                height: moveBtnSize,
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(radius))
                  ),
                  onPressed: () => callback?.call(1),
                  child: Icon(Icons.arrow_circle_down,),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: moveBtnSize,
                height: moveBtnSize,
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(radius))
                  ),
                  onPressed: () => callback?.call(-1),
                  child: Icon(Icons.arrow_circle_up,),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<ui.Image> _capturePic(GlobalKey key) async {
    BuildContext buildContext = key.currentContext!;
    print("key:${key}:${buildContext}");
    RenderRepaintBoundary boundary = buildContext.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);

    // ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List? pngBytes = byteData?.buffer.asUint8List() ?? Uint8List(10);
    // ui.Image img = ui.Image.memory(pngBytes);
    return Future.value(image);
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
      canvas.drawImage(two, Offset(0, one.height + 12), paint);
      //画第三张图
      canvas.drawRect(Rect.fromLTWH(
        0,
        one.height * 1.0 + two.height * 1.0,
        totalWidth * 1.0,
          two.height * 1.0), paint);
      canvas.drawImage(three, Offset((totalWidth - two.width) / 2, one.height + two.height + 12), paint);

      ui.Image image = await recorder.endRecording().toImage(totalWidth, one.height + two.height + three.height + 24);
      //获取合成的图片
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      return Future.value(pngBytes);
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

      return Future.value(pngBytes);
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// 通过多个 SingleChildScrollView 的 RepaintBoundary 对象合成长海报
  ///
  /// keys: 根据 GlobalKey 获取 Image 数组
  Future<Uint8List?> _compositePics([List<GlobalKey> keys = const [],]) async {
    //根据 GlobalKey 获取 Image 数组
    List<ui.Image> images = await Future.wait(
      keys.map((key) async {
        BuildContext buildContext = key.currentContext!;
        RenderRepaintBoundary boundary = buildContext.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
        return image;
      }
    ).toList());
    // print("images:${images}");
    if (images.length == 0) {
      throw new Exception('没有获取到任何图片!');
    }

    final List<int> imageHeights = images.map((e) => e.height).toList();
    // print("imageHeights:${imageHeights}");

    try {
      int totalWidth = images[0].width;
      int totalHeight = imageHeights.reduce((a,b) => a + b);
      //初始化画布
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas canvas = Canvas(recorder);
      final paint = Paint();

      //画图
      for (int i = 0; i < images.length; i++) {
        final e = images[i];
        final offsetY = i == 0 ? 0 : imageHeights.sublist(0, i).reduce((a,b) => a + b);
        // print("offset:${i}_${e.height}_${offsetY}");
        canvas.drawRect(Rect.fromLTWH(
            0,
            offsetY.toDouble(),
            totalWidth * 1.0,
            e.height * 1.0), paint);
        canvas.drawImage(e, Offset(0, offsetY.toDouble()), paint);
      }

      //获取合成的图片
      ui.Image image = await recorder.endRecording().toImage(totalWidth, totalHeight);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      //图片大小
      print("图片大小:${await image.fileSize() ?? "null"}");

      return Future.value(pngBytes);
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

