//
//  BottomSheetAvatarMixin.dart
//  yl_health_app
//
//  Created by shang on 2023/9/8 11:03.
//  Copyright © 2023/9/8 shang. All rights reserved.
//


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/basicWidget/n_overlay.dart';
import 'package:flutter_templet_project/basicWidget/upload/image_service.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


/// 头像更换(回调返回单张图片的路径)
/// 默认图片压缩,图片裁剪
mixin BottomSheetAvatarMixin<T extends StatefulWidget> on State<T> {
  // 相册选择器
  final ImagePicker _picker = ImagePicker();

  // 更新头像
  updateAvatar({
    bool needCropp = true,
    Function(String? path)? cb,
  }) {
    final titles = ['拍摄', '从相册选择'];

    CupertinoActionSheet(
      actions: titles.map((e) {
        return CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            if (e == titles[0]) {
              handleImageFromCamera(needCropp: needCropp, cb: cb);
            } else {
              handleImageFromPhotoAlbum(needCropp: needCropp, cb: cb);
            }
          },
          child: Text(e),
        );
      }).toList(),
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('取消'),
      ),
    ).toShowCupertinoModalPopup(context: context);
  }

  /// 拍照获取图像
  Future<String?> handleImageFromCamera({
    bool needCropp = true,
    required Function(String? path)? cb,
  }) async {
    final file = await _takePhoto();
    if (file == null) {
      NOverlay.showToast(context, message: '请重新拍摄',);
      return null;
    }

    // EasyToast.showLoading("图片处理中...");
    NOverlay.showLoading(context, message: "图片处理中...");

    final compressImageFile = await file.toCompressImage();
    if (!needCropp) {
      // EasyToast.hideLoading();
      NOverlay.hide();
      cb?.call(compressImageFile.path);
      return compressImageFile.path;
    }

    final cropImageFile = await compressImageFile.toCropImage();
    // EasyToast.hideLoading();
    NOverlay.hide();

    cb?.call(cropImageFile.path);
    return cropImageFile.path;
  }

  /// 从相册获取图像
  Future<String?> handleImageFromPhotoAlbum({
    bool needCropp = true,
    Function(String? path)? cb,
  }) async {
    final file = await _chooseAvatarByWechatPicker();
    if (file == null) {
      NOverlay.showToast(context, message: '请重新选择',);
      return null;
    }
    // EasyToast.showLoading("图片处理中...");
    NOverlay.showLoading(context, message: "图片处理中...");

    final compressImageFile = await file.toCompressImage();
    if (!needCropp) {
      // EasyToast.hideLoading();
      NOverlay.hide();
      cb?.call(compressImageFile.path);
      return compressImageFile.path;
    }

    final cropImageFile = await compressImageFile.toCropImage();
    // EasyToast.hideLoading();
    NOverlay.hide();

    cb?.call(cropImageFile.path);
    return cropImageFile.path;
  }

  /// 拍照
  Future<File?> _takePhoto() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (file == null) {
        return null;
      }
      var fileNew = File(file.path);
      return fileNew;
    } catch (err) {
      openAppSettings();
    }
    return null;
  }

  /// 通过微信相册选择器选择头像
  Future<File?> _chooseAvatarByWechatPicker() async {
    var maxCount = 1;

    final entitys = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        requestType: RequestType.image,
        specialPickerType: SpecialPickerType.noPreview,
        selectedAssets: [],
        maxAssets: maxCount,
      ),
    ) ?? [];

    if (entitys.isEmpty) {
      return null;
    }
    final item = entitys[0];
    final file = await item.file;
    if (file == null) {
      return null;
    }
    return file;
  }

}
