//
//  ProxyBoxExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/14 14:48.
//  Copyright © 2023/1/14 shang. All rights reserved.
//

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

extension RenderRepaintBoundaryExt on RenderRepaintBoundary {
  /// 保存图片
  Future<File?> saveImageToFile({
    required String path,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    var image = await toImage();
    var byteData = await image.toByteData(format: format);
    var pngBytes = byteData?.buffer.asUint8List();
    if (pngBytes == null) {
      return null;
    }
    return File(path).writeAsBytes(pngBytes);
  }
}
