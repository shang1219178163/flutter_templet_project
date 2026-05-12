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
    this.offset = Offset.zero,
  });

  final FloatingActionButtonLocation location;

  final Offset offset;

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    var position = location.getOffset(scaffoldGeometry);
    return position + offset;
  }
}
