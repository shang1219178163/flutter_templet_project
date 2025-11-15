//
//  YamlExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/15 12:09.
//  Copyright © 2024/9/15 shang. All rights reserved.
//

import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

extension YamlMapExt on YamlMap {
  /// 字符串转
  static Future<dynamic> fromString({required String content}) async {
    final yamlMap = loadYaml(content);
    var result = yamlMap;
    if (yamlMap is YamlMap) {
      result = yamlMap.toMap();
    }
    return result;
  }

  /// 解析
  static Future<dynamic> parseYaml({required String path}) async {
    // 读取 pubspec.yaml 文件
    final file = File(path);
    if (!file.existsSync()) {
      DLog.d('❌文件未找到: $path');
      return null;
    }

    final content = await file.readAsString();
    final result = await fromString(content: content);
    return result;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    nodes.forEach((k, v) {
      map[(k as YamlScalar).value.toString()] = _convertNode(v.value);
    });
    return map;
  }

  dynamic _convertNode(dynamic v) {
    if (v is YamlMap) {
      return v.toMap();
    } else if (v is YamlList) {
      var list = v.map((e) => _convertNode(e)).toList();
      return list;
    }
    return v;
  }
}
