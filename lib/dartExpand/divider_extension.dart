//
//  DividerExtension.dart
//  fluttertemplet
//
//  Created by shang on 10/22/21 1:57 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

extension DividerExt on Divider {
  /// 扩展方法
  static Divider custome({bool isDark = false}) {
    return Divider(
      height: .5,
      indent: 15,
      endIndent: 15,
      color: Color(0xFFDDDDDD),
    );
  }
}