//
//  PhotoPickerMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/31 12:14.
//  Copyright © 2024/7/31 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

mixin PhotoPickerMixin<T extends StatefulWidget> on State<T> {
  Future<List<AssetEntity>?> onPicker({
    int maxCount = 1,
    List<AssetEntity> selectedEntitys = const [],
    bool canTakePhoto = true,
  }) async {
    try {
      final result = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          requestType: RequestType.image,
          specialPickerType: SpecialPickerType.noPreview,
          selectedAssets: selectedEntitys,
          maxAssets: maxCount,
          // specialItemPosition: SpecialItemPosition.prepend,
          // specialItemBuilder: (context, AssetPathEntity? path, int length) {
          //   if (path?.isAll != true) {
          //     return null;
          //   }
          //
          //   if (canTakePhoto) {
          //     return null;
          //   }
          //
          //   const textDelegate = AssetPickerTextDelegate();
          //   return Semantics(
          //     label: textDelegate.sActionUseCameraHint,
          //     button: true,
          //     onTapHint: textDelegate.sActionUseCameraHint,
          //     child: GestureDetector(
          //       behavior: HitTestBehavior.opaque,
          //       onTap: takePhotoByWechatCamera,
          //       child: Container(
          //         padding: const EdgeInsets.all(28.0),
          //         color: Theme.of(context).dividerColor,
          //         child: const FittedBox(
          //           fit: BoxFit.fill,
          //           child: Icon(Icons.camera_enhance),
          //         ),
          //       ),
          //     ),
          //   );
          // },
        ),
      );

      return result;
    } catch (err) {
      debugPrint("$this err:$err");
    }
    return null;
  }

  /// 微信风格相机
  Future<AssetEntity?> takePhotoByWechatCamera() async {
    try {
      Feedback.forTap(context);
      final takePhoto = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: const CameraPickerConfig(
          enableRecording: true,
        ),
      );
      return takePhoto;
    } catch (e) {
      debugPrint("$this $e");
    }
    return null;
  }
}
