//
//  ImageExtension.dart
//  flutter_templet_project
//
//  Created by shang on 9/15/22 7:02 PM.
//  Copyright © 9/15/22 shang. All rights reserved.
//


import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/painting.dart';

extension ImageExt on Image {
  /// 获取 Image 的 pngBytes(Uint8List)
  // Future<Uint8List?> pngBytes({ImageByteFormat format = ImageByteFormat.png}) async {
  //   try {
  //     ByteData? byteData = await this.toByteData(format: format);
  //     Uint8List? pngBytes = byteData?.buffer.asUint8List();
  //     return Future.value(pngBytes);
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }

  /// 获取文件在内存中的大小
  Future<String> fileSize({ImageByteFormat format = ImageByteFormat.png}) async {
    try {
      ByteData? byteData = await this.toByteData(format: format);
      final bytes = byteData?.buffer.lengthInBytes ?? 0;
      if (bytes == 0) {
        throw Exception("获取文件字节失败");
      }

      final kb = bytes / 1024;
      final mb = kb / 1024;

      final result = kb > 1024 ? mb.toStringAsFixed(2) + 'MB' : kb.toStringAsFixed(0) + "kb";
      // print("imageSize: ${result}");
      return Future.value(result);
    } catch (e) {
      return Future.error(e);
    }
  }
}

extension ImageChunkEventExt on ImageChunkEvent {

  /// 百分比进度
  double get progress {
    if (this.expectedTotalBytes == null) {
      return 0.0;
    }
    double percent = this.cumulativeBytesLoaded/(this.expectedTotalBytes ?? 0);
    return percent;
  }

}