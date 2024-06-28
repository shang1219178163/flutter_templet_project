//
//  file_manager.dart
//  flutter_templet_project
//
//  Created by shang on 7/26/21 4:23 PM.
//  Copyright © 7/26/21 shang. All rights reserved.
//

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static final FileManager _instance = FileManager._();
  FileManager._();
  factory FileManager() => _instance;
  static FileManager get instance => _instance;

  ///获取缓存目录路径
  Future<String> getCacheDirPath() async {
    var directory = await getTemporaryDirectory();
    return directory.path;
  }

  ///获取文件缓存目录路径
  Future<String> getFilesDirPath() async {
    var directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  ///获取文档存储目录路径
  Future<String> getDocumentsDirPath() async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
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
  }) async {
    // final dateStr = "${DateTime.now()}".split(".").first ?? "";

    /// 本地文件目录
    Directory tempDir = dir ?? await getApplicationCacheDirectory();
    if (Platform.isMacOS) {
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        tempDir = downloadsDir;
      }
    }

    final fileNameNew = fileName.contains(".") ? fileName : '$fileName.$ext';
    assert(fileNameNew.contains("."), "文件类型不能为空");

    var path = '${tempDir.path}/$fileNameNew';
    debugPrint("$this $fileNameNew: $path");
    var file = File(path);
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
    debugPrint("$this $fileNameNew: $path");
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
    final file = await FileManager().createFile(
      fileName: fileName,
      ext: ext,
      content: content,
    );
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
      debugPrint("❌ $this $fileName.$ext: 文件不存在");
      return null;
    }
    final content = await file.readAsString();
    return jsonDecode(content);
  }
}
