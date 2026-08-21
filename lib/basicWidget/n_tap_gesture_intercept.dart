//
//  TapGestureIntercept.dart
//  flutter_templet_project
//
//  Created by shang on 2025/9/12 21:36.
//  Copyright © 2025/9/12 shang. All rights reserved.
//

import 'package:flutter/widgets.dart';

/// 拦截被包裹部分的事件响应
class NTapGestureIntercept extends StatelessWidget {
  const NTapGestureIntercept({
    super.key,
    this.behavior = HitTestBehavior.opaque,
    this.ignoring = true,
    required this.onTap,
    required this.child,
  });

  final HitTestBehavior? behavior;

  /// Defaults to true.
  final bool ignoring;

  final VoidCallback onTap;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: ignoring ? onTap : null,
      child: IgnorePointer(
        ignoring: ignoring,
        child: child,
      ),
    );
  }
}
