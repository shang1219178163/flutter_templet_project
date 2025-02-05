//
//  ImagePickerMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2025/2/5 10:21.
//  Copyright © 2025/2/5 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:flutter_templet_project/basicWidget/upload/image_service.dart';
import 'package:flutter_templet_project/basicWidget/upload/video_service.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/util/permission_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 媒体文件选择
mixin AssetPickerMixin<T extends StatefulWidget> on State<T> {
  /// 媒体文件数组
  late final List<AssetUploadModel> selectedModels = [];

  /// 媒体文件选择
  Future<void> onAssetPicker({
    int maxCount = 9,
    bool needCompress = true,
    Function(AssetUploadModel model)? onItemCompressed,
    VoidCallback? onCancel,
  }) async {
    try {
      bool isGranted = await PermissionUtil.checkPhotoAlbum();
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
              requestType: RequestType.common,
              specialPickerType: SpecialPickerType.noPreview,
              selectedAssets: selectedEntitys,
              maxAssets: maxCount,
              specialItemPosition: SpecialItemPosition.prepend,
              specialItemBuilder: (context, AssetPathEntity? path, int length) {
                if (path?.isAll != true) {
                  return null;
                }

                const textDelegate = AssetPickerTextDelegate();
                return Semantics(
                  label: textDelegate.sActionUseCameraHint,
                  button: true,
                  onTapHint: textDelegate.sActionUseCameraHint,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      DLog.d(runtimeType.toString());
                    },
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
        onCancel?.call();
        return;
      }

      for (final e in result) {
        if (!selectedEntitys.contains(e)) {
          selectedModels.add(AssetUploadModel(entity: e));
        }
      }

      if (needCompress) {
        await _compress(onItemFinished: onItemCompressed);
      }

      debugPrint("selectedEntitys:${selectedEntitys.length} ${selectedModels.length}");
    } catch (err) {
      debugPrint("err:$err");
      ToastUtil.show('$err');
    }
  }

  /// 媒体文件压缩
  Future<void> _compress({Function(AssetUploadModel model)? onItemFinished}) async {
    for (var i = 0; i < selectedModels.length; i++) {
      final model = selectedModels[i];
      model.file ??= await model.entity?.file;
      if (model.file != null) {
        final isImage = (model.entity!.type == AssetType.image);
        final fileNew = isImage
            ? await ImageService().compressAndGetFile(model.file!)
            : await VideoService.compressVideo(model.file!);
        model.file = fileNew;
        selectedModels[i] = model;
        onItemFinished?.call(model);
      }
    }
  }
}
