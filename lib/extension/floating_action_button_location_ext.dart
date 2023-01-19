//
//  FloatingActionButtonLocationExt.dart
//  flutter_templet_project
//
//  Created by shang on 1/19/23 1:14 PM.
//  Copyright © 1/19/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';

extension FloatingActionButtonLocationExt on FloatingActionButtonLocation{
  /// 枚举集合
  static const allCases = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.endTop,
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.endDocked,
  ];
}