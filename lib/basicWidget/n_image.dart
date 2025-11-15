import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';

class NImage extends StatelessWidget {
  const NImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder = const AssetImage("assets/images/img_placeholder.png"),
  });

  final dynamic source; // 这个是传入的图片来源，可以是 String、Uint8List 或 File
  final double? width;
  final double? height;
  final BoxFit fit;
  final AssetImage placeholder;

  @override
  Widget build(BuildContext context) {
    final placeholderImage = Image(
      image: placeholder,
      width: width,
      height: height,
      fit: fit,
    );

    errorBuilder(_, stack, error) {
      return const Icon(Icons.error);
    }

    switch (source.runtimeType) {
      case String:
        {
          final sourceNew = source as String;
          if (sourceNew.startsWith('http')) {
            return NNetworkImage(
              url: sourceNew,
              width: width,
              height: height,
              fit: fit,
            );
          }

          if (sourceNew.startsWith('assets/')) {
            return Image.asset(
              sourceNew,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: errorBuilder,
            );
          }

          final file = File(sourceNew);
          if (file.existsSync()) {
            return Image.file(
              file,
              width: width,
              height: height,
              cacheWidth: width == null ? null : width!.toInt() * 3,
              cacheHeight: height == null ? null : height!.toInt() * 3,
              fit: fit,
              errorBuilder: errorBuilder,
            );
          }
        }
        break;
      case Uint8List:
        {
          return Image.memory(
            source,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: errorBuilder,
          );
        }
        break;
      default:
        debugPrint('$this unknown type: ${source.runtimeType}: $source');
    }
    return placeholderImage ?? const SizedBox.shrink();
  }
}
