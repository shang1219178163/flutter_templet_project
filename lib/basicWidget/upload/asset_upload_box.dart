import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_image_preview.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_button.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/fade_page_route.dart';
import 'package:flutter_templet_project/util/permission_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

/// 上传图片单元(基于 wechat_assets_picker)
class AssetUploadBox extends StatefulWidget {
  AssetUploadBox({
    super.key,
    this.controller,
    required this.items,
    required this.onChanged,
    this.maxCount = 9,
    this.rowCount = 4,
    this.spacing = 3,
    this.runSpacing = 3,
    this.canTakePhoto = false,
    this.canEdit = true,
    this.imgBuilder,
    this.onTap,
    this.showFileSize = false,
    this.hasTakePhoto = false,
    this.onStart,
    this.onCancel,
  });

  /// 控制器
  final AssetUploadBoxController? controller;

  /// 默认显示
  final List<AssetUploadModel> items;

  /// 全部结束(有成功有失败 url="")或者删除完失败图片时会回调
  final ValueChanged<List<AssetUploadModel>> onChanged;

  /// 权限校验
  // final FutureOr<bool> Function() onPermission;

  /// 开始上传回调
  final VoidCallback? onStart;

  /// 取消
  final VoidCallback? onCancel;

  /// 做大个数
  final int maxCount;

  /// 每行个数
  final int rowCount;

  /// 水平间距
  final double spacing;

  /// 垂直间距
  final double runSpacing;

  /// 可以 拍摄图片
  final bool canTakePhoto;

  /// 可以编辑
  final bool canEdit;

  /// 网络图片url转为组件
  final Widget Function(String url)? imgBuilder;

  /// 图片点击事件
  final Void Function(List<String> urls, int index)? onTap;

  /// 显示文件大小
  final bool showFileSize;

  /// 是否只拍照
  final bool hasTakePhoto;

  @override
  AssetUploadBoxState createState() => AssetUploadBoxState();
}

class AssetUploadBoxState extends State<AssetUploadBox> {
  late final List<AssetUploadModel> selectedModels = [];

  final _imagePicker = ImagePicker();

  /// 全部上传结束
  final isAllUploadFinished = ValueNotifier(false);

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    selectedModels.addAll(widget.items);
    widget.controller?._attach(this);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AssetUploadBox oldWidget) {
    final entityIds = widget.items.map((e) => e.entity?.id).join(",");
    final oldWidgetEntityIds = oldWidget.items.map((e) => e.entity?.id).join(",");
    if (entityIds != oldWidgetEntityIds) {
      selectedModels
        ..clear()
        ..addAll(widget.items);
    }
    super.didUpdateWidget(oldWidget);
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
      builder: (BuildContext context, BoxConstraints constraints) {
        var itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount).truncateToDouble();
        // print("itemWidth: $itemWidth");
        return Wrap(spacing: spacing, runSpacing: runSpacing, alignment: WrapAlignment.start, children: [
          ...items.map(
            (e) {
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
                            final urls =
                                items.where((e) => e.url?.startsWith("http") == true).map((e) => e.url ?? "").toList();
                            final index = urls.indexOf(e.url ?? "");
                            // debugPrint("urls: ${urls.length}, $index");
                            FocusScope.of(context).unfocus();

                            if (widget.onTap != null) {
                              widget.onTap?.call(urls, index);
                              return;
                            }

                            jumpImagePreview(urls: urls, index: index);
                          },
                          child: AssetUploadButton(
                            model: e,
                            urlBlock: (url) {
                              // e.url = url;
                              // debugPrint("e: ${e.data?.name}_${e.url}");
                              final isAllFinished = items.where((e) => e.url == null).isEmpty;
                              // debugPrint("isAllFinsied: ${isAllFinsied}");
                              if (isAllFinished) {
                                final urls = items.map((e) => e.url).toList();
                                debugPrint("isAllFinsied urls: $urls");
                                widget.onChanged(items);
                                isAllUploadFinished.value = true;
                              }
                            },
                            onDelete: canEdit == false
                                ? null
                                : () {
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
            },
          ).toList(),
          if (items.length < maxCount)
            InkWell(
              onTap: () {
                if (!canEdit) {
                  debugPrint("无图片编辑权限");
                  return;
                }
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
        ]);
      },
    );
  }

  onPicker({
    int maxCount = 4,
    // required Function(int length, String result) cb,
  }) async {
    try {
      var isGranted = await PermissionUtil.checkPhotoAlbum();
      if (!isGranted) {
        debugPrint("授权失败");
        return;
      }

      final tmpUrls = selectedModels.map((e) => e.url).where((e) => e != null).toList();
      final tmpEntity = selectedModels.map((e) => e.entity).where((e) => e != null).toList();

      final selectedEntitys = List<AssetEntity>.from(tmpEntity);

      final result = await AssetPicker.pickAssets(
            context,
            pickerConfig: AssetPickerConfig(
              requestType: RequestType.image,
              specialPickerType: SpecialPickerType.noPreview,
              selectedAssets: selectedEntitys,
              maxAssets: maxCount,
              specialItemPosition: SpecialItemPosition.prepend,
              specialItemBuilder: (
                context,
                AssetPathEntity? path,
                int length,
              ) {
                if (path?.isAll != true) {
                  return null;
                }
                if (!widget.canTakePhoto) {
                  return null;
                }

                const textDelegate = AssetPickerTextDelegate();
                return Semantics(
                  label: textDelegate.sActionUseCameraHint,
                  button: true,
                  onTapHint: textDelegate.sActionUseCameraHint,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: takePhotoByWechatCamera,
                    child: Container(
                      padding: const EdgeInsets.all(28.0),
                      color: Theme.of(context).dividerColor,
                      child: const FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.camera_enhance),
                      ),
                    ),
                  ),
                );
              },
            ),
          ) ??
          [];

      // BrunoUtil.showLoading("图片处理中...");
      final same = result.map((e) => e.id).join() == selectedEntitys.map((e) => e.id).join();
      if (result.isEmpty || same) {
        debugPrint("没有添加新图片");
        widget.onCancel?.call();
        return;
      }

      widget.onStart?.call();
      isAllUploadFinished.value = false;

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

  /// 微信风格相机
  Future<void> takePhotoByWechatCamera() async {
    try {
      // if (!await widget.onPermission()) {
      //   debugPrint("授权失败");
      //   return;
      // }

      Feedback.forTap(context);
      final takePhoto = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: const CameraPickerConfig(
          enableRecording: true,
        ),
      );
      if (takePhoto == null) {
        debugPrint("没有拍照,直接返回");
        widget.onCancel?.call();
        return;
      }

      widget.onStart?.call();
      isAllUploadFinished.value = false;

      selectedModels.add(AssetUploadModel(entity: takePhoto));
      // debugPrint(
      //     "selectedEntitys:${selectedEntitys.length} ${selectedModels.length}");
      setState(() {});
    } catch (e) {
      debugPrint("$this $e");
    }
  }

  // 相机拍摄
  Future<void> onTakePhoto({
    double? maxHeight,
    double? maxWidth,
    int imageQuality = 50,
  }) async {
    try {
      // if (!await widget.onPermission()) {
      //   debugPrint("授权失败");
      //   return;
      // }

      final tmpEntities = selectedModels.map((e) => e.entity).where((e) => e != null).toList();

      final selectedEntities = List<AssetEntity>.from(tmpEntities);
      //相机
      var imageFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      /// 没有拍照,直接返回
      if (imageFile == null) {
        debugPrint("没有拍照,直接返回");
        widget.onCancel?.call();
        return;
      }

      widget.onStart?.call();
      isAllUploadFinished.value = false;

      // Uint8List bytes = await imageFile.readAsBytes();
      final imageEntity = await PhotoManager.editor.saveImageWithPath(
        imageFile.path,
        title: 'image_${DateTime.now().millisecond}',
      );
      if (!selectedEntities.contains(imageEntity)) {
        selectedModels.add(AssetUploadModel(entity: imageEntity));
      }
      setState(() {});
    } catch (e) {
      debugPrint("❌onTakePhoto: $e");
    }
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

  showToast({required String message}) {
    Text(message).toShowCupertinoDialog(context: context);
  }
}

/// AssetUploadBox 组件控制器
class AssetUploadBoxController {
  AssetUploadBoxState? _anchor;

  void _attach(AssetUploadBoxState anchor) {
    _anchor = anchor;
  }

  void _detach(AssetUploadBoxState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  /// 是否全部上传结束
  ValueNotifier<bool> get isAllUploadFinished => _anchor!.isAllUploadFinished;
}
