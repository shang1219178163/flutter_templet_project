//
//  SizeExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:16.
//  Copyright © 2023/8/29 shang. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/painting.dart';

extension SizeExt on Size {
  /// 等比缩放大小
  Size toWidth(double width) {
    final scale = width / this.width;
    final heightNew = scale * height;
    // print("SizeExt:${heightNew}");
    return Size(width, heightNew);
  }

  /// 等比缩放大小
  Size toHeight(double height) {
    final scale = height / this.height;
    final widthNew = scale * width;
    // print("SizeExt:${widthNew}");
    return Size(widthNew, height);
  }
}
