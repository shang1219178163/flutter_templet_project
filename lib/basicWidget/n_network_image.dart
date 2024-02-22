
import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';


class NNetworkImage extends StatelessWidget {

  NNetworkImage({
  	Key? key,
  	this.title,
    required this.url,
    this.placehorder = const AssetImage("assets/images/img_placehorder.png"),
    this.fit = BoxFit.fill,
    this.width,
    this.height,
    this.radius = 8,
    this.cache = true,
    this.mode = ExtendedImageMode.none,
  }) : super(key: key);

  final String? title;

  final String url;
  /// 占位图
  final AssetImage placehorder;

  final BoxFit? fit;

  final double? width;

  final double? height;

  final double radius;

  final bool cache;

  final ExtendedImageMode mode;


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.startsWith("http") == false ? Image(
        image: placehorder,
        width: width,
        height: height,
      ) : ExtendedImage.network(
        url,
        width: width,
        height: height,
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        fit: fit,
        cache: cache,
        mode: mode,
        // border: Border.all(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.circular(radius),
        //cancelToken: cancellationToken,
        loadStateChanged: (ExtendedImageState state) {
          if(state.extendedImageLoadState != LoadState.completed) {
            // return Icon(Icons.photo, color: Colors.teal.shade100, size: height,);
            return Image(
              image: placehorder,
              width: width,
              height: height,
            );
          }
          // debugPrint("Image width ${state.extendedImageInfo?.image.width} height : ${state.extendedImageInfo?.image.height}");
          final image = state.extendedImageInfo?.image;
          var child = ExtendedRawImage(
            image: image,
            width: width ?? image?.width.toDouble(),
            height: height ?? image?.height.toDouble(),
            fit: BoxFit.fill,
            // soucreRect: Rect.fromLTWH((state.extendedImageInfo?.image?.width-200)/2,(state.extendedImageInfo?.image?.height-200)/2, 200, 200),
          );
          // debugPrint("Source Rect width ${widget.width} height : ${widget.height}");
          return child;
        }
      ),
    );
  }
}