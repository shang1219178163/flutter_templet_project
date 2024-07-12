//
//  NImagePreview.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/19 16:23.
//  Copyright © 2024/1/19 shang. All rights reserved.
//

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_image_indicator.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/overlay_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// 图片预览组件
class NImagePreview extends StatefulWidget {
  const NImagePreview({
    Key? key,
    required this.urls,
    this.index = 0,
    this.onBack,
  }) : super(key: key);

  /// 图片列表
  final List<String> urls;

  /// 默认第几张
  final int index;

  /// 返回事件
  final VoidCallback? onBack;

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

  late final buttonItems = [
    (child: Icon(Icons.refresh, color: Colors.white), action: onRotate),
    (child: Icon(Icons.download, color: Colors.white), action: onDownload),
  ];

  //点击旋转按钮
  late int _angleNum = 0;

  @override
  void initState() {
    super.initState();
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
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
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
                child: NText(
                  desc,
                  fontSize: 16,
                  color: Colors.white,
                ),
              );
            }),
        // actions: widget.urls.isEmpty
        //     ? []
        //     : [
        //         buildCircleButton(
        //           padding: EdgeInsets.only(right: 16.w),
        //           radius: 16,
        //           icon: Icon(Icons.save_alt, color: Colors.white),
        //           onPressed: onDownload,
        //         ),
        //       ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: PhotoViewGallery.builder(
              builder: (BuildContext context, int index) {
                int quarterTurns = urlMaps[index]["quarterTurns"];
                final url = widget.urls[index];

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
              onPageChanged: (index) => setState(() {
                currentIndex.value = index;
              }),
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
    Widget icon =
        const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
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
    EdgeInsets margin = EdgeInsets.zero,
    double? radius = 8,
    VoidCallback? onPressed,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        margin: margin,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.all(Radius.circular(radius!)),
        ),
        child: child,
      ),
    );
  }

  /// 底部菜单栏
  Widget bottomMenu() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          NImageIndicator(
            itemCount: widget.urls.length,
            controller: pageController,
            indicatorColor: Colors.white.withOpacity(0.9),
            indicatorOtherColor: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: buttonItems.map(
              (e) {
                return buildButton(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: e.child,
                  ),
                  onPressed: e.action,
                );
              },
            ).toList(),
          ),
          const SafeArea(child: SizedBox()),
        ],
      ),
    );
  }

  void onRotate() {
    _angleNum++;
    urlMaps[currentIndex.value]["quarterTurns"] = _angleNum % 4;
    setState(() {});
  }

  void onDownload() {
    saveNetworkImage(url: widget.urls[currentIndex.value]);
  }

  saveNetworkImage({required String url}) async {
    String? name;
    try {
      name = url.split("/").last;
    } catch (e) {
      debugPrint("saveNetworkImage name: ${e.toString()}");
    }

    var response = await Dio().get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    final imageBytes = Uint8List.fromList(response.data);
    final result = await ImageGallerySaver.saveImage(
      imageBytes,
      quality: 90,
      name: name,
    );
    debugPrint("saveImage: $result $url");
    final isSuccess = result["isSuccess"];
    if (isSuccess) {
      final message = result["isSuccess"] ? "图片已保存到相册" : "操作失败";
      showToast(message, barrierDismissible: false);
    }
  }
}
