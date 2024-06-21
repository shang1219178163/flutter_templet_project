//
//  AssetUploadDocumentBox.dart
//  hf
//
//  Created by shang on 2023/04/30 11:17.
//  Copyright © 2023/04/30 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/upload_document/asset_upload_document_button.dart';
import 'package:flutter_templet_project/basicWidget/upload_document/asset_upload_document_model.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/mixin/file_picker_mixin.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

/// 上传文档单元(基于 file_picker)
class AssetUploadDocumentBox extends StatefulWidget {
  const AssetUploadDocumentBox({
    super.key,
    this.controller,
    required this.items,
    this.onChanged,
    this.maxCount = 9,
    this.rowCount = 4,
    this.spacing = 3,
    this.runSpacing = 3,
    this.radius = 4,
    this.canEdit = true,
    this.hasPlaceholder = true,
    this.showFileSize = false,
    this.onStart,
    this.onCancel,
    this.hasUrls = false,
  });

  /// 控制器
  final AssetUploadDocumentBoxController? controller;

  /// 默认显示
  final List<AssetUploadDocumentModel> items;

  /// 全部结束(有成功有失败 url="")或者删除完失败图片时会回调
  final ValueChanged<List<AssetUploadDocumentModel>>? onChanged;

  /// 开始上传回调
  final ValueChanged<bool>? onStart;

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

  /// 圆角 默认4
  final double radius;

  /// 可以编辑
  final bool canEdit;

  /// 是否有占位图(不可编辑时占位图不可点击)
  final bool hasPlaceholder;

  /// 显示文件大小
  final bool showFileSize;

  // 但是是本地选择上传oss的，可以在相册里面回显。档案编辑不能回显
  final bool hasUrls;

  @override
  AssetUploadDocumentBoxState createState() => AssetUploadDocumentBoxState();
}

class AssetUploadDocumentBoxState extends State<AssetUploadDocumentBox>
    with FilePickerMixin {
  late final List<AssetUploadDocumentModel> selectedModels = [];

  // Sheet选择器
  final List<String> actions = ['拍摄', '从相册选择'];

  /// 全部上传结束
  final isAllUploadFinished = ValueNotifier(false);

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    // selectedModels.addAll(widget.items);
    widget.controller?._attach(this);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AssetUploadDocumentBox oldWidget) {
    final entityIds = widget.items.map((e) => e.file?.path).join(",");
    final oldWidgetEntityIds =
        oldWidget.items.map((e) => e.file?.path).join(",");
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
      radius: widget.radius,
      canEdit: widget.canEdit,
    );
  }

  photoSection({
    List<AssetUploadDocumentModel> items = const [],
    int maxCount = 9,
    int rowCount = 4,
    double spacing = 10,
    double runSpacing = 10,
    double radius = 4,
    bool canEdit = true,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final itemWidth = (maxWidth - spacing * (rowCount - 1)) / rowCount;
      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: [
          ...items.map((e) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: SizedBox(
                width: itemWidth,
                height: itemWidth,
                child: InkWell(
                  onTap: () {
                    if (e.url?.startsWith("http") != true) {
                      ToastUtil.show("文件链接失效");
                      return;
                    }
                    final fileName = e.url?.split("/").last ?? "";
                    final filUrl = e.url ?? "";
                    ToolUtil.filePreview(fileName, filUrl);
                  },
                  child: AssetUploadDocumentButton(
                    model: e,
                    width: itemWidth,
                    height: itemWidth,
                    radius: radius,
                    canEdit: canEdit,
                    urlBlock: (url) {
                      final isAllFinished =
                          items.where((e) => e.url == null).isEmpty;
                      if (isAllFinished) {
                        widget.onChanged?.call(items);
                        isAllUploadFinished.value = true;
                      }
                    },
                    onDelete: () {
                      items.remove(e);
                      setState(() {});
                      widget.onChanged?.call(items);
                    },
                    showFileSize: widget.showFileSize,
                  ),
                ),
              ),
            );
          }).toList(),
          if (items.length < maxCount && widget.hasPlaceholder)
            InkWell(
              onTap: () async {
                ToolUtil.removeFocus();
                if (!canEdit) {
                  debugPrint("无图片编辑权限");
                  return;
                }
                onPicker(maxCount: maxCount);
              },
              child: Container(
                width: itemWidth,
                height: itemWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColorF9F9F9,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Image(
                  image: 'assets/images/icon_upload.png'.toAssetImage(),
                  width: 24,
                  height: 24,
                ),
              ),
            )
        ],
      );
    });
  }

  /// 微信相册选择器
  Future<void> onPicker({
    int maxCount = 9,
    int maxMB = 28,
  }) async {
    try {
      List<File> files = await onPickerFiles(maxMB: maxMB);
      for (final file in files) {
        if (file.lengthSync() >= maxMB * 1024 * 1024) {
          ToastUtil.show("单个文件大小不得超出${maxMB}M");
          continue;
        }
      }
      if (files.isEmpty) {
        debugPrint("没有添加新图片");
        widget.onCancel?.call();
        return;
      }

      widget.onStart?.call(true);
      isAllUploadFinished.value = false;

      /// 添加文件前的数量
      final selectedModelsLength = selectedModels.length;

      for (final e in files) {
        if (!selectedModels.map((e) => e.file?.path).contains(e.path)) {
          selectedModels.add(AssetUploadDocumentModel(file: e));
        }
      }

      if (selectedModelsLength == selectedModels.length) {
        ToastUtil.show("文件已添加,请勿重复添加");
        return;
      }

      if (selectedModels.length > maxCount) {
        selectedModels.removeRange(0, selectedModels.length - maxCount);
      }

      // debugPrint(
      //     "selectedEntities:${selectedEntities.length} ${selectedModels.length}");
      setState(() {});
    } catch (err) {
      debugPrint("err:$err");
      // EasyToast.showToast('$err');
      showToast(message: '$err');
    }
  }

  showToast({required String message}) {
    Text(message).toShowCupertinoDialog(context: context);
  }
}

/// AssetUploadDocumentBox 组件控制器
class AssetUploadDocumentBoxController {
  AssetUploadDocumentBoxState? _anchor;

  void _attach(AssetUploadDocumentBoxState anchor) {
    _anchor = anchor;
  }

  void _detach(AssetUploadDocumentBoxState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  /// 是否全部上传结束
  ValueNotifier<bool> get isAllUploadFinished => _anchor!.isAllUploadFinished;
}
