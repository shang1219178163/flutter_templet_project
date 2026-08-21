//
//  NBottonProgressIndicator.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/1 11:37.
//  Copyright © 2024/8/1 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 线条进度指示器
class NLineProgressIndicator extends StatelessWidget {
  const NLineProgressIndicator({
    super.key,
    required this.progress,
    this.color,
    this.backgroundColor = Colors.transparent,
    this.minHeight = 3,
  });

  /// 进度
  final ValueNotifier<double> progress;

  /// 前景色
  final Color? color;

  /// 背景色
  final Color? backgroundColor;

  /// 指示器高度
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: progress,
      builder: (context, value, child) {
        final indicatorColor = value >= 1.0
            ? Colors.transparent
            : color ?? Theme.of(context).primaryColor;

        return LinearProgressIndicator(
          value: value,
          color: indicatorColor,
          backgroundColor: backgroundColor,
          minHeight: minHeight,
        );
      },
    );
  }
}
