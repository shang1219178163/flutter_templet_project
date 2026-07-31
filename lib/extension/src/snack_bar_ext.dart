//
//  SnackBarExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:17.
//  Copyright © 2023/8/29 shang. All rights reserved.
//

import 'package:flutter/material.dart';

extension SnackBarExt on SnackBar {
  /// 显示 SnackBar。
  static void show(
    BuildContext context, {
    required String message,
    TextStyle? style,
    Duration duration = const Duration(milliseconds: 1500),
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: style),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
  }
}
