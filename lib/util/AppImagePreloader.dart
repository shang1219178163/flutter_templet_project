import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/util/tool_util.dart';

/// 全局图片缓存配置mixin
mixin AppImageCacheMixin {
  /// 初始化图片缓存配置
  static void initImageCache({
    int maximumSize = 200,
    int maximumSizeBytes = 200 << 20,
  }) {
    PaintingBinding.instance.imageCache.maximumSize = maximumSize;
    PaintingBinding.instance.imageCache.maximumSizeBytes = maximumSizeBytes;
  }

  /// 清理缓存
  static Future<void> clearCache() async {
    final imageCache = PaintingBinding.instance.imageCache;
    imageCache.clear();
    imageCache.clearLiveImages();
  }
}

/// 首屏图片预加载管理器
///
/// 特性：
///
/// 1. 不阻塞首帧渲染
/// 2. 自动等待 context 可用
/// 3. 支持资源缩放解码
/// 4. 支持失败容错
/// 5. 避免重复预加载
/// 6. 支持缓存容量优化
class AppImagePreloader with AppImageCacheMixin {
  AppImagePreloader._();

  static BuildContext get context => ToolUtil.globalContext!;

  static bool initialized = false;

  /// 首屏资源,需要预加载的图片
  static const List<AppPreloadImageItem> _firstScreenImages = [];

  /// 预加载首屏图片
  ///
  /// 推荐：
  ///
  /// WidgetsBinding.instance.addPostFrameCallback((_) {
  ///   ImagePreloader.preloadFirstScreenImages();
  /// });
  static Future<void> preloadFirstScreenImages() async {
    if (initialized) {
      return;
    }
    initialized = true;
    unawaited(_precacheImages());
  }

  /// 批量预缓存
  static Future<void> _precacheImages() async {
    final futures = <Future<void>>[];
    for (final item in _firstScreenImages) {
      futures.add(_precacheSingleImage(item));
    }
    await Future.wait(futures);
  }

  /// 单图预缓存
  static Future<void> _precacheSingleImage(AppPreloadImageItem item) async {
    try {
      ImageProvider provider = AssetImage(item.asset);

      /// 减少大图解码内存
      if (item.cacheWidth != null || item.cacheHeight != null) {
        provider = ResizeImage(
          provider,
          width: item.cacheWidth,
          height: item.cacheHeight,
        );
      }

      await precacheImage(provider, context);

      debugPrint('图片预加载成功: ${item.asset}');
    } catch (e, stack) {
      debugPrint(['图片预加载失败: ${item.asset}', 'error: $e', '$stack'].join("\n"));
    }
  }
}

/// 图片预加载配置
class AppPreloadImageItem {
  const AppPreloadImageItem(
    this.asset, {
    this.cacheWidth,
    this.cacheHeight,
  });

  final String asset;

  /// 解码宽度
  final int? cacheWidth;

  /// 解码高度
  final int? cacheHeight;
}
