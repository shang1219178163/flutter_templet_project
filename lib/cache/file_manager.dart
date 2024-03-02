//
//  file_manager.dart
//  flutter_templet_project
//
//  Created by shang on 7/26/21 4:23 PM.
//  Copyright © 7/26/21 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static final FileManager _instance = FileManager._();
  FileManager._();
  factory FileManager() => _instance;
  static FileManager get instance => _instance;

  ///获取缓存目录路径
  static Future<String> getCacheDirPath() async {
    var directory = await getTemporaryDirectory();
    return directory.path;
  }

  ///获取文件缓存目录路径
  static Future<String> getFilesDirPath() async {
    var directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  ///获取文档存储目录路径
  static Future<String> getDocumentsDirPath() async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 创建文件
  /// fileName - 文件名
  /// content - 文件内容
  /// dir - 保存文件夹
  Future<File> createFile({String? fileName, required String content, Directory? dir}) async {
    fileName ??= "未命名_${DateTime.now().toString().substring(0, 10).replaceAll("-", "_")}";

    /// 生成本地文件
    var tempDir = dir ?? await getDownloadsDirectory();
    if (Platform.isIOS) {
      tempDir = dir ?? await getTemporaryDirectory();
    }
    var path = '${tempDir?.path}/$fileName.dart';
    // debugPrint("file: $path");
    var file = File(path);
    file.createSync();
    file.writeAsStringSync(content);
    return file;
  }
}