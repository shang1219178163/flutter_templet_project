import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NCanvasImageLoader {
  static Future<ui.Image?> load(
    String? url, {
    required AssetImage placeholder,
  }) async {
    try {
      if (url == null || url.startsWith("http") != true) {
        return _loadImage(placeholder);
      }

      final provider = CachedNetworkImageProvider(url);
      final image = await _loadImage(provider);
      return image;
    } catch (e) {
      return _loadImage(placeholder);
    }
  }

  static Future<ui.Image> _loadImage(ImageProvider provider) async {
    final completer = Completer<ui.Image>();

    final stream = provider.resolve(const ImageConfiguration());

    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo info, _) {
        completer.complete(info.image);
        stream.removeListener(listener);
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
