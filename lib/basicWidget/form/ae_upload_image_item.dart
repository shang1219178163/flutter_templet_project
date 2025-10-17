//
//  AeRemarkItem.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 21:17.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_box.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// AE 输入框组件
class AeUploadImageItem extends StatelessWidget {
  const AeUploadImageItem({
    super.key,
    this.enable = true,
    this.uploadBoxController,
    this.title,
    this.maxCount = 9,
    required this.selectedModels,
    required this.isUploading,
    this.onUpload,
    this.header,
    this.footer,
  });

  final AssetUploadBoxController? uploadBoxController;

  /// 选择项标题
  final String? title;

  /// 做大个数
  final int maxCount;

  /// 初始化数据
  final List<AssetUploadModel> selectedModels;

  /// 图片上传中
  final ValueNotifier<bool> isUploading;

  /// 图片结束回调
  final ValueChanged<List<AssetUploadModel>>? onUpload;

  /// 是否禁用
  final bool enable;

  /// 组件头
  final Widget? header;

  /// 组件尾
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header ?? const SizedBox(),
        if (header != null) const SizedBox(height: 5),
        buildBody(context),
        footer ?? const SizedBox(),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    var selectedModelsNew = <AssetUploadModel>[...selectedModels];

    return AssetUploadBox(
      controller: uploadBoxController,
      maxCount: maxCount,
      items: selectedModelsNew,
      spacing: 12,
      runSpacing: 8,
      canEdit: enable,
      onChanged: (items) {
        debugPrint("onChanged items.length: ${items.length}");
        selectedModelsNew = items.where((e) => e.url?.startsWith("http") == true).toList();
        final imgUrls = selectedModelsNew.map((e) => e.url ?? "").toList();
        onUpload?.call(selectedModelsNew);
        isUploading.value = false;
      },
      onStart: () {
        isUploading.value = true;
      },
    );
  }

  /// 添加
  Widget buildAdd({VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColor.bgColorF9F9F9,
          // borderRadius: BorderRadius.circular(radius),
        ),
        child: Image(
          image: 'assets/images/icon_big_plus.png'.toAssetImage(),
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
