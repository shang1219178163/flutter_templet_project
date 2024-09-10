//
//  FileExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/16 11:50.
//  Copyright © 2024/1/16 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// app 文件类型
enum NFileType {
  unknown("未知", []),
  image("图片", ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic']),
  video("视频", ["mp4", "avi", "wmv", "rmvb", "mpg", "mpeg", "mov", "3gp"]),
  audio("音频", ["mp3", "wav", "wma", "amr", "ogg"]),
  document('文档', ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'pdf']),
  doc("word文档", ["doc", "docx"]),
  excel("excel文档", ["xls", "xlsx"]),
  ppt("ppt文档", ["ppt", "pptx"]),
  pdf("ppt文档", ["pdf"]);

  const NFileType(this.message, this.exts);

  /// 描述
  final String message;

  /// 类型
  final List<String> exts;
}

extension FileExt on File {
  /// assets 路径转 File
  static Future<File> fromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final fileName = path.split("/").last;

    final tempPath = (await getTemporaryDirectory()).path;

    final file = File('$tempPath/$fileName');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    ));
    return file;
  }

  /// 获取文件类型
  NFileType get fileType => path.fileType;

  /// length 转为 MB 描述
  String get fileSizeDesc {
    final length = lengthSync();
    return length.fileSizeDesc;
  }

  /// 压缩质量
  int get compressQuality {
    final length = lengthSync();
    return length.compressQuality;
  }
}

extension FileIntExt on int {
  /// length 转为 MB 描述
  String get fileSizeDesc {
    int length = this;

    final kb = length / 1024;
    final mb = kb / 1024;

    final result =
        kb > 1024 ? '${mb.toStringAsFixed(2)}MB' : "${kb.toStringAsFixed(0)}kb";
    return result;
  }

  /// 压缩质量
  int get compressQuality {
    int length = this;
    // var quality = 100;
    const mb = 1024 * 1024;
    if (length > 10 * mb) {
      return 20;
    }

    if (length > 8 * mb) {
      return 30;
    }

    if (length > 6 * mb) {
      return 40;
    }

    if (length > 4 * mb) {
      return 50;
    }

    if (length > 2 * mb) {
      return 60;
    }
    return 90;
  }
}

extension FileStringExt on String {
  /// 获取文件类型
  NFileType get fileType {
    if (!contains(".")) {
      return NFileType.unknown;
    }

    final ext = split('.').last.toLowerCase();
    for (final e in NFileType.values) {
      if (e.exts.contains(ext)) {
        return e;
      }
    }
    return NFileType.unknown;
  }
}
