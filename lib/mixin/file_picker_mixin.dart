//
//  FilePickerMixin.dart
//  yl_health_app_副本
//
//  Created by shang on 2023/10/26 15:03.
//  Copyright © 2023/10/26 shang. All rights reserved.
//

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/permission_util.dart';

/// (文档)文件选择
mixin FilePickerMixin<T extends StatefulWidget> on State<T> {
  /// 选择(文档)文件
  Future<List<File>> onPickerFiles({
    int maxMB = 28,
    bool allowMultiple = true,
  }) async {
    bool isGranted = await PermissionUtil.checkDocument();
    if (!isGranted) {
      return <File>[];
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: allowMultiple,
      allowedExtensions: [
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'pdf',
      ],
    );
    if (result == null) {
      return <File>[];
    }
    List<File> files = result.paths
        .where((e) => e != null)
        .whereType<String>()
        .map((path) => File(path))
        .toList();
    return files;
  }
}
