

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_image_preview.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_button.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_config.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:flutter_templet_project/extension/overlay_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';


/// 上传图片单元(基于 wechat_assets_picker)
class AssetUploadBox extends StatefulWidget {

  AssetUploadBox({
    Key? key,
    required this.items,
    required this.onChanged,
    this.maxCount = 9,
    this.rowCount = 4,
    this.spacing = 3,
    this.runSpacing = 3,
    this.canCameraTakePhoto = false,
    this.canEdit = true,
    this.showFileSize = false,
  }) : super(key: key);


  List<AssetUploadModel> items;
  /// 全部结束(有成功有失败 url="")或者删除完失败图片时会回调
  ValueChanged<List<AssetUploadModel>> onChanged;
  /// 做大个数
  int maxCount;
  /// 每行个数
  int rowCount;

  double spacing;

  double runSpacing;
  /// 可以 拍摄图片
  bool canCameraTakePhoto;

  /// 可以编辑
  bool canEdit;

  /// 显示文件大小
  bool showFileSize;

  @override
  _AssetUploadBoxState createState() => _AssetUploadBoxState();
}

class _AssetUploadBoxState extends State<AssetUploadBox> {

  late List<AssetUploadModel> selectedModels = widget.items;
  // List<AssetEntity> selectedEntitys = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return photoSection(
      items: selectedModels,
      maxCount: widget.maxCount,
      rowCount: widget.rowCount,
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      canEdit: widget.canEdit,
    );
  }

  photoSection({
    List<AssetUploadModel> items = const [],
    int maxCount = 9,
    int rowCount = 4,
    double spacing = 10,
    double runSpacing = 10,
    bool canEdit = true,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        var itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1))/rowCount).truncateToDouble();
        // print("itemWidth: $itemWidth");
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: WrapAlignment.start,
          children: [
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
                          onTap: (){
                            // debugPrint("onTap: ${e.url}");
                            final urls = items.where((e) => e.url?.startsWith("http") == true)
                              .map((e) => e.url ?? "").toList();
                            final index = urls.indexOf(e.url ?? "");
                            // debugPrint("urls: ${urls.length}, $index");
                            FocusScope.of(context).unfocus();

                            showEntry(
                              child: NImagePreview(
                                urls: urls,
                                index: index,
                                onBack: (){
                                  hideEntry();
                                },
                              ),
                            );

                            // Navigator.push(context, MaterialPageRoute(
                            //   builder: (_) {
                            //     return ImagePreview(
                            //       urls: urls,
                            //       index: index,
                            //     );
                            //   })
                            // );
                          },
                          child: AssetUploadButton(
                            model: e,
                            urlBlock: (url){
                              // e.url = url;
                              // debugPrint("e: ${e.data?.name}_${e.url}");
                              final isAllFinished = items.where((e) =>
                              e.url == null).isEmpty;
                              // debugPrint("isAllFinsied: ${isAllFinsied}");
                              if (isAllFinished) {
                                final urls = items.map((e) => e.url).toList();
                                debugPrint("isAllFinsied urls: ${urls}");
                                widget.onChanged(items);
                              }
                            },
                            onDelete: canEdit == false ? null : (){
                              debugPrint("onDelete: $index, lenth: ${items[index].file?.path}");
                              items.remove(e);
                              setState(() {});
                              widget.onChanged(items);
                            },
                            showFileSize: widget.showFileSize,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            if (items.length < maxCount && canEdit)
              InkWell(
                onTap: () {
                  onPicker(maxCount: maxCount);
                },
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
                      image: AssetImage("assets/images/icon_camera.png"),
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ),
              )
          ]
        );
      }
    );
  }

  onPicker({
    int maxCount = 4,
    // required Function(int length, String result) cb,
  }) async {
    try {
      final tmpUrls = selectedModels.map((e) => e.url).where((e) => e != null).toList();
      final tmpEntitys = selectedModels.map((e) => e.entity).where((e) => e != null).toList();
      final selectedEntitys = List<AssetEntity>.from(tmpEntitys);

      final result = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          requestType: RequestType.image,
          specialPickerType: SpecialPickerType.noPreview,
          selectedAssets: selectedEntitys,
          maxAssets: maxCount - tmpUrls.length,
          specialItemPosition: SpecialItemPosition.prepend,
          specialItemBuilder: (context, AssetPathEntity? path, int length,) {
            if (path?.isAll != true) {
              return null;
            }
            if (!widget.canCameraTakePhoto) {
              return null;
            }

            const textDelegate = AssetPickerTextDelegate();
            return Semantics(
              label: textDelegate.sActionUseCameraHint,
              button: true,
              onTapHint: textDelegate.sActionUseCameraHint,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  Feedback.forTap(context);
                  final takePhoto = await CameraPicker.pickFromCamera(
                    context,
                    pickerConfig: const CameraPickerConfig(enableRecording: true),
                  );
                  if (takePhoto != null) {
                    selectedModels.add(AssetUploadModel(entity: takePhoto));
                    debugPrint("selectedEntitys:${selectedEntitys.length} ${selectedModels.length}");
                    setState(() {});
                  }
                },
                child: const Center(
                  child: Icon(Icons.camera_enhance, size: 42.0),
                ),
              ),
            );
          },
        ),
      ) ?? [];

      // BrunoUtil.showLoading("图片处理中...");
      final same = result.map((e) => e.id).join() == selectedEntitys.map((e) => e.id).join();
      if (result.isEmpty || same) {
        debugPrint("没有添加新图片");
        return;
      }

      for (final e in result) {
        if (!selectedEntitys.contains(e)) {
          selectedModels.add(AssetUploadModel(entity: e));
        }
      }
      debugPrint("selectedEntitys:${selectedEntitys.length} ${selectedModels.length}");
      setState(() {});
    } catch (err) {
      debugPrint("err:$err");
      // BrunoUtil.showToast('$err');
      showToast(message: '$err');
    }
  }

  Future<String?> uploadFile({
    required String filePath,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final url = AssetUploadConfig.uploadUrl;
    assert(url.startsWith("http"), "请设置上传地址");

    final formData = FormData.fromMap({
      'files': await MultipartFile.fromFile(filePath),
    });
    final response = await Dio().post<Map<String, dynamic>>(
      url,
      data: formData,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    final res = response.data ?? {};
    final result = res['result'];
    return result;
  }

  showToast({required String message}) {
    Text(message).toShowCupertinoDialog(context: context);
  }
}
