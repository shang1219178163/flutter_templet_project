import 'package:flutter/services.dart';

extension AssetBundleExt on AssetBundle {
  static Future<bool> checkAssetExists(String assetPath) async {
    try {
      // 尝试加载资源文件
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      // 如果加载失败，则文件不存在
      return false;
    }
  }
}
