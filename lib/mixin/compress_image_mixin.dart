import 'dart:async';

import 'package:flutter/foundation.dart';
// import 'package:image/image.dart' as compress_image;
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// 压缩
mixin CompressImageMixin {
  /// 压缩图片
  FutureOr<Uint8List> toCompressImage(Uint8List bytes) async {
    return compute(_comporessUint8List, bytes);
  }

  /// 压缩文件
  Future<XFile?> toCompressFile(
    CompressFileModel model,
  ) async {
    return compute(_comporessFile, model);
  }

  Future<Uint8List> _comporessUint8List(Uint8List bytes) async {
    var length = bytes.lengthInBytes;
    var quality = _getQuality(length);

    var result = await FlutterImageCompress.compressWithList(
      bytes,
      minHeight: 1920,
      minWidth: 1080,
      quality: quality,
      rotate: 135,
    );
    return result;
  }

  Future<XFile?> _comporessFile(
    CompressFileModel model,
  ) async {
    var quality = _getQuality(model.length);
    final result = await FlutterImageCompress.compressAndGetFile(
      model.path,
      model.targetPath,
      minWidth: 1080,
      minHeight: 1440,
      quality: quality,
      format: CompressFormat.jpeg,
    );
    return result;
  }

  int _getQuality(int length) {
    // var quality = 100;
    const mb = 1024 * 1024;
    if (length > 10 * mb) {
      return 20;
    }

    if (length > 8 * mb) {
      return 30;
    }

    if (length > 6 * mb) {
      return 40;
    }

    if (length > 4 * mb) {
      return 50;
    }

    if (length > 2 * mb) {
      return 60;
    }
    return 90;
  }
}

/// 文件压缩模型
class CompressFileModel {
  CompressFileModel(
    this.path,
    this.length,
    this.targetPath,
  );
  String path;
  int length;
  String targetPath;
}
