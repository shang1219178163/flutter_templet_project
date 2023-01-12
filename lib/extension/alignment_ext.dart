//
//  AlignmentExtension.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/12 20:57.
//  Copyright © 2023/1/12 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

extension AlignmentExt on Alignment{
  /// 九个方位变量集合
  static const List<Alignment> allCases = [
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];

}