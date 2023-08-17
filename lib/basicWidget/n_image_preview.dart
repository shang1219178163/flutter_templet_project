import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/overlay_ext.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view_gallery.dart';


// @version[创建日期，2023/6/8 14:36]
// @function[图片预览 ]
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
  late int currentIndex = widget.index;

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
          onPressed: widget.onBack,
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        ),
        leadingWidth: 48.w,
        actions: widget.urls.isEmpty ? [] : [
          buildCircleButton(
            padding: EdgeInsets.only(right: 16.w),
            radius: 16,
            icon: Icon(Icons.save_alt, color: Colors.white),
            onPressed: () {
              debugPrint("save");
              saveNetworkImage(url: widget.urls[currentIndex]);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: PhotoViewGallery.builder(
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: ExtendedNetworkImageProvider(
                    widget.urls[index],
                    cache: true,
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: widget.urls.length,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              pageController: PageController(initialPage: currentIndex),
              onPageChanged: (index) => setState(() {
                currentIndex = index;
              }),
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 15.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: StadiumBorder(),
              ),
              child: NText(
                data: '${currentIndex + 1}/${widget.urls.length}',
                color: Colors.white,
              ),
            ),
          ),
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
          onPressed: onPressed ?? () => Navigator.maybePop(context),
          icon: icon,
        ),
      ),
    );
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
    if(isSuccess){
      final message = result["isSuccess"] ? "图片已保存到相册" : "操作失败";
      showToast(text: message, barrierDismissible: false);
    }
  }
}
