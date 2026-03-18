//
//  AssetResourceMixin.dart
//  AssetResourceMixin
//
//  Created by shang on 2024/6/12 11:12.
//  Copyright © 2024/6/12 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// 本地文本文件读取
mixin AssetsJsonMixin<T extends StatefulWidget> on State<T> {
  /// 本地文本文件路径
  String get assetsLoadPath => throw UnimplementedError("❌$this AssetsJsonMixin 未实现 assetsLoadPath");

  // 添加一个新属性
  String _assetsContent = "";

  /// assetsLoadPath 对应的解析内容
  String get assetsContent => _assetsContent;
  set assetsContent(String value) {
    _assetsContent = value;
  }

  /// 本地资源加载结束回调
  void Function()? onAssetResourceFinished;

  @override
  void initState() {
    super.initState();

    readAssetsJsonString().then((v) {
      setState(() {});
    });
  }

  Future<String> readAssetsJsonString() async {
    var content = "";
    try {
      final response = await rootBundle.loadString(assetsLoadPath);
      content = response;
    } catch (exception) {
      debugPrint("$this $exception");
      content = "";
    } finally {
      _assetsContent = content;
      // DLog.d([content.length]);
    }
    return content;
  }
}
