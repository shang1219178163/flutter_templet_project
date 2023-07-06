


import 'dart:async';

import 'package:flutter/foundation.dart';
// import 'package:image/image.dart' as compress_image;
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// 压缩
mixin CompressImageMixin{
  /// 压缩图片
  FutureOr<Uint8List> toCompressImage(Uint8List bytes) async {
    return compute(_comporessUint8List, bytes);
  }

  Future<Uint8List> _comporessUint8List(Uint8List bytes) async {
    int length = bytes.lengthInBytes;
    int quality = _getQuality(length);

    var result = await FlutterImageCompress.compressWithList(
      bytes,
      minHeight: 1920,
      minWidth: 1080,
      quality: quality,
      rotate: 135,
    );
    return result;
  }

  int _getQuality(int length) {
    var quality = 100;
    const mb = 1024 * 1024;
    if (length > 10 * mb) {
      quality = 20;
    } else if (length > 8 * mb) {
      quality = 30;
    } else if (length > 6 * mb) {
      quality = 40;
    } else if (length > 4 * mb) {
      quality = 50;
    } else if (length > 2 * mb) {
      quality = 60;
    } else if (length > 1 * mb) {
      quality = 70;
    } else if (length > 0.5 * mb) {
      quality = 80;
    } else if (length > 0.25 * mb) {
      // quality = 90;
    }
    return quality;
  }
}





