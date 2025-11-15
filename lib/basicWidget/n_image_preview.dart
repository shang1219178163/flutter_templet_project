//
//  NImagePreview.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/19 16:23.
//  Copyright © 2024/1/19 shang. All rights reserved.
//

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_image_indicator.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:flutter_templet_project/basicWidget/upload/image_service.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// 图片预览组件
class NImagePreview extends StatefulWidget {
  const NImagePreview({
    super.key,
    required this.urls,
    this.index = 0,
    this.onBack,
    this.isBlackBackgroud = true,
    this.extraInfoModels,
  });

  /// 图片列表
  final List<String> urls;

  /// 图片 额外信息 列表
  final List<AssetUploadModel>? extraInfoModels;

  /// 默认第几张
  final int index;

  /// 返回事件
  final VoidCallback? onBack;

  /// 背景色,默认黑色
  final bool isBlackBackgroud;

  @override
  _NImagePreviewState createState() => _NImagePreviewState();
}

class _NImagePreviewState extends State<NImagePreview> {
  /// 当前索引
  late final currentIndex = ValueNotifier(widget.index);

  late final pageController = PageController(
    initialPage: currentIndex.value,
  );

  /// widget.urls 映射数组
  late List<Map<String, dynamic>> urlMaps = List.generate(
      widget.urls.length,
      (i) => {
            "i": i,
            "url": widget.urls[i],
            "quarterTurns": 0,
          });

  /// 当前图片额外信息
  AssetUploadModel? get currExtraModel => widget.extraInfoModels?[currentIndex.value];

  /// 当前图片信息
  Map<String, dynamic>? get currImageMap {
    return urlMaps[currentIndex.value];

    // final extraInfoMap = currExtraModel?.extraInfoMap;
    // if (extraInfoMap?.isNotEmpty != true) {
    //   return null;
    // }
    // final uploadType = extraInfoMap?["uploadType"] == "TAKE_PIC" ? "拍照" : "本地相册";
    // return {
    //   "上  传 人": extraInfoMap?["uploadUser"] ?? "-",
    //   "上传时间": extraInfoMap?["uploadTime"] ?? "-",
    //   "上传方式": uploadType,
    // };
  }

  bool showImageInfo = false;

  late final buttonItems = [
    (child: Icon(Icons.info_outline, color: Colors.white), action: onDetail),
    (child: Icon(Icons.refresh, color: Colors.white), action: onRotate),
    (child: Icon(Icons.download, color: Colors.white), action: onDownload),
  ];

  //点击旋转按钮
  late int _angleNum = 0;

  late final barcodeScanner = BarcodeScanner();

  Color get bgColor => widget.isBlackBackgroud ? AppColor.fontColor181818 : Colors.white;

  Color get textColor => widget.isBlackBackgroud ? Colors.white : AppColor.fontColor181818;

  @override
  void initState() {
    super.initState();
  }

  void onBack() {
    if (widget.onBack != null) {
      widget.onBack?.call();
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: '',
        // mainColor: Colors.white,
        // brightness: Brightness.light,
        // overlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        leading: buildCircleButton(
          padding: EdgeInsets.only(left: 16.w),
          onPressed: () {
            onBack();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        ),
        leadingWidth: 48.w,
        title: ValueListenableBuilder(
          valueListenable: currentIndex,
          builder: (context, value, child) {
            final desc = '${value + 1}/${widget.urls.length}';
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: StadiumBorder(),
              ),
              child: NText(desc, fontSize: 16, color: textColor),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: AppColor.fontColor181818,
            child: GestureDetector(
              onTapUp: (v) async {
                onBack();
              },
              child: PhotoViewGallery.builder(
                builder: (BuildContext context, int index) {
                  int quarterTurns = urlMaps[index]["quarterTurns"];
                  final url = widget.urls[index];

                  final path = urlMaps[index]["path"] as String?;
                  if (path == null) {
                    getCachedImageFilePath(url).then((p) async {
                      if (p == null) {
                        return;
                      }
                      urlMaps[index]["path"] = p;
                      final barcodes = await barcodeScanner.processImage(InputImage.fromFilePath(p));
                      urlMaps[index]["qr"] = barcodes.map((e) => e.rawValue).toList().formatedString();
                    });
                  }

                  return PhotoViewGalleryPageOptions.customChild(
                    heroAttributes: PhotoViewHeroAttributes(
                      tag: url,
                    ),
                    child: RotatedBox(
                      quarterTurns: quarterTurns,
                      child: NNetworkImage(
                        url: url,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                  // return PhotoViewGalleryPageOptions(
                  //   imageProvider: ExtendedNetworkImageProvider(
                  //     widget.urls[index],
                  //     cache: true,
                  //   ),
                  // );
                },
                scrollDirection: Axis.horizontal,
                itemCount: widget.urls.length,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                pageController: pageController,
                onPageChanged: (index) {
                  currentIndex.value = index;
                },
              ),
            ),
          ),
          Positioned(bottom: 0, child: bottomMenu()),
        ],
      ),
    );
  }

  Widget buildCircleButton({
    EdgeInsets padding = EdgeInsets.zero,
    double? radius = 14,
    Widget icon = const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
    VoidCallback? onPressed,
  }) {
    return Padding(
      padding: padding,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black.withOpacity(0.3),
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }

  Widget buildButton({
    VoidCallback? onPressed,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: child,
      ),
    );
  }

  Widget imageInfoItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$title：",
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(179, 179, 179, 1),
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.left,
        maxLines: 10,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 底部菜单栏
  Widget bottomMenu() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: currentIndex,
            builder: (context, value, child) {
              // DLog.d("currentIndex: $currentIndex, $currImageMap");
              final showInfo = currImageMap != null;
              if (!showInfo) {
                return SizedBox();
              }

              if (!showImageInfo) {
                return Container(
                  height: 24,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: ShapeDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: StadiumBorder(),
                  ),
                  child: NImageIndicator(
                    itemCount: widget.urls.length,
                    controller: pageController,
                    indicatorColor: Colors.white.withOpacity(0.9),
                    indicatorOtherColor: Colors.white.withOpacity(0.3),
                  ),
                );
              }

              final entries = currImageMap?.entries;
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(
                  color: AppColor.fontColor181818,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    ...?entries?.map((e) => imageInfoItem(e.key, e.value?.toString() ?? "")),
                    const Divider(color: Colors.white60),
                  ],
                ),
              );
            },
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: showImageInfo ? bgColor : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: buttonItems.map(
                (e) {
                  return buildButton(
                    child: e.child,
                    onPressed: e.action,
                  );
                },
              ).toList(),
            ),
          ),
          // Container(
          //   height: 100,
          //   decoration: BoxDecoration(
          //     color: showImageInfo ? bgColor : null,
          //   ),
          // ),
          const SafeArea(child: SizedBox()),
        ],
      ),
    );
  }

  void onDetail() {
    showImageInfo = !showImageInfo;
    setState(() {});
  }

  void onRotate() {
    _angleNum++;
    urlMaps[currentIndex.value]["quarterTurns"] = _angleNum % 4;
    setState(() {});
  }

  void onDownload() {
    final url = widget.urls[currentIndex.value];
    ImageService().saveImage(url: url);
  }
}
