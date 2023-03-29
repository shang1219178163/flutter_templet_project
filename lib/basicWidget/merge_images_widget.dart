
import 'dart:async';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/image_ext.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';

/// 合并多张图片为长图
class MergeImagesWidget extends StatefulWidget {

  List<MergeImageModel> models;
  Widget Function(MergeImageModel model)? imageBuilder;
  // double width;
  /// 二维码图片
  // Container Function()? QRCodeBuiler;
  Widget? Function(String QRCodeUrl)? QRCodeBuilder;
  String QRCodeUrl;
  // double? QRCodeWidth;
  // double? QRCodeHeight;
  int QRCodeRight;
  int QRCodeBottom;
  // void Function()? QRCodeTap;

  MergeImagesWidget({
    Key? key,
    required this.models,
    this.imageBuilder,
    // required this.width,
    // this.QRCodeBuiler,
    this.QRCodeBuilder,
    required this.QRCodeUrl,
    // this.QRCodeWidth = 84,
    // this.QRCodeHeight = 84,
    this.QRCodeRight = 28,
    this.QRCodeBottom = 24,
    // this.QRCodeTap,
  }) : super(key: key);

  @override
  MergeImagesWidgetState createState() => MergeImagesWidgetState();
}

class MergeImagesWidgetState extends State<MergeImagesWidget> {

  final minCodeGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
  
  _buildBody(){
    final screenSize = MediaQuery.of(this.context).size;
    final devicePixelRatio = MediaQuery.of(this.context).devicePixelRatio;

    List<Widget> children = widget.models.map((e) {
      int idx = widget.models.indexOf(e);
      return Stack(
        children: [
          _buildTool(
            hideUp: idx == 0,
            hideDown: idx == widget.models.length - 1,
            repaintBoundary: RepaintBoundary(
              key: e.globalKey,
              child: widget.imageBuilder != null ? widget.imageBuilder!(e) : FadeInImage.assetNetwork(
                placeholder: 'images/img_placeholder.png',
                image: e.url ?? '',
                fit: BoxFit.cover,
                width: double.tryParse(e.width ?? "${screenSize.width}") ?? screenSize.width,
                height: double.tryParse(e.height ?? "${screenSize.height}") ?? screenSize.height,
                imageCacheWidth: ((double.tryParse(e.width ?? "${screenSize.width}") ?? screenSize.width) * devicePixelRatio).toInt(),
                imageCacheHeight: ((double.tryParse(e.height ?? "${screenSize.height}") ?? screenSize.height) * devicePixelRatio).toInt(),
              ),
            ),
            callback: (step){
              print("callback:${step}");
              widget.models.exchange(idx, idx + step);
              setState(() {});
            }
          ),
          if (widget.QRCodeBuilder != null) Positioned(
            right: widget.QRCodeRight.toDouble(),
            bottom: widget.QRCodeBottom.toDouble(),
            child: idx != (widget.models.length - 1) ? Container() : RepaintBoundary(
              key: minCodeGlobalKey,
              child: widget.QRCodeBuilder?.call(widget.QRCodeUrl),
            ),
          ),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildTool({
    required RepaintBoundary repaintBoundary,
    bool hideUp = false,
    bool hideDown = false,
    void Function(int step)? callback,
  }) {
    return Stack(
      children: [
        repaintBoundary,
        Positioned(
          top: 12,
          left: 8,
          child: Column(
            children: [
              _buildBtn(
                onTap: () => callback?.call(-1),
                image: Image.asset('images/icon_arrow_up.png'),
                hidden: hideUp,
              ),
              hideUp ? Container() : SizedBox(height: 6),
              _buildBtn(
                image: Image.asset('images/icon_arrow_down.png'),
                onTap: () => callback?.call(1),
                hidden: hideDown,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 本地图片
  _buildBtn({
    Widget? image,
    GestureTapCallback? onTap,
    double? width = 28,
    double? height = 28,
    bool hidden = false,
  }) {
    if (hidden) {
      return Container();
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        child: image,
      ),
    );
  }

  FutureOr<ui.Image> _capturePic(GlobalKey key) async {
    BuildContext buildContext = key.currentContext!;
    RenderRepaintBoundary boundary = buildContext.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);

    // ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List? pngBytes = byteData?.buffer.asUint8List() ?? Uint8List(10);
    // ui.Image img = ui.Image.memory(pngBytes);
    return Future.value(image);
  }

  // /// 通过多个 SingleChildScrollView 的 RepaintBoundary 对象合成长海报
  // ///
  // /// keys: 根据 GlobalKey 获取 Image 数组
  // Future<Uint8List?> _compositePics([List<GlobalKey?> keys = const [],]) async {
  //   //根据 GlobalKey 获取 Image 数组
  //   List<ui.Image> images = await Future.wait(
  //       keys.map((key) async {
  //         return await _capturePic(key!);;
  //       }).toList());
  //
  //   ui.Image miniCodeImage = await _capturePic(minCodeGlobalKey);
  //
  //   // print("images:${images}");
  //   if (images.length == 0) {
  //     throw new Exception('没有获取到任何图片!');
  //   }
  //
  //   final List<int> imageHeights = images.map((e) => e.height).toList();
  //   // print("imageHeights:${imageHeights}");
  //
  //   try {
  //     int totalWidth = images.map((e) => e.width).toList().sorted()[0];
  //
  //     int totalHeight = imageHeights.reduce((a,b) => a + b);
  //     //初始化画布
  //     ui.PictureRecorder recorder = ui.PictureRecorder();
  //     Canvas canvas = Canvas(recorder);
  //     final paint = Paint();
  //
  //     //画图
  //     for (int i = 0; i < images.length; i++) {
  //       final e = images[i];
  //       final offsetY = i == 0 ? 0 : imageHeights.sublist(0, i).reduce((a,b) => a + b);
  //       // print("offset:${i}_${e.height}_${offsetY}");
  //       canvas.drawImage(e, Offset(0, offsetY.toDouble()), paint);
  //     }
  //
  //     if (widget.QRCode != null) {
  //       final minCodeRect = Rect.fromLTWH(
  //           (totalWidth - widget.QRCodeRight - widget.QRCodeWidth!).toDouble(),
  //           (totalHeight - widget.QRCodeBottom - widget.QRCodeHeight!).toDouble(),
  //           widget.QRCodeWidth! * 1,
  //           widget.QRCodeHeight! * 1);
  //       // canvas.drawImage(miniCodeImage, Offset(minCodeRect.left, minCodeRect.top), paint);
  //       canvas.drawImage(miniCodeImage, Offset(minCodeRect.left - 80, minCodeRect.top - 80), paint);
  //     }
  //
  //     //获取合成的图片
  //     ui.Image image = await recorder.endRecording().toImage(totalWidth.toInt(), totalHeight.toInt());
  //     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //     Uint8List? pngBytes = byteData?.buffer.asUint8List();
  //     if (pngBytes == null) {
  //       throw new Exception('生成图片失败!');
  //     }
  //     //图片大小
  //     image.fileSize().then((value) => print("长图大小:${value}"));
  //
  //     return Future.value(pngBytes);
  //   } catch (e) {
  //     print(e);
  //     return Future.error(e);
  //   }
  //   return null;
  // }

  Future<Uint8List> toCompositeImageUrls({
    required List<String> imageUrls,
    Uint8List? miniCode,
    int right = 16,
    int bottom = 16,
  }) async {

    List<ui.Image> images = await Future.wait(
        imageUrls.map((imageUrl) async {
          final imageUint8List = await ImageExt.imageDataFromUrl(imageUrl: imageUrl);
          if (imageUint8List == null) {
            throw new Exception('图片数据异常');
          }
          final image = await decodeImageFromList(imageUint8List);
          return image;
        }).toList()
    );

    final bytes = await toCompositeUIImages(
        images: images,
        miniCode: miniCode,
        right: right,
        bottom: bottom
    );
    return bytes;
  }

  FutureOr<Uint8List> toCompositeUIImages({
    required List<ui.Image> images,
    Uint8List? miniCode,
    int right = 16,
    int bottom = 16,
  }) async {
    if (images.length == 0) {
      throw new Exception('没有获取到任何图片!');
    }

    List<int> imageHeights = images.map((e) => e.height).toList();
    // print("imageHeights:${imageHeights}");

    images.sort((a, b) => a.width.compareTo(b.width));
    images.forEach((e) => print("image:${e.width}_${e.height}"));

    int totalWidth = images[0].width;
    int totalHeight = imageHeights.reduce((a, b) => a + b);

    try {
      //初始化画布
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint();

      //画图
      for (int i = 0; i < images.length; i++) {
        final e = images[i];
        final offsetY = i == 0 ? 0 : imageHeights.sublist(0, i).reduce((a,b) => a + b);
        // print("offset:${i}_${e.height}_${offsetY}");
        canvas.drawImage(e, Offset(0, offsetY.toDouble()), paint);
      }

      if (miniCode != null) {
        final miniCodeImage = await decodeImageFromList(miniCode);

        final w = totalWidth * 0.3;
        final h = w;

        final dx = totalWidth - right * ui.window.devicePixelRatio - w;
        final dy = totalHeight - bottom * ui.window.devicePixelRatio - h;

        canvas.drawImageRect(
          miniCodeImage,
          Rect.fromLTWH(0, 0, miniCodeImage.width.toDouble(),
              miniCodeImage.height.toDouble()),
          Rect.fromLTWH(dx.toDouble(), dy.toDouble(), w, h),
          paint,
        );
      }

      //获取合成的图片
      ui.Image image = await recorder.endRecording().toImage(totalWidth.toInt(), totalHeight.toInt());
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes == null) {
        throw new Exception('生成图片失败!');
      }
      //图片大小
      print("图片大小:${await image.fileSize() ?? "null"}");

      return pngBytes;
    } catch (e) {
      // print(e);
      return Future.error(e);
    }
  }

  /// 合成图片
  Future<Uint8List> toCompositePics() async {
    // List<GlobalKey?> keys = widget.models.map((e) => e.globalKey).toList();
    // return _compositePics(keys);
    List<String> urls = widget.models.map((e) => e.url ?? "").toList();
    final miniCodeBytes = await ImageExt.imageDataFromUrl(imageUrl: widget.QRCodeUrl);
    return toCompositeImageUrls(imageUrls: urls, miniCode: miniCodeBytes);
  }
}

/// 图片拼接 model
class MergeImageModel {
  int? id;
  String? name;
  String? url;
  String? width; // 素材宽度
  String? height; // 素材高度
  GlobalKey? globalKey;

  MergeImageModel({
    this.id,
    this.name,
    this.url,
    this.width,
    this.height,
  }): super() {
    this.globalKey =  GlobalKey();
  }
}



