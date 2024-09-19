//
//  NFileUploadModel.dart
//  yl_health_app
//
//  Created by shang on 2023/04/30 11:19.
//  Copyright © 2023/04/30 shang. All rights reserved.
//

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// 文件
class NFileUploadModel {
  NFileUploadModel({
    this.url,
    this.assetFile,
  });

  /// 上传之后的文件 url
  String? url;

  /// 本地选择的文件实体
  NPickFile? assetFile;

  /// 文件名称(带类型)
  String? get fileName {
    final fileName = assetFile?.name ?? url?.split("/").last;
    return fileName;
  }

  /// 文件尺寸描述(MB)
  String? get fileDesc {
    int? length = assetFile?.size;
    if (length == null) {
      return null;
    }
    final result = length / (1024 * 1024);
    final desc = "${result.toStringAsFixed(2)}MB";
    return desc;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['url'] = url;
    data['file'] = assetFile?.toJson();
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

/// 文件上传选择实体
class NPickFile {
  NPickFile({
    required this.path,
    required this.name,
    required this.size,
    this.identifier,
  });

  final String path;
  final String name;
  final int size;
  final String? identifier;

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['path'] = path;
    data['name'] = name;
    data['size'] = size;
    data['identifier'] = identifier;
    return data;
  }

  static NPickFile fromPlatformFile(PlatformFile file) {
    return NPickFile(
      path: file.path ?? "",
      name: file.name,
      size: file.size,
      identifier: file.identifier,
    );
  }
}
