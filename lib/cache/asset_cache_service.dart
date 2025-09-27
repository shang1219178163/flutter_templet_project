import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

///缓存媒体文件
class AssetCacheService {
  AssetCacheService._();

  static final AssetCacheService _instance = AssetCacheService._();

  factory AssetCacheService() => _instance;

  Directory? _dir;

  Future<Directory> getDir() async {
    if (_dir != null) {
      return _dir!;
    }
    var tempDir = await getTemporaryDirectory();
    var targetDir = Directory('${tempDir.path}/asset');
    if (!targetDir.existsSync()) {
      targetDir.createSync();
      debugPrint('targetDir 路径为 ${targetDir.path}');
    }
    _dir = targetDir;
    return targetDir;
  }

  /// 清除缓存文件
  Future<void> clearDirCache() async {
    final dir = await getDir();
    await deleteDirectory(dir);
  }

  /// 递归方式删除目录
  Future<void> deleteDirectory(FileSystemEntity? file) async {
    if (file == null) {
      return;
    }

    if (file is Directory && file.existsSync()) {
      final children = file.listSync();
      for (final child in children) {
        await deleteDirectory(child);
      }
    }
    await file.delete();
  }

  /// 保存文件
  Future<File> saveFile({required File file, String? targetPath}) async {
    var fileName = file.absolute.path.split('/').last;

    final directory = await AssetCacheService().getDir();
    final filePath = file.absolute.path;

    var tmpPath = '${directory.path}/$fileName';
    targetPath ??= tmpPath;
    if (filePath == targetPath) {
      final fileNameItems = fileName.split(".");
      final fileNameNew = "${fileNameItems.first}_1.${fileNameItems.last}";
      targetPath = '${directory.path}/$fileNameNew';
    }

    // 从网络或资源加载图片
    final bytes = file.readAsBytesSync();

    // 将图片写入沙盒目录
    final fileNew = File(targetPath);
    await fileNew.writeAsBytes(bytes);

    debugPrint('$runtimeType 已保存到沙盒: ${fileNew.path}');
    return fileNew;
  }

  /// 保存网络图片到本地沙盒
  Future<File> saveNetworkImage({required String url, String? targetPath}) async {
    final fileName = url.split("/").last;
    // 获取应用的文档目录
    final directory = await AssetCacheService().getDir();
    final filePath = '${directory.path}/$fileName';

    // 从网络或资源加载图片
    final uri = Uri.parse(url);
    final data = await NetworkAssetBundle(uri).load(fileName);
    final bytes = data.buffer.asUint8List();

    Directory? assetDir = await AssetCacheService().getDir();
    var tmpPath = '${assetDir.path}/$fileName';
    targetPath ??= tmpPath;
    if (filePath == targetPath) {
      final fileNameItems = fileName.split(".");
      final fileNameNew = "${fileNameItems.first}_1.${fileNameItems.last}";
      targetPath = '${assetDir.path}/$fileNameNew';
    }

    // 将图片写入沙盒目录
    final fileNew = File(targetPath);
    await fileNew.writeAsBytes(bytes);
    debugPrint('$runtimeType 已保存到沙盒: ${fileNew.path}');
    return fileNew;
  }
}
