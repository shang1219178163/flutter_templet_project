//
//  FadeBuilder.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/17 16:12.
//  Copyright © 2024/6/17 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 添加渐进动画
class FadeBuilder extends StatelessWidget {
  const FadeBuilder({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 150),
      builder: (_, double value, Widget? w) {
        return Opacity(
          opacity: value,
          child: w,
        );
      },
      child: child,
    );
  }
}
