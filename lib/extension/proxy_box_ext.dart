

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

extension RenderRepaintBoundaryExt on RenderRepaintBoundary {

  /// 保存图片
  Future<File?> saveImageToFile({required String path, ui.ImageByteFormat format: ui.ImageByteFormat.png}) async {
    ui.Image image = await this.toImage();
    ByteData? byteData = await image.toByteData(format: format);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    if (pngBytes == null) {
      return null;
    }
    return File(path).writeAsBytes(pngBytes);
  }

}