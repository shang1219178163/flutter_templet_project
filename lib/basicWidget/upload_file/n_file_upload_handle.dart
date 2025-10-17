//
//  NFileUploadItemProtocol.dart
//  projects
//
//  Created by shang on 2024/9/13 14:50.
//  Copyright © 2024/9/13 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_Item.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_model.dart';
import 'package:flutter_templet_project/extension/file_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:flutter_templet_project/util/app_color.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

/// 文件上传基类
class NFileUploadHandle {
  const NFileUploadHandle();

  /// 子项展示
  NFileUploadItem buildItem({
    double? itemWidth,
    double? itemHeight,
    required NFileUploadModel e,
    required ValueChanged<String> urlBlock,
    required VoidCallback deleteItem,
    required bool canEdit,
    required bool showFileSize,
  }) {
    return NFileUploadItem(
      model: e,
      canEdit: canEdit,
      urlBlock: urlBlock,
      onDelete: canEdit == false ? null : deleteItem,
      showFileSize: showFileSize,
    );
  }

  /// 子项点击
  void onTapItem(NFileUploadModel model) {
    if (model.url?.startsWith("http") == true) {
      final fileName = model.url?.split("/").last;
      switch (model.url!.fileType) {
        case NFileType.image:
          {
            ToolUtil.imagePreview([model.url!], 0);
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

  /// 发起选择按钮
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
          child: const NText(
            "选择文件并上传",
            fontSize: 14,
            color: AppColor.fontColor5D6D7E,
          ),
        ),
      ),
    );
  }
}
