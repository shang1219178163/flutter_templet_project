//
//  ConvertProtocol.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/9 09:33.
//  Copyright © 2024/8/9 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/cupertino.dart';

/// 文件转换协议
abstract class ConvertProtocol {
  /// 名称
  String get name {
    return runtimeType.toString();
  }

  /// 提示信息
  String get message {
    return "";
  }

  String createCopyRights({
    required String productName,
    required String className,
  }) {
    final now = DateTime.now();
    final nowStr = "$now".substring(0, 19);
    final yearStr = nowStr.substring(0, 10);
    return """
//
//  $className.dart
//  $productName
//
//  Created by shang on $nowStr.
//  Copyright © $yearStr shang. All rights reserved.
//
""";
  }

  /// 示例模板
  String exampleTemplet() {
    throw UnimplementedError("❌$this 未实现 exampleTemplet");
  }

  /// 文件转模型
  Future<ConvertModel?> convertFile({
    required String productName,
    required File file,
  }) async {
    try {
      final name = file.path.split("/").last;
      final content = await file.readAsString();
      return convert(productName: productName, content: content, name: name);
    } catch (e) {
      debugPrint("$this $e");
    }
    return null;
  }

  /// 转换 文件名和文件内容的元祖
  Future<ConvertModel?> convert({
    required String productName,
    String? name,
    required String content,
  }) async {
    throw UnimplementedError("❌$this 未实现 convert");
  }
}

/// ConvertProtocol 对应的 模型类
class ConvertModel {
  ConvertModel({
    required this.productName,
    required this.name,
    required this.content,
    this.nameNew,
    this.contentNew,
  });

  /// 项目名称
  String productName;

  /// 文件名
  String name;

  /// 文件内容
  String content;

  /// 新文件名
  String? nameNew;

  /// 新文件内容
  String? contentNew;

  static ConvertModel? fromJson(Map<String, dynamic> json) {
    return ConvertModel(
      productName: json['productName'],
      name: json['name'],
      content: json['content'],
      nameNew: json['nameNew'],
      contentNew: json['contentNew'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['productName'] = productName;
    data['name'] = name;
    data['content'] = content;
    data['nameNew'] = nameNew;
    data['contentNew'] = contentNew;
    return data;
  }
}
