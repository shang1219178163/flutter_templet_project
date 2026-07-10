//
//  AssetPickerMixin.dart
//  projects
//
//  Created by shang on 2026/7/3 18:53.
//  Copyright © 2026/7/3 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_model.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 图片选择器
class AssetPickerManager {
  /// 从相册选择图片，不依赖 AssetUploadBoxController
  static Future<List<AssetUploadModel>> pickAssets({
    required BuildContext context,
    required List<AssetUploadModel> currentModels,
    int maxCount = 8,
    bool canTakePhoto = true,
    VoidCallback? onTakePhoto,
  }) async {
    try {
      final selectedEntities = currentModels.map((model) => model.entity).whereType<AssetEntity>().toList();
      final result = await AssetPicker.pickAssets(
            context,
            pickerConfig: AssetPickerConfig(
              requestType: RequestType.image,
              specialPickerType: SpecialPickerType.noPreview,
              selectedAssets: selectedEntities,
              maxAssets: maxCount,
              specialItemPosition: SpecialItemPosition.prepend,
              specialItemBuilder: (context, AssetPathEntity? path, int length) {
                if (path?.isAll != true) {
                  return null;
                }
                if (!canTakePhoto) {
                  return null;
                }

                const textDelegate = AssetPickerTextDelegate();
                return Semantics(
                  label: textDelegate.sActionUseCameraHint,
                  button: true,
                  onTapHint: textDelegate.sActionUseCameraHint,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTakePhoto,
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
          <AssetEntity>[];
      if (result.isEmpty) {
        return currentModels;
      }
      final oldIds = selectedEntities.map((entity) => entity.id).join(',');
      final newIds = result.map((entity) => entity.id).join(',');
      if (oldIds == newIds) {
        return currentModels;
      }
      return result.map((entity) {
        for (final model in currentModels) {
          if (model.entity?.id == entity.id) {
            return model;
          }
        }
        return AssetUploadModel(entity: entity);
      }).toList();
    } catch (err) {
      DLog.d(['pickAssets error', err]);
      ToastUtil.show('请检查相册/相机可用权限');
      return currentModels;
    }
  }
}
