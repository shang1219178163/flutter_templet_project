//
//  CreateFileMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/9 10:39.
//  Copyright © 2024/8/9 shang. All rights reserved.
//

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 创建文件并保存
mixin CreateFileMixin<T extends StatefulWidget> on State<T> {
  /// 创建文件并保存到下载目录
  Future<bool> onCreateFile({
    required String name,
    required String content,
  }) async {
    if (name.isEmpty) {
      return false;
    }
    final file = await FileManager.instance.createFile(
      fileName: name,
      content: content,
      cover: true,
    );
    final isExist = file.existsSync();
    final message = isExist ? "文件已生成(下载文件夹)" : "文件创建失败";
    final bgColor = isExist ? Colors.green : Colors.red;
    showSnackBar(SnackBar(
      content: NText(
        message,
        color: Colors.white,
        textAlign: TextAlign.center,
      ),
      backgroundColor: bgColor,
    ));
    if (isExist) {
      await _openFolder(file: file);
      return true;
    }
    return false;
  }

  Future<bool> _openFolder({required File file}) async {
    if (!Platform.isMacOS) {
      return false;
    }
    var path = file.path;
    if (Platform.isMacOS) {
      path = 'file:///Users/shang/Downloads';
    }
    final uri = Uri.parse(path);
    if (await canLaunchUrl(uri)) {
      final result = await launchUrl(uri);
      return result;
    } else {
      throw 'Could not launch $uri';
    }
    return false;
  }
}
