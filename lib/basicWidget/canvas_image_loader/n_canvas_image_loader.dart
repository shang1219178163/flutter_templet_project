import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NCanvasImageLoader {
  /// 加载网图
  static Future<ui.Image?> load(
    String? url, {
    required AssetImage placeholder,
    ImageConfiguration configuration = const ImageConfiguration(),
  }) async {
    final placeholderImage = _loadImage(placeholder, configuration: configuration);
    try {
      if (url == null || url.startsWith("http") != true) {
        return placeholderImage;
      }

      final provider = CachedNetworkImageProvider(url);
      final image = await _loadImage(provider, configuration: configuration);
      return image;
    } catch (e) {
      return placeholderImage;
    }
  }

  static Future<ui.Image> _loadImage(
    ImageProvider provider, {
    ImageConfiguration configuration = const ImageConfiguration(),
    ValueChanged<double>? onProgress,
  }) async {
    final completer = Completer<ui.Image>();

    final stream = provider.resolve(configuration);

    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo info, _) {
        completer.complete(info.image);
        stream.removeListener(listener);
      },
      onChunk: (event) {
        if (event.expectedTotalBytes == null) {
          return;
        }
        final progress = event.cumulativeBytesLoaded / event.expectedTotalBytes!.clamp(0.0, 1.0);
        onProgress?.call(progress);
      },
      onError: (e, _) {
        completer.completeError(e);
        stream.removeListener(listener);
      },
    );

    stream.addListener(listener);
    return completer.future;
  }
}
