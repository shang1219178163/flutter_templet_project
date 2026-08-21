//
//  NIndicator.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/23 10:36.
//  Copyright © 2026/4/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 指示器
class NIndicator extends StatelessWidget {
  const NIndicator({
    super.key,
    required this.length,
    required this.indexListenable,
    this.radius = 4,
    this.spacing = 8,
    this.color,
    this.colorActive,
  });

  /// 总数
  final int length;

  /// 索引监听
  final ValueNotifier<int> indexListenable;
  final double radius;
  final double spacing;
  final Color? color;
  final Color? colorActive;

  @override
  Widget build(BuildContext context) {
    if (length <= 1) {
      return SizedBox();
    }

    final pointColor = color ?? Color(0xffDDDDDD);
    final pointColorActive = colorActive ?? Color(0xff7C7C7C);

    return ValueListenableBuilder<int>(
      valueListenable: indexListenable,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
            length,
            (index) {
              final bgColor = index == value ? pointColorActive : pointColor;
              return Padding(
                padding: EdgeInsets.only(right: spacing),
                child: CircleAvatar(
                  radius: radius,
                  backgroundColor: bgColor,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
