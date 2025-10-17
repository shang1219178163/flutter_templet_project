//
//  NFileUploadBox.dart
//  projects
//
//  Created by shang on 2024/8/27 15:47.
//  Copyright © 2024/8/27 shang. All rights reserved.
//

// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_Item.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_handle.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_model.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/file_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

/// 从文件存储系统选择文件
class NFileUploadBox extends StatefulWidget {
  const NFileUploadBox({
    super.key,
    this.controller,
    required this.items,
    this.itemWidth,
    this.itemHeight,
    this.title = "上传文件",
    this.description = "支持格式/单个文件大小限制/最大数量",
    required this.onChanged,
    this.onStart,
    this.onCancel,
    this.canEdit = true,
    this.showFileSize = false,
    this.maxMB = 100,
    this.maxCount = 9,
    this.type = FileType.custom,
    this.allowMultiple = true,
    required this.allowedExtensions,
    this.header,
    this.footer,
    this.fileUpload,
  });

  final NFileUploadBoxController? controller;

  final List<NFileUploadModel> items;
  final double? itemWidth;
  final double? itemHeight;
  final String title;
  final String description;

  /// 全部结束(有成功有失败 url="")或者删除完失败图片时会回调
  final ValueChanged<List<NFileUploadModel>> onChanged;

  /// 开始上传回调
  final VoidCallback? onStart;

  /// 取消
  final VoidCallback? onCancel;

  /// 可以编辑
  final bool canEdit;

  /// 做大个数
  final int maxCount;

  /// 最大尺寸
  final int maxMB;
  final FileType type;
  final bool allowMultiple;
  final List<String> allowedExtensions;

  /// 显示文件大小
  final bool showFileSize;
  final Widget? header;

  final Widget? footer;

  final NFileUploadHandle? fileUpload;

  @override
  State<NFileUploadBox> createState() => _NFileUploadBoxState();
}

class _NFileUploadBoxState extends State<NFileUploadBox> {
  late final List<NFileUploadModel> selectedModels = [];

  /// 全部上传结束
  final isAllUploadFinished = ValueNotifier(false);

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    widget.controller?._attach(this);
    selectedModels.addAll(widget.items);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NFileUploadBox oldWidget) {
    final entityIds = widget.items.map((e) => e.assetFile?.path).join(",");
    final oldWidgetEntityIds = oldWidget.items.map((e) => e.assetFile?.path).join(",");
    if (entityIds != oldWidgetEntityIds) {
      selectedModels
        ..clear()
        ..addAll(widget.items);
    }
    if (oldWidget.controller != widget.controller) {
      widget.controller?._attach(this);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    void urlBlock(String url) {
      final isAllFinished = selectedModels.where((e) => e.url == null).isEmpty;
      // debugPrint("isAllFinished: ${isAllFinished}");
      if (isAllFinished) {
        final urls = selectedModels.map((e) => e.url).toList();
        debugPrint("isAllFinished urls: $urls");
        widget.onChanged(selectedModels);
        isAllUploadFinished.value = true;
      }
    }

    onPick() async {
      await onPickFile(
        maxMB: widget.maxMB,
        maxCount: widget.maxCount,
        type: widget.type,
        allowMultiple: widget.allowMultiple,
        allowedExtensions: widget.allowedExtensions,
        onPermission: () async {
          //todo: 安卓权限
          // bool isGranted = await PhonePermission.checkDocument(
          //   permissionType: PermissionTypeEnum.im,
          // );
          // return isGranted;
          return true;
        },
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.header ??
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: NText(
                widget.title,
                fontSize: 14,
                color: AppColor.fontColor737373,
              ),
            ),
        ...selectedModels.map((e) {
          final index = selectedModels.indexOf(e);

          void deleteItem() {
            debugPrint("onDelete: $index, length: ${selectedModels[index].assetFile?.path}");
            selectedModels.remove(e);
            setState(() {});
            widget.onChanged(selectedModels);
          }

          // final fileName = (e.assetFile?.path ?? "").split("/").last;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              if (widget.fileUpload != null) {
                widget.fileUpload?.onTapItem(e);
                return;
              }
              onTapItem(e);
            },
            child: widget.fileUpload?.buildItem(
                    itemWidth: widget.itemWidth,
                    itemHeight: widget.itemHeight,
                    e: e,
                    urlBlock: urlBlock,
                    deleteItem: deleteItem,
                    canEdit: widget.canEdit,
                    showFileSize: widget.showFileSize) ??
                NFileUploadItem(
                  model: e,
                  canEdit: widget.canEdit,
                  urlBlock: urlBlock,
                  onDelete: widget.canEdit == false ? null : deleteItem,
                  showFileSize: widget.showFileSize,
                ),
          );
        }).toList(),
        if (selectedModels.length < widget.maxCount)
          widget.fileUpload?.buildUploadButton(onPressed: onPick) ?? buildUploadButton(onPressed: onPick),
        Offstage(
          offstage: !widget.canEdit,
          child: widget.footer ??
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: NText(
                  widget.description,
                  fontSize: 12,
                  color: AppColor.fontColorB3B3B3,
                ),
              ),
        ),
      ],
    );
  }

  Widget buildUploadButton({required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          // color: bgColor,
          border: Border.all(color: AppColor.lineColor),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: NPair(
          icon: Image(
            image: "icon_upload_one.png".toAssetImage(),
            width: 16,
            height: 16,
          ),
          child: NText(
            "选择文件并上传",
            fontSize: 14,
            color: AppColor.fontColorB3B3B3,
          ),
        ),
      ),
    );
  }

  /// 选择文件
  Future<void> onPickFile({
    int maxMB = 100,
    int maxCount = 9,
    FileType type = FileType.any,
    bool allowMultiple = true,
    required List<String> allowedExtensions,
    required FutureOr<bool> Function() onPermission,
  }) async {
    ToolUtil.removeInputFocus();
    if (!widget.canEdit) {
      debugPrint("无编辑权限");
      return;
    }

    if (!await onPermission()) {
      return;
    }

    try {
      var pickerResult = await FilePicker.platform.pickFiles(
        type: type,
        allowMultiple: allowMultiple,
        allowedExtensions: allowedExtensions,
      );

      final result = pickerResult?.files ?? [];
      final lengthBefore = result.length;
      DLog.d("result: 过滤前 ${result.length}");
      result.removeWhere((el) {
        final same = selectedModels.map((e) => e.assetFile?.path).contains(el.path);
        final result = same || el.size > maxMB * 1024 * 1024;
        return result;
      });
      final lengthAfter = result.length;
      DLog.d("result: 过滤后 ${result.length}");
      final filterCount = lengthBefore - lengthAfter;
      if (filterCount > 0) {
        ToastUtil.show("已过滤 $filterCount 个无效文件");
      }

      if (result.isEmpty == true) {
        debugPrint("没有添加");
        widget.onCancel?.call();
        return;
      }

      widget.onStart?.call();
      isAllUploadFinished.value = false;

      for (final e in result) {
        if (!selectedModels.contains(e)) {
          selectedModels.add(NFileUploadModel(assetFile: NPickFile.fromPlatformFile(e)));
        }
      }

      if (selectedModels.length > maxCount) {
        selectedModels.removeRange(0, selectedModels.length - maxCount);
      }
      setState(() {});
    } catch (e) {
      debugPrint("$this $e");
    }
  }

  onTapItem(NFileUploadModel model) {
    FocusScope.of(context).unfocus();
    if (model.url?.startsWith("http") == true) {
      final fileName = model.url?.split("/").last;
      switch (model.url!.fileType) {
        case NFileType.image:
          {
            final urls =
                selectedModels.where((e) => e.url?.startsWith("http") == true).map((e) => e.url ?? "").toList();
            final index = urls.indexOf(model.url ?? "");
            // debugPrint("urls: ${urls.length}, $index");
            FocusScope.of(context).unfocus();
            ToolUtil.imagePreview(urls, index);
          }
        case NFileType.video:
          {
            Get.toNamed(AppRouter.chewiePlayerPage, arguments: {
              "videoUrl": model.url,
              "videoTitle": fileName,
            });
          }
          break;
        case NFileType.audio:
          {
            Get.toNamed(AppRouter.audioPlayPage, arguments: {
              "url": model.url,
              "desc": fileName,
              "title": fileName,
            });
          }
          break;
        case NFileType.document:
          {
            // ToolUtil.webViewPreview(model.url ?? "", title: fileName ?? "");

            if (model.url?.startsWith("http") != true) {
              ToastUtil.show("文件链接失效");
              return;
            }
            final fileName = model.url?.split("/").last ?? "";
            final filUrl = model.url ?? "";
            ToolUtil.filePreview(fileName, filUrl);
          }
          break;
        default:
          break;
      }
    }
  }
}

/// AssetUploadBox 组件控制器
class NFileUploadBoxController {
  _NFileUploadBoxState? _anchor;

  void _attach(_NFileUploadBoxState anchor) {
    _anchor = anchor;
  }

  void _detach(_NFileUploadBoxState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  /// 是否全部上传结束
  ValueNotifier<bool>? get isAllUploadFinished => _anchor?.isAllUploadFinished;
}
