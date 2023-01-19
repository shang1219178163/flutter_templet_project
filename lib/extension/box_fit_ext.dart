//
//  AlignmentExtension.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/12 20:57.
//  Copyright © 2023/1/12 shang. All rights reserved.
//
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';


extension BoxFitExt on BoxFit{
  /// BoxFit 枚举集合
  static const allCases = <BoxFit>[
    BoxFit.contain,
    BoxFit.cover,
    BoxFit.fitWidth,
    BoxFit.fitHeight,
    BoxFit.none,
    BoxFit.scaleDown,
  ];
}