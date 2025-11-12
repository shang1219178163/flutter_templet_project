import 'dart:async';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/basicWidget/merge_images_widget.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/image_ext.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class MergeNetworkImagesDemo extends StatefulWidget {
  final String? title;

  const MergeNetworkImagesDemo({Key? key, this.title}) : super(key: key);

  @override
  _MergeNetworkImagesDemoState createState() => _MergeNetworkImagesDemoState();
}

class _MergeNetworkImagesDemoState extends State<MergeNetworkImagesDemo> {
  final keyView = WidgetsBinding.instance.platformDispatcher.views.first;
  late final devicePixelRatio = keyView.devicePixelRatio;

  final _globalKey = GlobalKey<MergeImagesWidgetState>();

  Widget? imageMerged;

  List<MaterialDetailConfig> detailList = <MaterialDetailConfig>[
    MaterialDetailConfig(
      id: 1,
      message: 'https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg',
      materialWidth: '400',
      materialHeight: '300',
      // globalKey: GlobalKey(),
    ),
    MaterialDetailConfig(
      id: 2,
      message: 'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
      materialWidth: '400',
      materialHeight: '300',
      // globalKey: GlobalKey(),
    ),
    MaterialDetailConfig(
      id: 3,
      message: 'https://pic.616pic.com/bg_w1180/00/07/20/2gfqq0N3qX.jpg!/fw/1120',
      materialWidth: '400',
      materialHeight: '300',
      // globalKey: GlobalKey(),
    ),
  ]; // 素材详情列表

  final qrCodeUrl = "https://lf3-cdn-tos.bytescm.com/obj/static/xitu_juejin_web/img/article.9d13ff7.png";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(this.context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
              onPressed: () async {
                _globalKey.currentState?.toCompositePics().then((pngBytes) {
                  imageMerged = Image.memory(pngBytes, width: screenSize.width, height: 600);
                  setState(() {});
                });
              },
              child: Text(
                '刷新',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
            onPressed: () {
              _globalKey.currentState?.toCompositePics().then((pngBytes) {
                return ImageGallerySaverPlus.saveImage(
                  pngBytes,
                  quality: 100,
                );
              }).then((result) {
                DLog.d("result:$result");
              }).catchError((e) {
                debugPrint("error:$e");
              });
            },
            child: Text(
              '保存',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      // body: buildBody(),
      body: _buildBodyNew(),
    );
  }

  _buildBodyNew() {
    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          if (imageMerged != null) imageMerged!,
          Text('合成图片'),
          Divider(),
          MergeImagesWidget(
            key: _globalKey,
            // width: screenSize.width,
            models: detailList
                .map((e) => MergeImageModel(
                      url: e.message,
                      width: e.materialWidth,
                      height: e.materialHeight,
                    ))
                .toList(),
            qrCodeBuilder: (url) => Image.asset(
              'QRCode.png'.toPath(),
              width: 90,
              height: 90,
            ),
            qrCodeUrl: qrCodeUrl,
          ),
        ],
      ),
    );
  }

  buildBody() {
    final screenSize = MediaQuery.of(context).size;

    var children = detailList.map((e) {
      var idx = detailList.indexOf(e);
      return _buildToolNew(
        hideUp: idx == 0,
        hideDown: idx == detailList.length - 1,
        repaintBoundary: RepaintBoundary(
          key: e.globalKey,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/sha_qiu.png',
            image: e.message ?? 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg',
            fit: BoxFit.cover,
            width: double.parse(e.materialWidth ?? "${screenSize.width}"),
            height: double.parse(e.materialHeight ?? "${screenSize.height}"),
          ),
        ),
        callback: (step) {
          debugPrint("callback:$step");
          detailList.exchange(idx, idx + step);
          setState(() {});
        },
      );
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          if (imageMerged != null) imageMerged!,
          Text('合成图片'),
          ...children,
        ],
      ),
    );
  }

  _buildToolNew({
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
                image: Image.asset('icon_move_up.png'.toPath()),
                hidden: hideUp,
              ),
              hideUp ? Container() : SizedBox(height: 6),
              _buildBtn(
                image: Image.asset('icon_move_down.png'.toPath()),
                onTap: () => callback?.call(1),
                hidden: hideDown,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildTool({
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
              _buildBtnSystemIcon(
                image: Icon(
                  Icons.arrow_circle_up,
                ),
                onTap: () => callback?.call(-1),
                hidden: hideUp,
              ),
              hideUp ? Container() : SizedBox(height: 6),
              _buildBtnSystemIcon(
                image: Icon(
                  Icons.arrow_circle_down,
                ),
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

  /// 系统图标
  _buildBtnSystemIcon({
    Widget? image,
    double? width = 28,
    double? height = 28,
    double radius = 6,
    GestureTapCallback? onTap,
    bool hidden = false,
  }) {
    if (hidden) {
      return Container();
    }
    return Container(
      width: width,
      height: height,
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius))),
        onPressed: onTap,
        child: image,
      ),
    );
  }

  /// 通过多个 SingleChildScrollView 的 RepaintBoundary 对象合成长海报
  ///
  /// keys: 根据 GlobalKey 获取 Image 数组
  Future<Uint8List?> _compositePics([
    List<GlobalKey?> keys = const [],
  ]) async {
    //根据 GlobalKey 获取 Image 数组
    //根据 GlobalKey 获取 Image 数组
    var imgs = await Future.wait(keys.map((key) async {
      var boundary = key?.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary?.toImage(pixelRatio: devicePixelRatio);
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
        final offsetY = i == 0 ? 0 : imageHeights.sublist(0, i).reduce((a, b) => a + b);
        // print("offset:${i}_${e.height}_${offsetY}");
        canvas.drawRect(Rect.fromLTWH(0, offsetY.toDouble(), totalWidth * 1.0, e.height * 1.0), paint);
        canvas.drawImage(e, Offset(0, offsetY.toDouble()), paint);
      }

      //获取合成的图片
      var image = await recorder.endRecording().toImage(totalWidth, totalHeight);
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      //图片大小
      debugPrint("图片大小:${await image.fileSize() ?? "null"}");

      return Future.value(pngBytes);
    } catch (e) {
      debugPrint(e.toString());
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
  }) : super() {
    globalKey = GlobalKey();
  }
}
