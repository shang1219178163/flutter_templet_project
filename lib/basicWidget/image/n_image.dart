import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/image/n_network_image.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/util/CacheImageProvider.dart';

/// 通用图片加载组件
///
/// 支持 [String]、[File]、[Uint8List]、[ImageProvider] 等多种图片来源，
/// 网络图片默认走磁盘缓存，加载中与失败时分别展示占位图与错误占位图。
class NImage extends StatelessWidget {
  const NImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder = const AssetImage(Assets.imagesIconNewsPlaceholder),
    this.errorPlaceholder = const AssetImage(Assets.imagesIconNewsPlaceholder),
    this.errorWidget,
    this.useCache = true,
    this.borderRadius,
    this.color,
    this.colorBlendMode,
    this.showLoadingProgress = false,
  });

  /// 图片来源，支持 String / File / Uint8List / ImageProvider
  final Object? source;

  final double? width;
  final double? height;
  final BoxFit fit;

  /// 加载中占位图，默认 [defaultPlaceholderAsset]
  final ImageProvider placeholder;

  /// 加载失败占位图，默认 [defaultErrorAsset]
  final ImageProvider? errorPlaceholder;

  /// 自定义错误占位组件，优先级高于 [errorPlaceholder]
  final Widget? errorWidget;

  /// 网络图片是否启用磁盘缓存
  final bool useCache;

  final BorderRadius? borderRadius;
  final Color? color;
  final BlendMode? colorBlendMode;

  /// 是否展示网络加载进度条，默认仅显示占位图
  final bool showLoadingProgress;

  @override
  Widget build(BuildContext context) {
    final imageProvider = resolveImageProvider(
      source,
      useCache: useCache,
    );
    if (imageProvider == null) {
      return buildPlaceholderWidget();
    }
    return buildImageWidget(imageProvider);
  }

  /// 将多种图片来源解析为 [ImageProvider]
  static ImageProvider? resolveImageProvider(
    Object? source, {
    bool useCache = true,
  }) {
    if (source == null) {
      return null;
    }
    if (source is ImageProvider) {
      return source;
    }
    if (source is Uint8List) {
      return MemoryImage(source);
    }
    if (source is File) {
      return FileImage(source);
    }
    if (source is String) {
      final sourceNew = source.trim();
      if (sourceNew.isEmpty) {
        return null;
      }
      if (sourceNew.startsWith('http://') || sourceNew.startsWith('https://')) {
        if (useCache) {
          return CacheImageProvider(sourceNew);
        }
        return NetworkImage(sourceNew);
      }
      if (sourceNew.startsWith('assets/')) {
        return AssetImage(sourceNew);
      }
      final localFile = File(sourceNew);
      if (localFile.existsSync()) {
        return FileImage(localFile);
      }
      return null;
    }
    debugPrint('NImage 不支持的图片来源类型: ${source.runtimeType} -> $source');
    return null;
  }

  Widget buildPlaceholderWidget() {
    return buildImageFromProvider(
      placeholder,
      isPlaceholder: true,
    );
  }

  Widget buildErrorWidget() {
    if (errorWidget != null) {
      return SizedBox(width: width, height: height, child: errorWidget);
    }
    return buildImageFromProvider(
      errorPlaceholder ?? placeholder,
      isPlaceholder: true,
    );
  }

  Widget buildImageWidget(ImageProvider imageProvider) {
    final placeholderWidget = buildPlaceholderWidget();
    final errorView = buildErrorWidget();
    Widget image = Builder(
      builder: (context) {
        final screenSize = MediaQuery.sizeOf(context);
        final dpr = MediaQuery.devicePixelRatioOf(context);
        final cacheW = NNetworkImage.cachePx(width, dpr) ?? NNetworkImage.cachePx(screenSize.width, dpr);
        final cacheH = NNetworkImage.cachePx(height, dpr);
        return Image(
          image: ResizeImage.resizeIfNeeded(cacheW, cacheH, imageProvider),
          width: width,
          height: height,
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
          errorBuilder: (_, __, ___) => errorView,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              return child;
            }
            return placeholderWidget;
          },
          loadingBuilder: buildLoadingBuilder,
        );
      },
    );
    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }
    return image;
  }

  /// 加载中：已完成返回 [child]；否则按 [showLoadingProgress] 显示进度或占位图
  Widget buildLoadingBuilder(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }
    if (!showLoadingProgress) {
      return buildPlaceholderWidget();
    }
    final expectedTotalBytes = loadingProgress.expectedTotalBytes;
    final progressValue = expectedTotalBytes == null || expectedTotalBytes == 0
        ? 0.0
        : loadingProgress.cumulativeBytesLoaded / expectedTotalBytes;
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: placeholder,
          fit: fit,
        ),
        borderRadius: borderRadius,
      ),
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(value: progressValue),
      ),
    );
  }

  Widget buildImageFromProvider(
    ImageProvider provider, {
    required bool isPlaceholder,
  }) {
    Widget image = Image(
      image: provider,
      width: width,
      height: height,
      fit: fit,
      color: isPlaceholder ? null : color,
      colorBlendMode: isPlaceholder ? null : colorBlendMode,
    );
    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }
    return image;
  }
}
