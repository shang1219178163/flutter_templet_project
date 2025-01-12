//
//  AssetResourceMixin.dart
//  AssetResourceMixin
//
//  Created by shang on 2024/6/12 11:12.
//  Copyright © 2024/6/12 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// 本地文件读取
mixin AssetResourceMixin<T extends StatefulWidget> on State<T> {
  /// 本地文件
  List<AssetResourceModel> assetFileModels = [
    AssetResourceModel(
      path: 'assets/data/kuan_rong.txt',
    )
  ];

  @override
  void initState() {
    super.initState();

    _initData();
  }

  _initData() async {
    for (var i = 0; i < assetFileModels.length; i++) {
      final e = assetFileModels[i];
      try {
        final response = await rootBundle.loadString(e.path);
        assetFileModels[i].content = response;
      } catch (exception) {
        debugPrint("$this $exception");
        assetFileModels[i].exception = exception.toString();
      }
    }
  }
}

/// 本地文件路径
class AssetResourceModel {
  /// 文件路径
  String path = "";

  /// 文件内容
  String? content;

  /// 异常
  String? exception;

  AssetResourceModel({required this.path, this.content, this.exception});

  AssetResourceModel.fromJson(Map<String, dynamic> json) {
    path = json['path'] ?? "";
    content = json['content'];
    exception = json['exception'];
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['path'] = path;
    data['content'] = content;
    data['exception'] = exception;
    return data;
  }
}

// mixin AssetResourceMixin<T extends StatefulWidget> on State<T> {
//   /// 宽容序曲
//   var assetFileContent = "";
//
//   String get assetFilePath => 'assets/data/kuan_rong.txt';
//
//   @override
//   void initState() {
//     super.initState();
//
//     _initData();
//   }
//
//   _initData() async {
//     assetFileContent = await _loadData();
//   }
//
//   Future<String> _loadData() async {
//     final response = await rootBundle.loadString(assetFilePath);
//     return response;
//   }
// }
