import 'dart:async';
import 'dart:ffi';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_fade_page_route.dart';
import 'package:flutter_templet_project/basicWidget/n_image_preview.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_button.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 上传证件正反面(基于 wechat_assets_picker)
class CardUploadBox extends StatefulWidget {
  CardUploadBox({
    super.key,
    this.controller,
    required this.items,
    required this.onChanged,
    this.maxCount = 2,
    this.rowCount = 2,
    this.spacing = 0,
    this.runSpacing = 8,
    this.itemHeight,
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
  final CardUploadBoxController? controller;

  // /// 默认显示
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

  final double? itemHeight;

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
  CardUploadBoxState createState() => CardUploadBoxState();
}

class CardUploadBoxState extends State<CardUploadBox> {
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
    initData();
    widget.controller?._attach(this);
    super.initState();
  }

  initData() {
    selectedModels.replaceRange(0, selectedModels.length, widget.items);

    // selectedModels
    //   ..clear()
    //   ..addAll(widget.items);
  }

  @override
  void didUpdateWidget(covariant CardUploadBox oldWidget) {
    final entityIds = widget.items.map((e) => e.entity?.id).join(",");
    final oldWidgetEntityIds = oldWidget.items.map((e) => e.entity?.id).join(",");
    if (entityIds != oldWidgetEntityIds) {
      initData();
    }

    if (widget.items.isNotEmpty && selectedModels.isEmpty) {
      initData();
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount).truncateToDouble();

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: WrapAlignment.start,
          children: [
            ...items.map(
              (e) {
                // final size = await e.length()/(1024*1024);

                final index = items.indexOf(e);

                return ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: SizedBox(
                    width: itemWidth,
                    height: widget.itemHeight ?? itemWidth,
                    child: InkWell(
                      onTap: () {
                        // debugPrint("onTap: ${e.url}");
                        if (e.url?.startsWith("http") != true) {
                          if (!canEdit) {
                            debugPrint("${DateTime.now()} 无图片编辑权限");
                            return;
                          }
                          onPicker(maxCount: 1, index: index);
                          return;
                        }
                        final urls =
                            items.where((e) => e.url?.startsWith("http") == true).map((e) => e.url ?? "").toList();
                        final i = urls.indexOf(e.url ?? "");
                        // debugPrint("urls: ${urls.length}, $index");
                        FocusScope.of(context).unfocus();

                        if (widget.onTap != null) {
                          widget.onTap?.call(urls, i);
                          return;
                        }

                        jumpImagePreview(urls: urls, index: i);
                      },
                      child: AssetUploadButton(
                        model: e,
                        urlBlock: (url) {
                          // e.url = url;
                          // debugPrint("e: ${e.data?.name}_${e.url}");
                          final isAllFinished = items.where((e) => e.url?.startsWith("http") != true).isEmpty;
                          // debugPrint("isAllFinsied: ${isAllFinsied}");
                          if (isAllFinished) {
                            final urls = items.map((e) => e.url).toList();
                            debugPrint("isAllFinsied urls: $urls");
                            widget.onChanged(items);
                            isAllUploadFinished.value = true;
                            for (final url in urls) {
                              precacheImage(ExtendedNetworkImageProvider(url ?? ""), context);
                            }
                          }
                        },
                        onDelete: canEdit == false
                            ? null
                            : () {
                                debugPrint("onDelete: $index, lenth: ${items[index].file?.path}");
                                // items.remove(e);
                                for (var i = 0; i < selectedModels.length; i++) {
                                  final m = selectedModels[i];
                                  if (m.assetImage == e.assetImage) {
                                    selectedModels[i].clear();
                                  }
                                }
                                setState(() {});
                                widget.onChanged(items);
                              },
                        showFileSize: widget.showFileSize,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ],
        );
      },
    );
  }

  void updateEntity({
    required int index,
    required AssetEntity e,
  }) {
    final keys = selectedModels.map((e) => e.assetImage).where((e) => e != null).toList();
    if (keys.length == selectedModels.length) {
      selectedModels[index].entity = e;
    } else {
      selectedModels.add(AssetUploadModel(entity: e));
    }
  }

  onPicker({
    int maxCount = 4,
    required int index,
    // required Function(int length, String result) cb,
  }) async {
    try {
      // var isGranted = await PermissionUtil.checkPhotoAlbum();
      // if (!isGranted) {
      //   debugPrint("授权失败");
      //   return;
      // }

      final tmpUrls = selectedModels.map((e) => e.url).where((e) => e != null).toList();
      var tmpEntity = selectedModels.map((e) => e.entity).where((e) => e != null).toList();

      var selectedEntitys = List<AssetEntity>.from(tmpEntity);
      if (maxCount == 1) {
        final model = selectedModels[index];
        tmpEntity = [model].map((e) => e.entity).where((e) => e != null).toList();
        selectedEntitys = List<AssetEntity>.from(tmpEntity);
      }

      final result = await AssetPicker.pickAssets(
            context,
            pickerConfig: AssetPickerConfig(
              requestType: RequestType.image,
              specialPickerType: SpecialPickerType.noPreview,
              selectedAssets: selectedEntitys,
              maxAssets: maxCount,
              specialItemPosition: !widget.canTakePhoto ? SpecialItemPosition.none : SpecialItemPosition.prepend,
              specialItemBuilder: !widget.canTakePhoto
                  ? null
                  : (context, AssetPathEntity? path, int length) {
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
                          onTap: () => onTakePhoto(index: index),
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
          updateEntity(index: index, e: e);
        }
      }
      debugPrint("selectedEntitys:${selectedEntitys.length} ${selectedModels.length}");
      setState(() {});
    } catch (err) {
      debugPrint("err:$err");
      ToastHelper.showErrorToast('请检查相册/相机可用权限');
    }
  }

  // 相机拍摄
  Future<void> onTakePhoto({
    required int index,
    double? maxHeight,
    double? maxWidth,
    int imageQuality = 50,
  }) async {
    try {
      final tmpEntities = selectedModels.map((e) => e.entity).where((e) => e != null).toList();
      final selectedEntitys = List<AssetEntity>.from(tmpEntities);
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
      final e = await PhotoManager.editor.saveImageWithPath(
        imageFile.path,
        title: 'image_${DateTime.now().millisecond}',
      );

      if (!selectedEntitys.contains(e)) {
        updateEntity(index: index, e: e);
      }

      Navigator.pop(context);
      setState(() {});
    } catch (e) {
      debugPrint("❌onTakePhoto: $e");
      ToastHelper.showErrorToast('请检查相册/相机可用权限');
    }
  }

  /// 展示图片预览相册
  jumpImagePreview({
    required List<String> urls,
    required int index,
  }) {
    FocusScope.of(context).unfocus();
    Widget imagePreView = NImagePreview(urls: urls, index: index);
    Navigator.push(
      context,
      CustomFadePageRoute(
        builder: (context) => imagePreView,
      ),
    );
  }
}

/// CardUploadBox 组件控制器
class CardUploadBoxController {
  CardUploadBoxState? _anchor;

  void _attach(CardUploadBoxState anchor) {
    _anchor = anchor;
  }

  void _detach(CardUploadBoxState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  /// 是否全部上传结束
  ValueNotifier<bool> get isAllUploadFinished => _anchor!.isAllUploadFinished;
}
