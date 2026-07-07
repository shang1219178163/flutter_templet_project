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

  @override
  Widget build(BuildContext context) {
    // final placeholderWidget = Image(
    //   image: placeholder,
    //   fit: fit,
    //   width: width,
    //   height: height,
    //   color: color,
    //   colorBlendMode: colorBlendMode,
    // );

    final blendModeNew = colorBlendMode ?? BlendMode.srcIn;
    final colorFilter = color == null ? null : ColorFilter.mode(color!, blendModeNew);
    final placeholderWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 0),
        image: DecorationImage(
          image: placeholder,
          fit: fit,
          colorFilter: colorFilter,
        ),
      ),
    );

    return CachedNetworkImage(
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
    );
  }
}
