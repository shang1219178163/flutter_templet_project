import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/extension/image_ext.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MergeImagesDemo extends StatefulWidget {
  final String? title;

  const MergeImagesDemo({Key? key, this.title}) : super(key: key);

  @override
  _MergeImagesDemoState createState() => _MergeImagesDemoState();
}

class _MergeImagesDemoState extends State<MergeImagesDemo> {
  final GlobalKey _globalKey = GlobalKey();
  // GlobalKey repaintBoundaryKey = GlobalKey(debugLabel: 'gk');

  GlobalKey repaintBoundaryKey1 = GlobalKey(debugLabel: 'gk1');
  GlobalKey repaintBoundaryKey2 = GlobalKey(debugLabel: 'gk2');
  GlobalKey repaintBoundaryKey3 = GlobalKey(debugLabel: 'gk3');

  Widget? imageMerged;
  ImageProvider? _imageProvider;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
            onPressed: () => {
              // print("保存")
              _compositePicNew().then((pngBytes) {
                imageMerged = Image.memory(pngBytes!,
                    width: double.maxFinite, height: 1200);
                setState(() {});
              })
            },
            child: Text(
              '保存',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              final keys = [
                repaintBoundaryKey1,
                repaintBoundaryKey2,
                repaintBoundaryKey3
              ];
              _compositePics(keys).then(
                (pngBytes) {
                  imageMerged =
                      Image.memory(pngBytes!, width: 400, height: 600);
                  setState(() {});
                },
              );
            },
            child: Text(
              'key3',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _buildBodyNew(),
    );
  }

  _buildBodyNew() {
    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      key: _globalKey,
      child: Column(
        children: [
          if (imageMerged != null) imageMerged!,
          Text('合成图片'),
          _buildItem(
            repaintBoundary: RepaintBoundary(
              key: repaintBoundaryKey1,
              child: Image(
                image: 'bg_jiguang.png'.toAssetImage(),
                fit: BoxFit.cover,
                width: screenSize.width,
                height: screenSize.height * 0.25,
              ),
            ),
            callback: (step) {
              debugPrint("callback:$step");

              var items = ['a', 'b', 'c', 'd'];
              final itemsNew = items.exchange(1, 2);
              debugPrint("exchange:$itemsNew");

              var list = [1, 2, 3, 4, 5];
              // list.replaceRange(1, 1, [6]);
              debugPrint(list.join(', '));

              list[1] = list[2];
              list[2] = list[1];
              debugPrint("2_${list.join(', ')}");
            },
          ),
          _buildItem(
            repaintBoundary: RepaintBoundary(
              key: repaintBoundaryKey3,
              child: Image(
                image: 'sha_qiu.png'.toAssetImage(),
                fit: BoxFit.cover,
                width: screenSize.width,
                // height: screenSize.height,
              ),
            ),
            callback: (step) {
              debugPrint("callback:$step");
            },
          ),
          _buildItem(
            repaintBoundary: RepaintBoundary(
              key: repaintBoundaryKey2,
              child: Image(
                image: 'bg_beach.jpg'.toAssetImage(),
                fit: BoxFit.cover,
                width: screenSize.width,
                height: screenSize.height,
              ),
            ),
            callback: (step) {
              debugPrint("callback:$step");
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
    final screenSize = MediaQuery.of(context).size;
    const moveBtnSize = 40.0;
    const radius = 8.0;
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
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                  onPressed: () => callback?.call(1),
                  child: Icon(
                    Icons.arrow_circle_down,
                  ),
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
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                  onPressed: () => callback?.call(-1),
                  child: Icon(
                    Icons.arrow_circle_up,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<ui.Image?> _capturePic(GlobalKey key) async {
    debugPrint("key:$key");
    var buildContext = key.currentContext;
    if (buildContext == null) {
      return null;
    }
    var boundary = buildContext.findRenderObject() as RenderRepaintBoundary?;
    var image = await boundary?.toImage(pixelRatio: ui.window.devicePixelRatio);

    // ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List? pngBytes = byteData?.buffer.asUint8List() ?? Uint8List(10);
    // ui.Image img = ui.Image.memory(pngBytes);
    return image;
  }

  /// 合成截图
  Future<Uint8List?> _compositePicNew() async {
    try {
      var one = await _capturePic(repaintBoundaryKey1);
      var two = await _capturePic(repaintBoundaryKey2);
      var three = await _capturePic(repaintBoundaryKey3);
      if (one == null || two == null || three == null) {
        return null;
      }

      debugPrint("three: ${three.width} ${three.height}");
      // var totalWidth = one.width > two.width ? one.width : two.width;
      var totalWidth =
          [one.width, two.width, three.width].reduce((a, b) => a > b ? a : b);

      // int totalHeight = one.height + two.height + 20.h.toInt();
      // int totalHeight = one.height + two.height;
      //初始化画布
      var recorder = ui.PictureRecorder();
      final paint = Paint();
      var canvas = Canvas(recorder);
      //画第一张图
      canvas.drawRect(
          Rect.fromLTWH(0, 0, totalWidth * 1.0, one.height * 1.0), paint);
      canvas.drawImage(one, Offset((totalWidth - one.width) / 2, 0), paint);
      //画第二张图
      paint.shader = null;
      paint.color = Colors.red;
      canvas.drawRect(
          Rect.fromLTWH(
              0, one.height * 1.0, totalWidth * 1.0, two.height * 1.0),
          paint);
      canvas.drawImage(two, Offset(0, one.height + 12), paint);
      //画第三张图
      canvas.drawRect(
          Rect.fromLTWH(0, one.height * 1.0 + two.height * 1.0,
              totalWidth * 1.0, two.height * 1.0),
          paint);
      canvas.drawImage(
          three,
          Offset((totalWidth - two.width) / 2, one.height + two.height + 12),
          paint);

      var image = await recorder
          .endRecording()
          .toImage(totalWidth, one.height + two.height + three.height + 24);
      //获取合成的图片
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();

      return Future.value(pngBytes);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// 通过多个 SingleChildScrollView 的 RepaintBoundary 对象合成长海报
  ///
  /// keys: 根据 GlobalKey 获取 Image 数组
  Future<Uint8List?> _compositePics([
    List<GlobalKey> keys = const [],
  ]) async {
    //根据 GlobalKey 获取 Image 数组
    var imgs = await Future.wait(keys.map((key) async {
      var boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      var image =
          await boundary?.toImage(pixelRatio: ui.window.devicePixelRatio);
      return image;
    }).toList());

    var images = imgs.where((e) => e != null).cast<ui.Image>().toList();
    // print("images:${images}");
    if (images.isEmpty) {
      throw Exception('没有获取到任何图片!');
    }

    final imageHeights = images.map((e) => e.height).toList();
    // print("imageHeights:${imageHeights}");

    try {
      var totalWidth = images[0].width;
      var totalHeight = imageHeights.reduce((a, b) => a + b);
      //初始化画布
      var recorder = ui.PictureRecorder();
      var canvas = Canvas(recorder);
      final paint = Paint();

      //画图
      for (var i = 0; i < images.length; i++) {
        final e = images[i];
        final offsetY =
            i == 0 ? 0 : imageHeights.sublist(0, i).reduce((a, b) => a + b);
        // print("offset:${i}_${e.height}_${offsetY}");
        canvas.drawRect(
            Rect.fromLTWH(
                0, offsetY.toDouble(), totalWidth * 1.0, e.height * 1.0),
            paint);
        canvas.drawImage(e, Offset(0, offsetY.toDouble()), paint);
      }

      //获取合成的图片
      var image = await recorder
          .endRecording()
          .toImage(totalWidth.toInt(), totalHeight.toInt());
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      //图片大小
      debugPrint("图片大小:${await image.fileSize() ?? "null"}");

      return Future.value(pngBytes);
    } catch (e) {
      debugPrint(e.toString());
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
