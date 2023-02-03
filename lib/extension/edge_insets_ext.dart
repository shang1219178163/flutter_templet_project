//
//  EdgeInsetsExt.dart
//  flutter_templet_project
//
//  Created by shang on 1/13/23 6:32 PM.
//  Copyright © 1/13/23 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';

extension EdgeInsetsExt on EdgeInsets{

  /// 负值转 0
  EdgeInsets get positive {
    return EdgeInsets.only(
      top: this.top >= 0 ? this.top : 0,
      right: this.right >= 0 ? this.right : 0,
      bottom: this.bottom >= 0 ? this.bottom : 0,
      left: this.left >= 0 ? this.left : 0,
    );
  }

  /// 根据函数转化
  EdgeInsets change(double Function(double value) cb) {
    return EdgeInsets.only(
      top: cb(this.top),
      right: cb(this.right),
      bottom: cb(this.bottom),
      left: cb(this.left),
    );
  }

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