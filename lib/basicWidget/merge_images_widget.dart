
import 'dart:async';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/extensions/image_extension.dart';
import 'package:flutter_templet_project/extensions/list_extension.dart';

/// 合并多张图片为长图
class MergeImagesWidget extends StatefulWidget {

  List<MergeImageModel> models = [];
  Widget Function(MergeImageModel model)? imageBuilder;

  MergeImagesWidget({
    Key? key,
    this.models = const [],
    this.imageBuilder,
  }) : super(key: key);

  @override
  MergeImagesWidgetState createState() => MergeImagesWidgetState();
}

class MergeImagesWidgetState extends State<MergeImagesWidget> {
  
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody(){
    final screenSize = MediaQuery.of(this.context).size;

    List<Widget> children = widget.models.map((e) {
      int idx = widget.models.indexOf(e);
      return _buildTool(
          hideUp: idx == 0,
          hideDown: idx == widget.models.length - 1,
          repaintBoundary: RepaintBoundary(
            key: e.globalKey,
            child: widget.imageBuilder != null ? widget.imageBuilder!(e) : FadeInImage.assetNetwork(
              placeholder: 'images/img_placeholder.png',
              image: e.url ?? '',
              fit: BoxFit.cover,
              width: double.parse(e.width ?? "${screenSize.width}"),
              height: double.parse(e.height ?? "${screenSize.height}"),
            ),
          ),
          callback: (step){
            print("callback:${step}");
            widget.models.exchange(idx, idx + step);
            setState(() {});
          });
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

  /// 通过多个 SingleChildScrollView 的 RepaintBoundary 对象合成长海报
  ///
  /// keys: 根据 GlobalKey 获取 Image 数组
  Future<Uint8List?> _compositePics([List<GlobalKey?> keys = const [],]) async {
    //根据 GlobalKey 获取 Image 数组
    List<ui.Image> images = await Future.wait(
        keys.map((key) async {
          BuildContext? buildContext = key?.currentContext!;
          RenderRepaintBoundary boundary = buildContext?.findRenderObject() as RenderRepaintBoundary;
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
      if (pngBytes == null) {
        throw new Exception('生成图片失败!');
      }
      //图片大小
      image.fileSize().then((value) => print("长图大小:${value}"));

      return Future.value(pngBytes);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
    return null;
  }

  /// 合成图片
  Future<Uint8List?> toCompositePics() {
    List<GlobalKey?> keys = widget.models.map((e) => e.globalKey).toList();
    // print("keys:${keys}");
    return _compositePics(keys);
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



