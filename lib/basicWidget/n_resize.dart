//
//  n_resize.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/28 14:16.
//  Copyright © 2024/3/28 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';


class NResize extends StatelessWidget {

  NResize({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.none,
    this.child,
  });

  final double? width;

  final double? height;

  final BoxFit fit;

  final AlignmentGeometry alignment;

  final Clip clipBehavior;
  /// 自定义 Switch
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: fit,
        alignment: alignment,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }

}