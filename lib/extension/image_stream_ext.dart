//
//  ImageChunkEventExtension.dart
//  flutter_templet_project
//
//  Created by shang on 1/12/23 10:15 AM.
//  Copyright © 1/12/23 shang. All rights reserved.
//



import 'package:flutter/cupertino.dart';

extension ImageChunkEventExt on ImageChunkEvent{
  // 当前百分比进度(0 - 1)
  double? get current {
    if (this.expectedTotalBytes == null) {
      return null;
    }
    final double result = this.cumulativeBytesLoaded / this.expectedTotalBytes!;
    return result;
  }

}

