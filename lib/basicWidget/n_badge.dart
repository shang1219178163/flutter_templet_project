//
//  NBadge.dart
//  yl_health_app
//
//  Created by shang on 2023/9/5 17:39.
//  Copyright © 2023/9/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 红色角标
class NBadge extends StatelessWidget {
  const NBadge({
    Key? key,
    required this.value,
    this.top = 8,
    this.letterStep = 5,
    required this.child,
  }) : super(key: key);

  /// 数值
  final int value;

  /// 顶部偏移
  final double top;

  /// 字符步长
  final double letterStep;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return child;
    }

    var badge = value;
    var badgeStr = badge > 99 ? "99+" : "$badge";
    ShapeBorder shape =
        badge > 99 ? const StadiumBorder() : const CircleBorder();
    var right = -8 - (badgeStr.length - 1) * letterStep;

    final badgeChild = buildBadge(badgeStr: badgeStr, shape: shape);
    if (badgeStr.isEmpty || badgeStr == "0") {
      return child;
    }

    return Stack(clipBehavior: Clip.none, children: <Widget>[
      child,
      Positioned(
        top: top,
        right: right,
        child: badgeChild,
      ),
    ]);
  }

  /// 红色角标
  Widget buildBadge({
    String badgeStr = "",
    EdgeInsets? padding,
    ShapeBorder shape = const CircleBorder(),
  }) {
    if (badgeStr.isEmpty || badgeStr == "0") {
      return const SizedBox();
    }

    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
      decoration: ShapeDecoration(
        color: Colors.red,
        shape: shape,
      ),
      child: Text(
        badgeStr,
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }
}
