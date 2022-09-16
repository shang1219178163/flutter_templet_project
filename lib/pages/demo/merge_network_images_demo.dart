import 'dart:async';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/extensions/image_extension.dart';
import 'package:flutter_templet_project/extensions/list_extension.dart';

class MergeNetworkImagesDemo extends StatefulWidget {

  final String? title;

  MergeNetworkImagesDemo({ Key? key, this.title}) : super(key: key);

  @override
  _MergeNetworkImagesDemoState createState() => _MergeNetworkImagesDemoState();
}

class _MergeNetworkImagesDemoState extends State<MergeNetworkImagesDemo> {

  GlobalKey _globalKey = GlobalKey();

  Widget? imageMerged;

  List<MaterialDetailConfig> detailList = <MaterialDetailConfig>[
    MaterialDetailConfig(
      id: 1,
      message: 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg',
      materialWidth: '400',
      materialHeight: '300', 
      // globalKey: GlobalKey(),
    ),
    MaterialDetailConfig(
      id: 2,
      message: 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg',
      materialWidth: '400',
      materialHeight: '700',
      // globalKey: GlobalKey(),
    ),
    MaterialDetailConfig(
      id: 3,
      message: 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-3.jpeg',
      materialWidth: '400',
      materialHeight: '700',
      // globalKey: GlobalKey(),
    ),
  ]; // 素材详情列表


  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {});
              },
              child: Text('刷新', style: TextStyle(color: Colors.white),)
            ),
            TextButton(
              onPressed: () {
                List<GlobalKey?> keys = detailList.map((e) => e.globalKey).toList();
                print("keys:${keys}");
                _compositePics(keys).then((pngBytes) {
                  imageMerged = Image.memory(pngBytes!, width: 400, height: 600);
                  setState(() {});
                });
              },
              child: Text('保存', style: TextStyle(color: Colors.white),)
            ),
          ],
        ),
        body: _buildBody(),
    );
  }

  _buildBody(){
    final screenSize = MediaQuery.of(this.context).size;

    List children = detailList.map((e) {
      int idx = detailList.indexOf(e);
      return _buildItem(
        hideUp: idx == 0,
        hideDown: idx == detailList.length - 1,
        repaintBoundary: RepaintBoundary(
          key: e.globalKey,
          child: FadeInImage.assetNetwork(
              placeholder: 'images/sha_qiu.png',
              image: e.message ?? 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg',
              fit: BoxFit.cover,
              width: double.parse(e.materialWidth ?? "${screenSize.width}"),
              height: double.parse(e.materialHeight ?? "${screenSize.height}"),
          ),
        ),
        callback: (step){
          print("callback:${step}");
          detailList.exchange(idx, idx + step);
          setState(() {});
        });
      }).toList();

    return SingleChildScrollView(
      key: _globalKey,
      child: Column(
        children: [
          if(imageMerged != null) imageMerged!,
          Text('合成图片'),
          ...children,
        ],
      ),
    );
  }

  _buildItem({
    required RepaintBoundary repaintBoundary,
    bool hideUp = false,
    bool hideDown = false,
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
              hideUp ? Container() : Container(
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
              hideUp ? Container() : SizedBox(height: 8),
              hideDown ? Container() : Container(
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
            ],
          ),
        ),
      ],
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
      //图片大小
      image.fileSize().then((value) => print(value));

      return Future.value(pngBytes);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
    return null;
  }
}

class MaterialDetailConfig {
  String? materialType; // 素材类型 text/image/video
  int? mainId;
  int? id;
  String? materialName; // 图片/视频名
  String? message; // 素材信息.文本/url
  String? materialWidth; // 素材宽度
  String? materialHeight; // 素材高度
  int? sort; // 排序
  String? examineId; // 审批id
  String? score; // 得分
  bool? deletedFlag; // 是否删除
  GlobalKey? globalKey;
  
  MaterialDetailConfig({
    this.materialType,
    this.mainId,
    this.id,
    this.materialName,
    this.message,
    this.materialWidth,
    this.materialHeight,
    this.sort,
    this.examineId,
    this.score,
    this.deletedFlag,
  }): super() {
    this.globalKey =  GlobalKey();
  }
}
