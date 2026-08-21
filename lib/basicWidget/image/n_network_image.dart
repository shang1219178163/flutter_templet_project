//
//  NNetworkImage.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/18 16:43.
//  Copyright © 2024/5/18 shang. All rights reserved.
//

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/generated/assets.dart';

class NNetworkImage extends StatelessWidget {
  const NNetworkImage({
    super.key,
    this.title,
    required this.url,
    this.placeholder = const AssetImage(Assets.imagesImgPlaceholder),
    this.fit = BoxFit.fill,
    this.width,
    this.height,
    this.radius = 8,
    this.cache = true,
    this.clearMemoryCacheWhenDispose = true,
    this.mode = ExtendedImageMode.none,
  });

  final String? title;

  final String url;

  /// 占位图
  final AssetImage placeholder;

  final BoxFit? fit;

  final double? width;

  final double? height;

  final double radius;

  final bool cache;

  /// 组件销毁时清理该图的内存缓存，降低列表滚动堆积
  final bool clearMemoryCacheWhenDispose;

  final ExtendedImageMode mode;

  static const int maxCachePx = 1024;

  @override
  Widget build(BuildContext context) {
    final isUrlError = !url.startsWith('http');
    if (isUrlError) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: buildPlaceholder(),
      );
    }

    // 已明确宽高时不必再依赖约束
    if (width != null && height != null) {
      return buildNetworkImage(context, width!, height!);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.sizeOf(context);
        final w = width ?? finiteOrNull(constraints.maxWidth);
        final h = height ?? finiteOrNull(constraints.maxHeight);
        // 无有效约束时用屏宽兜底，避免原图解码
        final fallbackW = w ?? screenSize.width;
        return buildNetworkImage(context, fallbackW, h);
      },
    );
  }

  Widget buildNetworkImage(BuildContext context, double? logicalWidth, double? logicalHeight) {
    final screenSize = MediaQuery.sizeOf(context);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    // 只约束宽度，保留比例，避免宽高同时指定导致异常放大解码
    final cacheWidth = cachePx(logicalWidth, dpr) ?? cachePx(screenSize.width, dpr);
    final requestUrl = resolveRequestUrl(url, cacheWidth);
    final borderRadius = BorderRadius.circular(radius);

    return ClipRRect(
      borderRadius: borderRadius,
      child: ExtendedImage.network(
        requestUrl,
        key: ValueKey(requestUrl),
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        fit: fit,
        cache: cache,
        mode: mode,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        clearMemoryCacheIfFailed: true,
        borderRadius: borderRadius,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.completed:
              return null;
            case LoadState.loading:
            case LoadState.failed:
              return buildPlaceholder();
          }
        },
      ),
    );
  }

  Widget buildPlaceholder() {
    return Image(
      image: placeholder,
      width: width,
      height: height,
      fit: fit,
    );
  }

  /// 阿里云 OSS 走服务端缩略，减少下载体积与解码峰值
  static String resolveRequestUrl(String url, int? cacheWidth) {
    if (cacheWidth == null || cacheWidth <= 0) {
      return url;
    }
    if (!url.contains('.aliyuncs.com')) {
      return url;
    }
    if (url.contains('x-oss-process=')) {
      return url;
    }
    final sep = url.contains('?') ? '&' : '?';
    return '$url${sep}x-oss-process=image/resize,w_$cacheWidth';
  }

  static double? finiteOrNull(double value) {
    if (value.isFinite && value > 0) {
      return value;
    }
    return null;
  }

  /// 按设备像素比计算解码像素，限制上限避免极端约束撑爆内存
  static int? cachePx(double? logicalPx, double devicePixelRatio) {
    if (logicalPx == null || logicalPx <= 0) {
      return null;
    }
    final px = (logicalPx * devicePixelRatio).round();
    if (px <= 0) {
      return null;
    }
    return px.clamp(1, maxCachePx);
  }
}
