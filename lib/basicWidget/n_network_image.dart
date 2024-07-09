//
//  NNetworkImage.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/18 16:43.
//  Copyright © 2024/5/18 shang. All rights reserved.
//

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class NNetworkImage extends StatelessWidget {
  NNetworkImage({
    super.key,
    this.title,
    required this.url,
    this.placeholder = const AssetImage("assets/images/img_placehorder.png"),
    this.fit = BoxFit.fill,
    this.width,
    this.height,
    this.radius = 8,
    this.cache = true,
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

  final ExtendedImageMode mode;

  @override
  Widget build(BuildContext context) {
    final placeholderImage = Image(
      image: placeholder,
      width: width,
      height: height,
      fit: fit,
    );

    final isUrlError = url.startsWith("http") == false;
    if (isUrlError) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: placeholderImage,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ExtendedImage.network(
        url,
        width: width,
        height: height,
        cacheWidth: width == null ? null : (width! * 3).toInt(),
        cacheHeight: height == null ? null : (height! * 3).toInt(),
        fit: fit,
        cache: cache,
        mode: mode,
        // border: Border.all(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.circular(radius),
        //cancelToken: cancellationToken,
        loadStateChanged: (ExtendedImageState state) {
          if (state.extendedImageLoadState != LoadState.completed) {
            return placeholderImage;
          }
          // debugPrint("Image width ${state.extendedImageInfo?.image.width} height : ${state.extendedImageInfo?.image.height}");
          final image = state.extendedImageInfo?.image;
          var child = ExtendedRawImage(
            image: image,
            width: width ?? image?.width.toDouble(),
            height: height ?? image?.height.toDouble(),
            fit: fit,
            // soucreRect: Rect.fromLTWH((state.extendedImageInfo?.image?.width-200)/2,(state.extendedImageInfo?.image?.height-200)/2, 200, 200),
          );
          // debugPrint("Source Rect width ${widget.width} height : ${widget.height}");
          return child;
        },
      ),
    );
  }
}
