//
//  NFileUploadItemProtocol.dart
//  projects
//
//  Created by shang on 2024/9/13 14:50.
//  Copyright © 2024/9/13 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_Item.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_handle.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_model.dart';
import 'package:flutter_templet_project/extension/src/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// 文件上传样式示例
class NFileUploadPI extends NFileUploadHandle {
  /// 子项
  @override
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
      builder: (NFileUploadModel model, VoidCallback? onDelete, VoidCallback? onRefresh, ValueNotifier<bool> successVN,
          ValueNotifier<double> percentVN) {
        final validUrl = model.url?.startsWith("http") == true;

        var name = model.fileName ?? "--";
        var fileDesc = model.fileDesc;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([
                successVN,
                percentVN,
              ]),
              child: Row(
                children: [
                  Expanded(child: NText(name)),
                  if (canEdit && onDelete != null)
                    GestureDetector(
                      onTap: onDelete,
                      child: Icon(Icons.delete, color: AppColor.cancelColor),
                    ),
                ],
              ),
              builder: (context, name) {
                // YLog.d("buildUploading ${fileName}: ${_percentVN.value}");
                final percent = percentVN.value;
                // if (percent >= 1) {
                //   return const SizedBox();
                // }

                final showPercent = model.assetFile != null && (model.assetFile!.size > 2 * 1024 * 1024) == true;

                final desc = showPercent ? percent.toStringAsPercent(2) : "上传中";

                final indicatorColor = percent < 1 ? AppColor.primary.withOpacity(0.5) : Colors.transparent;

                // return Padding(
                //   padding: const EdgeInsets.only(bottom: 8.0),
                //   child: Stack(
                //     children: [
                //       AnimatedOpacity(
                //         opacity: value < 1 ? 1 : 0,
                //         duration: Duration.zero,
                //         child: LinearProgressIndicator(
                //           value: percentVN.value,
                //           minHeight: 20,
                //           color: primary.withOpacity(0.35),
                //           backgroundColor: Colors.transparent,
                //         ),
                //       ),
                //       Positioned.fill(
                //         child: Row(
                //           children: [
                //             Expanded(child: NText(data: name)),
                //             GestureDetector(
                //               onTap: onDelete,
                //               child: Icon(Icons.delete_forever,
                //                   color: cancelColor),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // );

                final show = percent < 1 && !validUrl;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    name ?? const SizedBox(),
                    ValueListenableBuilder(
                      valueListenable: successVN,
                      builder: (context, value, child) {
                        if (value) {
                          return const SizedBox();
                        }
                        return GestureDetector(
                          onTap: onRefresh,
                          child: const NText(
                            "重试",
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                    Offstage(
                      offstage: !show,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: NText(
                              fileDesc ?? "",
                              fontSize: 12,
                            ),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percentVN.value,
                              minHeight: 2,
                              color: indicatorColor,
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
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        );
      },
    );
  }

  // @override
  // void onTapItem(NFileUploadModel model) {
  //   super.onTapItem(model);
  // }

  /// 发起选择按钮
  @override
  Widget buildUploadButton({required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          color: AppColor.primary.withOpacity(0.1),
          border: Border.all(color: AppColor.primary),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: NPair(
          icon: Image(
            image: "icon_upload_one.png".toAssetImage(),
            width: 16,
            height: 16,
            color: AppColor.primary,
          ),
          child: NText(
            "选择文件并上传",
            fontSize: 14,
            color: AppColor.primary,
          ),
        ),
      ),
    );
  }
}
