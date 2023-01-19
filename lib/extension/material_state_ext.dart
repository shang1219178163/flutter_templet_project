//
//  FloatingActionButtonLocationExt.dart
//  flutter_templet_project
//
//  Created by shang on 1/19/23 1:14 PM.
//  Copyright © 1/19/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';

extension MaterialStateExt on MaterialState{
  /// 枚举集合
  static const allCases = <MaterialState>[
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
    MaterialState.dragged,
    MaterialState.selected,
    MaterialState.scrolledUnder,
    MaterialState.disabled,
    MaterialState.error,
  ];
}