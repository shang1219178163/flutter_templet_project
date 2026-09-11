//
//  NIndicator.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/23 10:36.
//  Copyright © 2026/4/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 页码指示器
class NPageIndicator extends StatelessWidget {
  const NPageIndicator({
    super.key,
    required this.length,
    required this.listenable,
    this.padding = const EdgeInsets.symmetric(horizontal: 100, vertical: 34),
    required this.builder,
  });

  /// 总数
  final int length;

  /// 索引监听
  final ValueNotifier<int> listenable;
  final EdgeInsetsGeometry padding;

  final Widget Function(bool isActive) builder;

  @override
  Widget build(BuildContext context) {
    if (length <= 1) {
      return SizedBox();
    }

    return ValueListenableBuilder<int>(
      valueListenable: listenable,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
            length,
            (index) {
              final isActive = (index == value);
              return builder(isActive);
            },
          ),
        );
      },
    );
  }
}
