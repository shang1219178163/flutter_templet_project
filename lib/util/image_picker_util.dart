import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// ImagePicker 功能封装类
class ImagePickerUtil {
  static final _picker = ImagePicker();

  /// 获取图片 File
  static Future<File?> pickImageFile({source = ImageSource.camera}) async {
    try {
      final imageFile = await _picker.pickImage(source: source);
      if (imageFile == null) {
        return null;
      }
      return File(imageFile.path);
    } catch (e) {
      DLog.d("$e");
    }
    return null;
  }

  /// 获取 图片实体 AssetEntity
  static Future<AssetEntity?> pickImageEntity({source = ImageSource.camera}) async {
    try {
      final imageFile = await pickImageFile(source: source);
      if (imageFile == null) {
        return null;
      }

      final imageEntity = await PhotoManager.editor.saveImageWithPath(
        imageFile.path,
        title: 'image_${DateTime.now().millisecond}',
      );
      return imageEntity;
    } catch (e) {
      DLog.d("$e");
    }
    return null;
  }
}
