//
//  NPopupContainer.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/23 17:02.
//  Copyright © 2026/4/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// 弹窗自适应内容组件
class NPopupAdaptiveContainer extends StatelessWidget {
  const NPopupAdaptiveContainer({
    super.key,
    this.topControl,
    this.topControlColor,
    this.isScrollControlled = true,
    this.maxHeight = 500,
    this.minHeight = 200,
    this.heightFactor,
    this.raius = 15,
    required this.child,
  });

  final Widget child;

  final Widget? topControl;
  final Color? topControlColor;
  final bool isScrollControlled;
  final double maxHeight;
  final double minHeight;
  final double? heightFactor;
  final double raius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xff181829) : Colors.white;
    final barrierColor = isDark ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.1);
    // final borderColor = isDark ? Colors.black : Colors.white;

    final titleColor = AppColor.fontColor;
    final subtitleColor = AppColor.fontColor333333;

    final topControlColorDefault = (isDark ? const Color(0xFFEEEEEE) : const Color(0xFFFFFFFF)).withOpacity(0.3);

    var content = child;
    if (isScrollControlled) {
      content = Scrollbar(
        child: SingleChildScrollView(
          child: Material(
            color: backgroundColor,
            child: content,
          ),
        ),
      );
    }
    if (heightFactor != null) {
      content = FractionallySizedBox(
        heightFactor: heightFactor,
        child: content,
      );
    } else {
      content = ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          minHeight: minHeight,
        ),
        child: content,
      );
    }

    if (topControlColor == Colors.transparent) {
      return content;
    }

    return Stack(
      children: [
        content,
        Positioned(
          top: 8,
          left: 0,
          right: 0,
          child: Center(
            child: topControl ??
                Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    color: topControlColor ?? topControlColorDefault,
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
