//
//  NFileUploadItem.dart
//  yl_health_app
//
//  Created by shang on 2023/04/30 11:19.
//  Copyright © 2023/04/30 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/upload/image_service.dart';
import 'package:flutter_templet_project/basicWidget/upload/video_service.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_model.dart';

import 'package:flutter_templet_project/network/oss/oss_util.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

typedef NFileUploadItemBuilder = Widget Function(
  NFileUploadModel model,
  VoidCallback? onDelete,
  VoidCallback? onRefresh,
  ValueNotifier<bool> successVN,
  ValueNotifier<double> percentVN,
);

/// 上传图片单元(基于 wechat_assets_picker)
class NFileUploadItem extends StatefulWidget {
  const NFileUploadItem({
    super.key,
    required this.model,
    this.radius = 4,
    this.urlBlock,
    this.onDelete,
    this.canEdit = true,
    this.showFileSize = false,
    this.borderColor = Colors.transparent,
    this.builder,
  });

  final NFileUploadModel model;

  /// 圆角 默认8
  final double radius;

  /// 上传成功获取 url 回调
  final ValueChanged<String>? urlBlock;

  /// 返回删除元素的 id
  final VoidCallback? onDelete;

  /// 显示文件大小
  final bool showFileSize;

  /// 边框颜色
  final Color borderColor;

  /// 是否可编辑 - 删除
  final bool canEdit;

  final NFileUploadItemBuilder? builder;

  @override
  NFileUploadItemState createState() => NFileUploadItemState();
}

class NFileUploadItemState extends State<NFileUploadItem> with AutomaticKeepAliveClientMixin {
  /// 防止触发多次上传动作
  var _isLoading = false;

  /// 请求成功或失败
  final _successVN = ValueNotifier(true);

  /// 上传进度
  final _percentVN = ValueNotifier(0.0);

  String? get filePath => widget.model.assetFile?.path;

  String? get fileName => widget.model.assetFile?.name;

  // bool? get only => widget.model.url?.startsWith("http") == true;

  @override
  void initState() {
    super.initState();

    onRefresh();
  }

  @override
  void didUpdateWidget(covariant NFileUploadItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    final urlSame = widget.model.url?.startsWith("http") == true &&
        oldWidget.model.url?.startsWith("http") == true &&
        widget.model.url == oldWidget.model.url;

    if (widget.model.assetFile?.path == oldWidget.model.assetFile?.path || urlSame) {
      // EasyToast.showInfoToast("path相同");
      return;
    }
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final fileName = widget.model.fileName ?? "--";

    final fileNameNew = fileName.split(".").firstOrNull ?? "--";
    final ext = fileName.split(".").lastOrNull ?? "";

    if (widget.builder != null) {
      return widget.builder!(
        widget.model,
        widget.onDelete,
        onRefresh,
        _successVN,
        _percentVN,
      );
    }

    final nameWidget = Row(
      children: [
        Flexible(
          child: NText(
            fileNameNew,
            fontSize: 14,
            color: AppColor.fontColor737373,
            maxLines: 1,
          ),
        ),
        NText(
          ".$ext",
          fontSize: 14,
          color: AppColor.fontColor737373,
          maxLines: 1,
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 9,
      ),
      padding: const EdgeInsets.only(
        left: 10,
        top: 9,
        bottom: 9,
        right: 12,
      ),
      decoration: const BoxDecoration(
        color: AppColor.bgColor,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  child: nameWidget,
                ),
              ),
              buildDelete(),
            ],
          ),
          if (widget.canEdit) buildUploading(),
          if (widget.showFileSize)
            buildFileSizeInfo(
              length: widget.model.assetFile?.size,
            ),
        ],
      ),
    );
  }

  /// 右上角删除按钮
  Widget buildDelete() {
    if (widget.onDelete == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: widget.onDelete,
      child: const Image(
        image: AssetImage(
          "assets/images/icon_trash.png",
        ),
        width: 12,
        height: 14,
      ),
    );
  }

  Widget buildUploading() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _successVN,
        _percentVN,
      ]),
      builder: (context, child) {
        // YLog.d("buildUploading ${fileName}: ${_percentVN.value}");
        if (_successVN.value == false) {
          return buildUploadFail();
        }
        final value = _percentVN.value;
        if (value >= 1) {
          return const SizedBox();
        }

        final showPercent = widget.model.assetFile != null && (widget.model.assetFile!.size > 2 * 1024 * 1024) == true;

        final desc = showPercent ? value.toStringAsPercent(2) : "上传中";

        return Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: _percentVN.value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: NText(
                desc,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildUploadFail() {
    return InkWell(
      onTap: onRefresh,
      child: const Row(
        children: [
          // Icon(Icons.refresh, color: Colors.red),
          NText(
            "点击重试",
            fontSize: 14,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Future<String?> uploadFile({
    required String path,
  }) async {
    var res = await OssUtil.upload(
      filePath: path,
      onSendProgress: (int count, int total) {
        final percent = (count / total);
        if (percent >= 0.99) {
          _percentVN.value = 0.99;
        } else {
          _percentVN.value = percent;
        }
      },
      onReceiveProgress: (int count, int total) {
        _percentVN.value = 1;
      },
    );
    _percentVN.value = 1;
    if (res != null) {
      // debugPrint("res: $res");
      return res;
    }
    return null;
  }

  onRefresh() {
    if (!widget.canEdit) {
      return;
    }

    if (widget.model.assetFile == null && widget.model.url?.startsWith("http") == true) {
      return;
    }

    // debugPrint("onRefresh ${widget.entity}");
    final path = widget.model.assetFile?.path;
    if (path == null || path.isEmpty) {
      throw "文件路径为空";
    }

    if (_isLoading) {
      debugPrint("_isLoading: $_isLoading ${widget.model.assetFile}");
      return;
    }

    _isLoading = true;
    _successVN.value = true;

    compressFile(
      file: File(path),
    ).then((file) {
      return uploadFile(path: file.path);
    }).then((value) {
      final url = value;
      if (url == null || url.isEmpty) {
        _successVN.value = false;
        throw "上传失败 ${widget.model.assetFile?.path}";
      }
      _successVN.value = true;
      widget.model.url = url;
    }).catchError((err) {
      debugPrint("err: $err");
      widget.model.url = "";
      _successVN.value = false;
    }).whenComplete(() {
      _isLoading = false;

      // LogUtil.d("${fileName}_whenComplete");
      widget.urlBlock?.call(widget.model.url ?? "");
    });
  }

  /// 压缩文件
  Future<File> compressFile({required File file}) async {
    final ext = file.path.split(".").last;
    if (NFileType.video.exts.contains(ext)) {
      return VideoService.compressVideo(file, showToast: false);
    }
    if (NFileType.image.exts.contains(ext)) {
      return ImageService().compressAndGetFile(file, needLogInfo: false);
    }
    return file;
  }

  Widget buildFileSizeInfo({required int? length}) {
    if (length == null) {
      return const SizedBox();
    }
    final result = length / (1024 * 1024);
    final desc = "${result.toStringAsFixed(2)}MB";
    return Align(child: Text(desc));
  }

  @override
  bool get wantKeepAlive => true;
}
