import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/extensions/image_extension.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extensions/list_extension.dart';

class MergeNetworkImagesDemo extends StatefulWidget {

  final String? title;

  MergeNetworkImagesDemo({ Key? key, this.title}) : super(key: key);

  @override
  _MergeNetworkImagesDemoState createState() => _MergeNetworkImagesDemoState();
}

class _MergeNetworkImagesDemoState extends State<MergeNetworkImagesDemo> {

  GlobalKey _globalKey = GlobalKey();
  // GlobalKey repaintBoundaryKey = GlobalKey(debugLabel: 'gk');

  GlobalKey repaintBoundaryKey1 = GlobalKey(debugLabel: 'gk1');
  GlobalKey repaintBoundaryKey2 = GlobalKey(debugLabel: 'gk2');
  GlobalKey repaintBoundaryKey3 = GlobalKey(debugLabel: 'gk3');

  Widget? imageMerged;

  final images = [
    'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg',
    'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg',
    'https://fastly.jsdelivr.net/npm/@vant/assets/apple-3.jpeg',
  ];

  List detailList = <MaterialDetailConfig>[
    MaterialDetailConfig(
      id: 1,
      message: 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg',
      materialWidth: '400',
      materialHeight: '300', 
      globalKey: GlobalKey(),
    ),
    MaterialDetailConfig(
      id: 2,
      message: 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg',
      materialWidth: '400',
      materialHeight: '700',
      globalKey: GlobalKey(),
    ),
    MaterialDetailConfig(
      id: 3,
      message: 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-3.jpeg',
      materialWidth: '400',
      materialHeight: '700',
      globalKey: GlobalKey(),
    ),
  ]; // 素材详情列表


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
        body: _buildBody(),
      // body: _buildBodyNew(),
    );
  }

  _buildBody(){
    final screenSize = MediaQuery.of(this.context).size;

    List children = detailList.map((e) => _buildItem(
      repaintBoundary: RepaintBoundary(
        key: e.globalKey,
        child: Image.network(e.message,
          fit: BoxFit.cover,
          width: double.parse(e.materialWidth),
          height: double.parse(e.materialHeight),
        ),
      ),
      upPress: (){
        print("upPress1");
      },
      downPress: (){
        print("downPress1");
      },
    )).toList();

    return SingleChildScrollView(
      key: _globalKey,
      child: Column(
        children: [
          if(imageMerged != null) imageMerged!,
          Text('合成图片'),
          ...children,
          // _buildItem(
          //   repaintBoundary: RepaintBoundary(
          //     key: repaintBoundaryKey1,
          //     child: Image.asset(
          //       'images/bg_alp.png',
          //       fit: BoxFit.cover,
          //       width: screenSize.width,
          //       height: screenSize.height * 0.25,
          //     ),
          //   ),
          //   upPress: (){
          //     print("upPress1");
          //   },
          //   downPress: (){
          //     print("downPress1");
          //   },
          // ),
          // _buildItem(
          //   repaintBoundary: RepaintBoundary(
          //     key: repaintBoundaryKey3,
          //     child: Image.asset(
          //       'images/sha_qiu.png',
          //       fit: BoxFit.cover,
          //       width: screenSize.width,
          //       height: screenSize.height,
          //     ),
          //   ),
          //   upPress: (){
          //     print("upPress3");
          //   },
          //   downPress: (){
          //     print("downPress3");
          //   },
          // ),
          // _buildItem(
          //   repaintBoundary: RepaintBoundary(
          //     key: repaintBoundaryKey2,
          //     child: Image.asset(
          //       'images/bg_ocean.png',
          //       fit: BoxFit.cover,
          //       width: screenSize.width,
          //       height: screenSize.height,
          //     ),
          //   ),
          //   upPress: (){
          //     print("upPress2");
          //   },
          //   downPress: (){
          //     print("downPress2");
          //   },
          // ),
        ],
      ),
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
            upPress: (){
              print("upPress1");
            },
            downPress: (){
              print("downPress1");
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
            upPress: (){
              print("upPress3");
            },
            downPress: (){
              print("downPress3");
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
            upPress: (){
              print("upPress2");
            },
            downPress: (){
              print("downPress2");
            },
          ),
        ],
      ),
    );
  }

  _buildItem({
    required RepaintBoundary repaintBoundary,
    VoidCallback? upPress,
    VoidCallback? downPress
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
                  onPressed: upPress,
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
                  onPressed: downPress,
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
      image.fileSize().then((value) => print(value));

      return Future.value(pngBytes);
    } catch (e) {
      print(e);
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
    this.globalKey,
  });
}
