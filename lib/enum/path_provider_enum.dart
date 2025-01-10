//
//  PathProviderEnum.dart
//  projects
//
//  Created by shang on 2025/1/7 10:10.
//  Copyright © 2025/1/7 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

/// path_provider
// enum PathProviderEnum {
//   temporaryDirectory(
//     name: "temporaryDirectory",
//     func: getTemporaryDirectory,
//     desc: "临时目录,系统可以随时清空的缓存文件夹",
//   ),
//   applicationSupportDirectory(
//     name: "applicationSupportDirectory",
//     func: getApplicationSupportDirectory,
//     desc: "应用程序支持目录,用于不想向用户公开的文件，也就是你不想给用户看到的文件可放置在该目录中，系统不会清除该目录，只有在删除应用时才会消失。",
//   ),
//   libraryDirectory(
//     name: "libraryDirectory",
//     func: getLibraryDirectory,
//     desc: "应用程序持久文件目录,主要存储持久文件的目录，并且不会对用户公开，常用于存储数据库文件，比如sqlite.db等。",
//   ),
//   applicationDocumentsDirectory(
//     name: "applicationDocumentsDirectory",
//     func: getApplicationDocumentsDirectory,
//     desc: "文档目录,用于存储只能由该应用访问的文件，系统不会清除该目录，只有在删除应用时才会消失。",
//   ),
//   applicationCacheDirectory(
//     name: "applicationCacheDirectory",
//     desc: "应用程序可以在其中放置特定于应用程序的目录的路径 cache 文件。如果此目录不存在，则会自动创建该目录。",
//     func: getApplicationCacheDirectory,
//   ),
//   externalStorageDirectory(
//     name: "externalStorageDirectory",
//     desc: "外部存储目录, 应用程序可以访问顶级存储的目录的路径。",
//     func: getExternalStorageDirectory,
//   ),
//   externalCacheDirectories(
//     name: "externalCacheDirectories",
//     desc: "外部存储缓存目录",
//     func: getExternalCacheDirectories,
//   ),
//   externalStorageDirectories(
//     name: "externalStorageDirectories",
//     desc: "可根据类型获取外部存储目录，如SD卡、单独分区等，和外部存储目录不同在于他是获取一个目录数组。但iOS不支持外部存储目录，目前只有Android才支持。",
//     func: getExternalStorageDirectories,
//   ),
//   downloadsDirectory(
//     name: "downloadsDirectory",
//     desc: "桌面程序下载目录,主要用于存储下载文件的目录，只适用于Linux、MacOS、Windows，Android和iOS平台无法使用。",
//     func: getDownloadsDirectory,
//   );
//
//   const PathProviderEnum({
//     required this.name,
//     required this.func,
//     required this.desc,
//   });
//
//   final String name;
//   final Function func;
//   final String desc;
// }

class PathProviderDirectory {
  static PathProviderDirectory get temporaryDirectory => PathProviderDirectory(
        name: "temporaryDirectory",
        func: getTemporaryDirectory,
        desc: "临时目录,系统可以随时清空的缓存文件夹",
      );

  static PathProviderDirectory get applicationSupportDirectory => PathProviderDirectory(
        name: "applicationSupportDirectory",
        func: getApplicationSupportDirectory,
        desc: "应用程序支持目录,用于不想向用户公开的文件，也就是你不想给用户看到的文件可放置在该目录中，系统不会清除该目录，只有在删除应用时才会消失。",
      );

  static PathProviderDirectory get libraryDirectory => PathProviderDirectory(
        name: "libraryDirectory",
        func: getLibraryDirectory,
        desc: "应用程序持久文件目录,主要存储持久文件的目录，并且不会对用户公开，常用于存储数据库文件，比如sqlite.db等。",
      );

  static PathProviderDirectory get applicationDocumentsDirectory => PathProviderDirectory(
        name: "applicationDocumentsDirectory",
        func: getApplicationDocumentsDirectory,
        desc: "文档目录,用于存储只能由该应用访问的文件，系统不会清除该目录，只有在删除应用时才会消失。",
      );

  static PathProviderDirectory get applicationCacheDirectory => PathProviderDirectory(
        name: "applicationCacheDirectory",
        desc: "应用程序可以在其中放置特定于应用程序的目录的路径 cache 文件。如果此目录不存在，则会自动创建该目录。",
        func: getApplicationCacheDirectory,
      );

  static PathProviderDirectory get externalStorageDirectory => PathProviderDirectory(
        name: "externalStorageDirectory",
        desc: "外部存储目录, 应用程序可以访问顶级存储的目录的路径。",
        func: getExternalStorageDirectory,
      );

  static PathProviderDirectory get externalCacheDirectories => PathProviderDirectory(
        name: "externalCacheDirectories",
        desc: "外部存储缓存目录",
        func: getExternalCacheDirectories,
      );

  static PathProviderDirectory get externalStorageDirectories => PathProviderDirectory(
        name: "externalStorageDirectories",
        desc: "可根据类型获取外部存储目录，如SD卡、单独分区等，和外部存储目录不同在于他是获取一个目录数组。但iOS不支持外部存储目录，目前只有Android才支持。",
        func: getExternalStorageDirectories,
      );

  static PathProviderDirectory get downloadsDirectory => PathProviderDirectory(
        name: "downloadsDirectory",
        desc: "桌面程序下载目录,主要用于存储下载文件的目录，只适用于Linux、MacOS、Windows，Android和iOS平台无法使用。",
        func: getDownloadsDirectory,
      );

  static List<PathProviderDirectory> get values => [
        temporaryDirectory,
        applicationSupportDirectory,
        libraryDirectory,
        applicationDocumentsDirectory,
        applicationCacheDirectory,
        externalStorageDirectory,
        externalCacheDirectories,
        externalStorageDirectories,
        downloadsDirectory,
      ];

  PathProviderDirectory({
    required this.name,
    required this.func,
    required this.desc,
    this.custom,
  });

  final String name;
  final Function func;
  final String desc;

  /// 自定义
  Map<String, dynamic>? custom;

  /// 初始化目录路径
  static Future<List<PathProviderDirectory>> initail() async {
    var list = <PathProviderDirectory>[];
    for (final e in PathProviderDirectory.values) {
      e.custom ??= {};
      try {
        final result = await e.func();
        e.custom?["dir"] = result;
      } catch (exception) {
        debugPrint("获取目录失败 $exception");
        e.custom?["exception"] = exception.toString();
        continue;
      } finally {
        list.add(e);
      }
    }
    // debugPrint("list: ${list.length}");
    return list;
  }
}
