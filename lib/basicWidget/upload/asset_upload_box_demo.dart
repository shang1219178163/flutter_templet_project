import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_image_preview.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_box.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:flutter_templet_project/cache/asset_cache_service.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/util/fade_page_route.dart';
import 'package:flutter_templet_project/util/tool_util.dart';

class AssetUploadBoxDemo extends StatefulWidget {
  AssetUploadBoxDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AssetUploadBoxDemoState createState() => _AssetUploadBoxDemoState();
}

class _AssetUploadBoxDemoState extends State<AssetUploadBoxDemo> {
  /// 没有默认数据
  // var selectedModels = <AssetUploadModel>[];

  /// 有默认数据
  var selectedModels = [
    "https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/beta/Health_APP/20230825/fb013ec6b90a4c5bb1059b003dada9ee.jpg",
    "https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/beta/Health_APP/20230825/ce326143c5b84fd9b99ffca943353b05.jpg",
  ].map((e) => AssetUploadModel(url: e, entity: null)).toList();

  /// 获取图片链接数组
  List<String> urls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    AssetCacheService().clearDirCache();
                    setState(() {});
                  },
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildAppBar({required Widget? title, List<Widget>? actions}) {
    return AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: fontColor,
          // size: 20,
        ),
        elevation: 0,
        shadowColor: const Color(0xffe4e4e4),
        title: Text(widget.title ?? "$widget"),
        titleTextStyle: const TextTheme(
          titleMedium: TextStyle(
            // headline6 is used for setting title's theme
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ).titleMedium,
        toolbarTextStyle: const TextTheme(
          titleMedium: TextStyle(
            // headline6 is used for setting title's theme
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ).titleMedium,
        actions: actions);
  }

  buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NText(
            "AssetUploadBox",
            fontSize: 16,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AssetUploadBox(
              maxCount: 8,
              // rowCount: 4,
              items: selectedModels,
              // canEdit: false,
              // showFileSize: true,
              onChanged: (items) {
                debugPrint("onChanged items.length: ${items.length}");
                selectedModels = items
                    .where((e) => e.url?.startsWith("http") == true)
                    .toList();
                urls = selectedModels.map((e) => e.url ?? "").toList();
                setState(() {});
              },
            ),
          ),
          Divider(),
          photoSection(items: selectedModels),
          Column(
            children: urls.map((e) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide()),
                ),
                child: NText(
                  e,
                  fontSize: 16.sp,
                  maxLines: 2,
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  photoSection({
    List<AssetUploadModel> items = const [],
    int maxCount = 9,
    int rowCount = 4,
    double spacing = 10,
    double runSpacing = 10,
    bool hasAddBtn = false,
  }) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var itemWidth =
          ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount)
              .truncateToDouble();
      // print("itemWidth: $itemWidth");
      return Wrap(spacing: spacing, runSpacing: runSpacing, children: [
        ...items.map((e) {
          // final size = await e.length()/(1024*1024);

          final index = items.indexOf(e);

          return Container(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: SizedBox(
                    width: itemWidth,
                    height: itemWidth,
                    child: InkWell(
                      onTap: () {
                        // debugPrint("onTap: ${e.url}");
                        final urls = items
                            .where((e) => e.url?.startsWith("http") == true)
                            .map((e) => e.url ?? "")
                            .toList();
                        final index = urls.indexOf(e.url ?? "");
                        // debugPrint("urls: ${urls.length}, $index");
                        jumpImagePreview(urls: urls, index: index);
                      },
                      child: Hero(
                        tag: e.url ?? "",
                        child: NNetworkImage(
                          url: e.url ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        if (items.length < maxCount && hasAddBtn)
          InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(top: 10, right: 10),
              width: itemWidth - 10,
              height: itemWidth - 10,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                // border: Border.all(width: 1),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              // child: Icon(Icons.camera_alt, color: Colors.black12,),
              child: Center(
                child: Image(
                  image: AssetImage("assets/images/medical/icon_camera.png"),
                  width: 24.w,
                  height: 24.w,
                ),
              ),
            ),
          )
      ]);
    });
  }

  /// 展示图片预览相册
  jumpImagePreview({
    required List<String> urls,
    required int index,
  }) {
    // ToolUtil.imagePreview(urls, index);
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      FadePageRoute(
        builder: (context) => NImagePreview(urls: urls, index: index),
      ),
    );
  }
}
