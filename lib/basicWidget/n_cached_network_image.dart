import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

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
    this.fit = BoxFit.cover,
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
    final blendModeNew = colorBlendMode ?? BlendMode.srcIn;
    final colorFilter = color == null ? null : ColorFilter.mode(color!, blendModeNew);
    final placeholderWidget = buildPlaceholder(colorFilter: colorFilter);
    final url = getImageUrl(imageUrl);
    if (url == null) {
      // 原有逻辑：非法 URL 展示默认占位
      return SizedBox(
        width: finiteSize(width),
        height: finiteSize(height),
        child: errorWidget?.call(context, imageUrl, ArgumentError('Invalid image url')) ??
            placeholder?.call(context, imageUrl) ??
            placeholderWidget,
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      httpHeaders: httpHeaders,
      cacheKey: cacheKey ?? url,
      width: finiteSize(width),
      height: finiteSize(height),
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
      memCacheWidth: finiteSize(memCacheWidth?.toDouble())?.toInt() ?? resolveMemCacheSize(width),
      memCacheHeight: finiteSize(memCacheHeight?.toDouble())?.toInt() ?? resolveMemCacheSize(height),
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      placeholder: placeholder ?? ((_, __) => placeholderWidget),
      progressIndicatorBuilder: progressIndicatorBuilder,
      errorWidget: errorWidget ?? ((_, __, ___) => placeholderWidget),
      // 用 Image 而非无 child 的 DecoratedBox：Image 有固有宽高，在 Html 无限高约束下也能 layout
      imageBuilder: imageBuilder ??
          ((context, imageProvider) {
            final image = Image(
              image: imageProvider,
              width: finiteSize(width),
              height: finiteSize(height),
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
      errorListener: (error) {
        debugPrint('$runtimeType 图片加载失败：$error');
      },
    );
  }

  /// 过滤 infinity/NaN，避免在 unbounded 约束里撑爆 layout
  double? finiteSize(double? value) {
    if (value == null || !value.isFinite || value < 0) {
      return null;
    }
    return value;
  }

  /// memCache 尺寸须 > 0，否则会触发 dart:ui painting 断言
  int? resolveMemCacheSize(double? value, {int scale = 3}) {
    final val = finiteSize(value);
    if (val == null) {
      return null;
    }
    return val.toInt() * scale;
  }

  Widget buildPlaceholder({required ColorFilter? colorFilter, Widget? child}) {
    return Container(
      width: finiteSize(width),
      height: finiteSize(height),
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
