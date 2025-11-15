//
//  NeumorphismButton.dart
//  flutter_templet_project
//
//  Created by shang on 1/6/23 5:02 PM.
//  Copyright © 1/6/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 拟物按钮
class NeumorphismButton extends StatelessWidget {
  NeumorphismButton({
    Key? key,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = 30,
    required this.child,
    this.onClick,
  }) : super(key: key);

  NeumorphismButton.icon({
    Key? key,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    required Widget child,
    GestureTapCallback? onClick,
  }) : this(
          key: key,
          width: width ?? 50,
          height: height ?? 50,
          padding: padding ?? const EdgeInsets.all(8),
          borderRadius: borderRadius ?? 30,
          child: child,
          onClick: onClick,
        );

  double? width;
  double? height;
  EdgeInsetsGeometry? padding;

  double borderRadius;

  Widget child;
  GestureTapCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E5EC),
          // color: Colors.green,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ).toNeumorphism(
          bottomShadowColor: const Color(0xFFA3B1C6), borderRadius: borderRadius, topShadowColor: Colors.white),
    );
  }
}
