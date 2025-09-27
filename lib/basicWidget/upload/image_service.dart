import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_templet_project/cache/asset_cache_service.dart';
import 'package:flutter_templet_project/extension/file_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

/// 图片处理工具类
class ImageService {
  /// 图片压缩
  Future<File> compressAndGetFile(File file, {String? targetPath, bool needLogInfo = true}) async {
    try {
      var fileName = file.absolute.path.split('/').last;

      // Directory tempDir = await getTemporaryDirectory();
      // Directory assetDir = Directory('${tempDir.path}/asset');
      // if (!assetDir.existsSync()) {
      //   assetDir.createSync();
      //   debugPrint('assetDir 文件保存路径为 ${assetDir.path}');
      // }

      Directory? assetDir = await AssetCacheService().getDir();
      var tmpPath = '${assetDir.path}/$fileName';
      targetPath ??= tmpPath;
      // debugPrint('fileName_${fileName}');
      // debugPrint('assetDir_${assetDir}');
      // debugPrint('targetPath_${targetPath}');
      final filePath = file.absolute.path;
      if (filePath == targetPath) {
        final fileNameItems = fileName.split(".");
        final fileNameNew = "${fileNameItems.first}_1.${fileNameItems.last}";
        targetPath = '${assetDir.path}/$fileNameNew';
      }

      var format = CompressFormat.jpeg;
      if (filePath.toLowerCase().endsWith(".jpeg")) {
        format = CompressFormat.jpeg;
      } else if (filePath.toLowerCase().endsWith(".png")) {
        format = CompressFormat.png;
      } else if (filePath.toLowerCase().endsWith(".heic")) {
        format = CompressFormat.heic;
      } else if (filePath.toLowerCase().endsWith(".webp")) {
        format = CompressFormat.webp;
      } else {
        return file;
      }

      final compressQuality = file.lengthSync().compressQuality;
      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: compressQuality,
        format: format,
      );
      final path = result?.path;
      if (result == null || path == null || path.isEmpty) {
        debugPrint("压缩文件路径获取失败");
        return file;
      }

      final length = await result.length();
      if (needLogInfo) {
        final infos = [
          "图片名称: $fileName",
          "压缩前: ${file.lengthSync().fileSizeDesc}",
          "压缩质量: $compressQuality",
          "压缩后: ${length.fileSizeDesc}",
          "原路径: ${file.absolute.path}",
          "压缩路径: $targetPath",
        ];
        debugPrint("图片压缩: ${infos.join("\n")}");
      }

      if (length == 0) {
        return file;
      }
      return File(path);
    } catch (e) {
      debugPrint("compressAndGetFile:${e.toString()}");
    }
    return file;
  }

  /// 图像裁剪
  Future<File?> toCropImage(
    File file, {
    int? maxWidth,
    int? maxHeight,
    bool showLoading = true,
  }) async {
    final sourcePath = file.path;

    if (showLoading) {
      ToastUtil.loading("图片处理中...");
    }

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
          toolbarWidgetColor: white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (showLoading) {
      ToastUtil.hideLoading();
    }

    if (croppedFile == null) {
      return null;
    }
    return File(croppedFile.path);
  }

  /// 保存到相册
  Future<bool> saveImage({
    required String url,
    bool showToast = true,
  }) async {
    final percentVN = ValueNotifier(0.0);

    ToastUtil.loading(
      "文件下载中",
      indicator: ValueListenableBuilder<double>(
        valueListenable: percentVN,
        builder: (context, value, child) {
          return CircularProgressIndicator(
            value: value,
          );
        },
      ),
    );

    String? name;
    try {
      name = url.split("?").first.split("/").last;
    } catch (e) {
      debugPrint("saveVideo name: ${e.toString()}");
      name = "tmp.png";
    }

    var cacheDir = await AssetCacheService().getDir();
    var savePath = "${cacheDir.path}/$name";
    await Dio().download(url, savePath, onReceiveProgress: (received, total) {
      if (total != -1) {
        final percent = (received / total);
        final percentStr = "${(percent * 100).toStringAsFixed(0)}%";
        percentVN.value = percent;
        // debugPrint("percentStr: $percentStr");
      }
    });
    // debugPrint("savePath: ${savePath}");
    ToastUtil.hideLoading();

    final result = await ImageGallerySaver.saveFile(savePath);
    debugPrint("saveFile: $result $url");
    final isSuccess = result["isSuccess"];
    final message = isSuccess ? "已保存到相册" : "操作失败";
    if (isSuccess && showToast) {
      ToastUtil.show(
        message,
      );
    }
    return isSuccess;
  }
}

/// 图片文件扩展方法
extension ImageFileExt on File {
  /// 图片压缩
  Future<File> toCompressImage() async {
    var compressFile = await ImageService().compressAndGetFile(this);
    return compressFile;
  }

  /// 图片裁剪
  Future<File?> toCropImage({
    int? maxWidth,
    int? maxHeight,
    bool showLoading = true,
  }) async {
    var compressFile = await ImageService().toCropImage(
      this,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      showLoading: showLoading,
    );
    return compressFile;
  }
}
