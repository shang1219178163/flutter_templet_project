//
//  FloatingActionButtonLocationOffset.dart
//  flutter_templet_project
//
//  Created by shang on 2023/9/7 17:55.
//  Copyright © 2023/9/7 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 基于 FloatingActionButtonLocation 进行偏移
class FloatingActionButtonLocationOffset extends FloatingActionButtonLocation {
  FloatingActionButtonLocationOffset({
    required this.location,
    this.offsetX = 0,
    this.offsetY = 0,
  });

  FloatingActionButtonLocation location;

  double offsetX;

  double offsetY;

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    var offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
