import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_templet_project/cache/cache_asset_service.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';

import 'package:image_cropper/image_cropper.dart';


/// 图片处理工具类
class ImageService{

  /// 图片压缩
   Future<File> compressAndGetFile(File file, [String? targetPath]) async {
    try {
      var fileName = file.absolute.path.split('/').last;

      // Directory tempDir = await getTemporaryDirectory();
      // Directory assetDir = Directory('${tempDir.path}/asset');
      // if (!assetDir.existsSync()) {
      //   assetDir.createSync();
      //   debugPrint('assetDir 文件保存路径为 ${assetDir.path}');
      // }

      Directory? assetDir = await CacheAssetService().getDir();
      var tmpPath = '${assetDir.path}/$fileName';
      targetPath ??= tmpPath;
      // debugPrint('fileName_${fileName}');
      // debugPrint('assetDir_${assetDir}');
      // debugPrint('targetPath_${targetPath}');

      final filePath = file.absolute.path;

      var format = CompressFormat.jpeg;
      if (filePath.toLowerCase().endsWith(".png")) {
        format = CompressFormat.png;
      } else if (filePath.toLowerCase().endsWith(".webp")) {
        format = CompressFormat.webp;
      } else if (filePath.toLowerCase().endsWith(".heic")) {
        format = CompressFormat.heic;
      }

      final compressQuality = file.lengthSync().compressQuality;
      var result = await FlutterImageCompress.compressAndGetFile(
        filePath, targetPath,
        quality: compressQuality,
        format: format,
      );
      final path = result?.path;
      if (result == null || path == null || path.isEmpty) {
        debugPrint("压缩文件路径获取失败");
        return file;
      }
      final lenth = await result.length();

      final infos = [
        "图片名称: $fileName",
        "压缩前: ${file.lengthSync().fileSizeDesc}",
        "压缩质量: $compressQuality",
        "压缩后: ${lenth.fileSizeDesc}",
        "原路径: ${file.absolute.path}",
        "压缩路径: $targetPath",
      ];
      debugPrint("图片压缩: ${infos.join("\n")}");

      return File(path);
    } catch (e) {
      debugPrint("compressAndGetFile:${e.toString()}");
    }
    return file;
  }

  /// 图片压缩
  Future<String> compressAndGetFilePath(String imagePath, [String? targetPath,]) async {
    try {
      final file = File(imagePath);
      final fileNew = await compressAndGetFile(file, targetPath);
      final result = fileNew?.path ?? imagePath;
      return result;
    } catch (e) {
      debugPrint("compressAndGetFilePath:${e.toString()}");
    }
    return imagePath;
  }

}


/// 图片文件扩展方法
extension ImageFileExt on File {

  /// 图片压缩
  Future<File> toCompressImage() async {
    var compressFile = await ImageService().compressAndGetFile(this);
    return compressFile;
  }

  /// 图像裁剪
  Future<File> toCropImage({
    int? maxWidth,
    int? maxHeight,
  }) async {

    try {
      final sourcePath = path;

      var croppedFile = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile == null) {
        return this;
      }
      return File(croppedFile.path);
    } catch (e) {
      debugPrint("toCropImage: $e");
      return this;
    }
  }
}