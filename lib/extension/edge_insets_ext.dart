//
//  EdgeInsetsExt.dart
//  flutter_templet_project
//
//  Created by shang on 1/13/23 6:32 PM.
//  Copyright © 1/13/23 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';

extension EdgeInsetsExt on EdgeInsets{

  /// 合并阴影 BoxShadow
  EdgeInsets mergeShadow({BoxShadow? shadow}) {
    if (shadow == null) {
      return this;
    }

    final shadowRadius = shadow.spreadRadius + shadow.blurRadius;
    final marginNew = EdgeInsets.only(
      top: this.top + shadowRadius - shadow.offset.dy,
      bottom: this.bottom + shadowRadius + shadow.offset.dy,
      right: this.right + shadowRadius + shadow.offset.dx,
      left: this.left + shadowRadius - shadow.offset.dx,
    );
    return marginNew;
  }
}