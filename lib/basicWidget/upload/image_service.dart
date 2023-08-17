import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_templet_project/cache/cache_asset_service.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';



/// 图片处理工具类
class ImageService{

  /// 图片压缩
   Future<File?> compressAndGetFile(File file, [String? targetPath]) async {
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

      final compressQuality = file.lengthSync().compressQuality;

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: compressQuality,
        rotate: 0,
      );
      final path = result?.path;
      if (result == null || path == null || path.isEmpty) {
        debugPrint("压缩文件路径获取失败");
        return file;
      }
      final lenth = await result.length();

      final infos = [
        "图片名称: $fileName",
        "压缩前: ${file.lengthSync().fileSize}",
        "压缩质量: $compressQuality",
        "压缩后: ${lenth.fileSize}",
        "原路径: ${file.absolute.path}",
        "压缩路径: $targetPath",
      ];
      debugPrint("图片压缩: ${infos.join("\n")}");

      return File(path);
    } catch (e) {
      debugPrint("compressAndGetFile:${e.toString()}");
    }
    return null;
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