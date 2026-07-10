import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// 网络图片
class NCachedNetworkImage extends StatelessWidget {
  const NCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholder = const AssetImage("assets/images/img_placeholder.png"),
    required this.width,
    required this.height,
    this.radius = 0,
    this.fit = BoxFit.cover,
    this.color,
    this.colorBlendMode,
  });

  final String imageUrl;
  final AssetImage placeholder;
  final double? width;
  final double? height;
  final double? radius;
  final BoxFit? fit;
  final Color? color;
  final BlendMode? colorBlendMode;

  static ValueChanged<Object> onErrorListener = (error) {
    debugPrint('CachedNetworkImage 图片加载失败：$error');
  };

  @override
  Widget build(BuildContext context) {
    final blendModeNew = colorBlendMode ?? BlendMode.srcIn;
    final placeholderWidget = buildPlaceholder();

    if (!imageUrl.startsWith("http")) {
      return placeholderWidget;
    }

    return CachedNetworkImage(
      cacheKey: imageUrl,
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: (width?.toInt() ?? 0) * 3,
      memCacheHeight: (height?.toInt() ?? 0) * 3,
      color: color,
      colorBlendMode: blendModeNew,
      placeholder: (_, url) => placeholderWidget,
      errorWidget: (_, url, e) => placeholderWidget,
      // progressIndicatorBuilder: (context, url, progress) {
      //   // return CircularProgressIndicator(value: progress.progress);
      //   return buildPlaceholder(
      //     child: CircularProgressIndicator(value: progress.progress),
      //   );
      // },
      imageBuilder: (context, imageProvider) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 0),
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        );
      },
      errorListener: (error) {
        debugPrint('$runtimeType 图片加载失败：$error');
      },
    );
  }

  Widget buildPlaceholder({Widget? child}) {
    final blendModeNew = colorBlendMode ?? BlendMode.srcIn;
    final colorFilter = color == null ? null : ColorFilter.mode(color!, blendModeNew);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 0),
        image: DecorationImage(
          image: placeholder,
          fit: BoxFit.contain,
          colorFilter: colorFilter,
        ),
      ),
      child: child,
    );
  }
}
