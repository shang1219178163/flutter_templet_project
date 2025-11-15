//
//  file_manager.dart
//  flutter_templet_project
//
//  Created by shang on 7/26/21 4:23 PM.
//  Copyright © 7/26/21 shang. All rights reserved.
//

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/cache/asset_cache_service.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/image_ext.dart';
import 'package:path_provider/path_provider.dart';

/// 文件管理类
class FileManager {
  static final FileManager _instance = FileManager._();
  FileManager._();
  factory FileManager() => _instance;
  static FileManager get instance => _instance;

  ///获取缓存目录路径
  Future<Directory> getCacheDir() async {
    var directory = await getTemporaryDirectory();
    return directory;
  }

  ///获取文件缓存目录路径
  Future<Directory> getFilesDir() async {
    var directory = await getApplicationSupportDirectory();
    return directory;
  }

  ///获取文档存储目录路径
  Future<Directory> getDocumentsDir() async {
    var directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  /// 文件创建
  ///
  /// - fileName 文件名
  ///
  /// - ext 文件扩展
  ///
  /// - content 文件内容
  ///
  /// - dir 保存文件夹
  Future<File> createFile({
    required String fileName,
    String ext = "dart",
    required String content,
    Directory? dir,
    bool cover = false,
  }) async {
    // final dateStr = "${DateTime.now()}".split(".").first ?? "";

    /// 本地文件目录
    var tempDir = dir ?? await getApplicationCacheDirectory();
    if (Platform.isMacOS) {
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        tempDir = downloadsDir;
      }
    }

    final fileNameNew = fileName.contains(".") ? fileName : '$fileName.$ext';
    assert(fileNameNew.contains("."), "文件类型不能为空");

    var path = '${tempDir.path}/$fileNameNew';
    debugPrint("$runtimeType $fileNameNew: $path");
    var file = File(path);
    if (cover && file.existsSync()) {
      file.deleteSync();
    }
    file.createSync();
    file.writeAsStringSync(content);
    return file;
  }

  /// 文件读取
  ///
  /// - fileName 文件名
  ///
  /// - ext 文件扩展
  ///
  /// - content 文件内容
  ///
  /// - dir 保存文件夹
  Future<File> readFile({
    required String fileName,
    String ext = "dart",
    Directory? dir,
  }) async {
    /// 本地文件目录
    var tempDir = dir ?? await getApplicationCacheDirectory();

    final fileNameNew = fileName.contains(".") ? fileName : '$fileName.$ext';
    assert(fileNameNew.contains("."), "文件类型不能为空");

    var path = '${tempDir.path}/$fileNameNew';
    debugPrint("$runtimeType $fileNameNew: $path");
    var file = File(path);
    return file;
  }

  /// 存储 map
  ///
  /// - fileName 文件名
  ///
  /// - ext 文件类型, 默认 txt
  ///
  /// - map 要存储的字典
  Future<File> saveJson({
    required String fileName,
    String ext = "dart",
    Directory? dir,
    required Map<String, dynamic> map,
  }) async {
    final content = jsonEncode(map);
    final file = await FileManager().createFile(fileName: fileName, ext: ext, content: content, dir: dir);
    return file;
  }

  /// 读取 map
  ///
  /// - fileName 文件名
  ///
  /// - ext 文件类型, 默认 txt
  ///
  /// - dir 目标文件夹
  Future<Map<String, dynamic>?> readJson({
    required String fileName,
    String ext = "dart",
    Directory? dir,
  }) async {
    final file = await FileManager().readFile(
      fileName: fileName,
      ext: ext,
      dir: dir,
    );
    final fileExists = file.existsSync();
    if (!fileExists) {
      debugPrint("❌ $runtimeType $fileName.$ext: 文件不存在");
      return null;
    }
    final content = await file.readAsString();
    return jsonDecode(content);
  }

  /// 更新 map
  Future<File?> updateJson({
    required String fileName,
    String ext = "dart",
    Directory? dir,
    required Future<Map<String, dynamic>> Function(Map<String, dynamic> map) onUpdate,
  }) async {
    final map = await readJson(fileName: fileName, ext: ext, dir: dir);
    final mapNew = await onUpdate(map ?? {});
    final fileNew = await saveJson(fileName: fileName, map: mapNew);
    return fileNew;
  }

  /// 文件下载
  Future<File?> downloadFile({
    required String url,
    String? fileName,
    ValueChanged<double>? onProgress,
  }) async {
    assert(url.startsWith("http"), "url 必须以 http 开头");
    if (url.startsWith("http") != true) {
      return null;
    }
    fileName ??= url.split("/").last;

    var tempDir = await AssetCacheService().getDir();
    var tmpPath = '${tempDir.path}/$fileName';

    final percentVN = ValueNotifier(0.0);

    final response = await Dio().download(
      url,
      tmpPath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final percent = (received / total);
          final percentStr = "${(percent * 100).toStringAsFixed(0)}%";
          percentVN.value = percent;
          debugPrint("percentStr: $percentStr");
          onProgress?.call(percent);
        }
      },
    );
    if (response.statusCode != 200) {
      debugPrint("❌FileShare onDownload: $response");
      return null;
    }
    if (percentVN.value < 1) {
      onProgress?.call(1);
    }
    // debugPrint("response: ${response.data}");
    return File(tmpPath);
  }

  static Future<File?> getCacheFile({required String fileName, bool isTemDir = true}) async {
    try {
      // 获取应用沙盒目录（iOS/Android 都可）
      final directory = isTemDir ? (await getTemporaryDirectory()) : (await getApplicationDocumentsDirectory());
      DLog.d("directory: ${directory}");
      final path = '${directory.path}/$fileName';
      final file = File(path);
      return file;
    } catch (e) {
      DLog.d("$e");
    }
    return null;
  }

  /// 将 Uint8List 保存到沙盒，返回保存的文件路径
  static Future<File?> cacheImage({required ui.Image image, required String fileName, bool isTemDir = true}) async {
    final file = await getCacheFile(fileName: fileName, isTemDir: isTemDir);
    if (file == null) {
      return null;
    }

    final data = await image.toUint8List();
    if (data == null) {
      return null;
    }
    final fileNew = await file.writeAsBytes(data, flush: true); // flush 确保写入磁盘
    return fileNew;
  }

  /// 根据文件路径读取 Uint8List
  static Future<ui.Image?> imageFromCache({required String fileName, bool isTemDir = true}) async {
    try {
      final file = await getCacheFile(fileName: fileName, isTemDir: isTemDir);
      if (file == null || !file.existsSync()) {
        return null;
      }

      final bytes = await file.readAsBytes();
      final image = await bytes.toImage();
      return image;
    } catch (e) {
      DLog.d("$e");
    }
    return null;
  }
}
