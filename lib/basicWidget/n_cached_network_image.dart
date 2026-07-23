import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 网络图片
class NCachedNetworkImage extends StatelessWidget {
  const NCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholderImage = const AssetImage("assets/images/img_placeholder.png"),
    this.placeholder,
    this.errorWidget,
    this.progressIndicatorBuilder,
    this.imageBuilder,
    this.width,
    this.height,
    this.radius = 0,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.useOldImageOnUrlChange = false,
    this.filterQuality = FilterQuality.low,
    this.placeholderFadeInDuration,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.httpHeaders,
    this.errorListener,
  });

  final String imageUrl;

  /// 本地占位图（原有用法）
  final AssetImage placeholderImage;

  /// Widget 占位（CachedNetworkImage 风格，可选）
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final ImageWidgetBuilder? imageBuilder;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit? fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final Duration fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final bool useOldImageOnUrlChange;
  final FilterQuality filterQuality;
  final Duration? placeholderFadeInDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final String? cacheKey;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final Map<String, String>? httpHeaders;
  final ValueChanged<Object>? errorListener;

  static ValueChanged<Object> onErrorListener = (error) {
    debugPrint('CachedNetworkImage 图片加载失败：$error');
  };

  /// 合法 http(s) 网络图 URL；非法返回 null，避免 CachedNetworkImageProvider("") 抛错
  static String? getImageUrl(String? url) {
    final value = (url ?? '').trim();
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      return null;
    }
    return value;
  }

  /// 校验链接是否无效
  static bool validUrl(String? url) => getImageUrl(url) != null;

  @override
  Widget build(BuildContext context) {
    final widthNew = resolveSize(width);
    final heightNew = resolveSize(height);
    final blendModeNew = colorBlendMode ?? BlendMode.srcIn;
    final placeholderWidget = buildPlaceholder(width: widthNew, height: heightNew);
    final url = getImageUrl(imageUrl);
    if (url == null) {
      // 原有逻辑：非法 URL 展示默认占位
      return SizedBox(
        width: widthNew,
        height: heightNew,
        child: errorWidget?.call(context, imageUrl, ArgumentError('Invalid image url')) ??
            placeholder?.call(context, imageUrl) ??
            placeholderWidget,
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      httpHeaders: httpHeaders,
      cacheKey: cacheKey ?? url,
      width: widthNew,
      height: heightNew,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      color: color,
      colorBlendMode: color == null ? colorBlendMode : blendModeNew,
      filterQuality: filterQuality,
      fadeInDuration: fadeInDuration,
      fadeInCurve: fadeInCurve,
      fadeOutDuration: fadeOutDuration,
      fadeOutCurve: fadeOutCurve,
      placeholderFadeInDuration: placeholderFadeInDuration,
      useOldImageOnUrlChange: useOldImageOnUrlChange,
      memCacheWidth: resolveMemCache(memCacheWidth) ?? resolveMemCache(widthNew, scale: 3),
      memCacheHeight: resolveMemCache(memCacheHeight) ?? resolveMemCache(heightNew, scale: 3),
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      placeholder: placeholder ?? ((_, __) => placeholderWidget),
      progressIndicatorBuilder: progressIndicatorBuilder,
      errorWidget: errorWidget ?? ((_, __, ___) => placeholderWidget),
      // 用 Image 保证固有尺寸；圆角用 ClipRRect（避免无 child DecoratedBox 宽高为 0）
      imageBuilder: imageBuilder ??
          ((context, imageProvider) {
            final image = Image(
              image: imageProvider,
              width: widthNew,
              height: heightNew,
              fit: fit,
              alignment: alignment,
              repeat: repeat,
              matchTextDirection: matchTextDirection,
              filterQuality: filterQuality,
              color: color,
              colorBlendMode: color == null ? colorBlendMode : blendModeNew,
            );
            if (radius <= 0) {
              return image;
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: image,
            );
          }),
      errorListener: errorListener ??
          ((error) {
            debugPrint('$runtimeType 图片加载失败：$error');
          }),
    );
  }

  /// 合法布局尺寸；null/NaN/<=0/infinity 均视为无效（infinity 请在调用处用 LayoutBuilder 解析）
  double? resolveSize(double? value) {
    if (value == null || !value.isFinite || value <= 0) {
      return null;
    }
    return value;
  }

  /// memCache 像素，须 > 0
  int? resolveMemCache(num? value, {int scale = 1}) {
    if (value == null) {
      return null;
    }
    final v = value.toDouble();
    if (!v.isFinite || v <= 0) {
      return null;
    }
    return v.toInt() * scale;
  }

  Widget buildPlaceholder({double? width, double? height, Widget? child}) {
    final blendModeNew = colorBlendMode ?? BlendMode.srcIn;
    final colorFilter = color == null ? null : ColorFilter.mode(color!, blendModeNew);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        image: DecorationImage(
          image: placeholderImage,
          fit: BoxFit.contain,
          colorFilter: colorFilter,
        ),
      ),
      child: child,
    );
  }
}
