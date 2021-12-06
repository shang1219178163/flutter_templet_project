//
//  FileManager.dart
//  flutter_templet_project
//
//  Created by shang on 7/26/21 4:23 PM.
//  Copyright © 7/26/21 shang. All rights reserved.
//

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static final FileManager _instance = FileManager._();
  FileManager._();
  factory FileManager() => _instance;
  static FileManager get instance => _instance;

  ///获取缓存目录路径
  static Future<String> getCacheDirPath() async {
    Directory directory = await getTemporaryDirectory();
    return directory.path;
  }

  ///获取文件缓存目录路径
  static Future<String> getFilesDirPath() async {
    Directory directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  ///获取文档存储目录路径
  static Future<String> getDocumentsDirPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}