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
    this.fit = BoxFit.cover,
    this.color,
    this.colorBlendMode,
  });

  final String imageUrl;
  final AssetImage placeholder;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final BlendMode? colorBlendMode;

  @override
  Widget build(BuildContext context) {
    final placeholderWidget = Image(
      image: placeholder,
      fit: fit,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
    );

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      placeholder: (_, url) => placeholderWidget,
      errorWidget: (_, url, e) => placeholderWidget,
    );
  }
}
