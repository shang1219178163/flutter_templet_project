//
//  EdgeInsetsExt.dart
//  flutter_templet_project
//
//  Created by shang on 1/13/23 6:32 PM.
//  Copyright © 1/13/23 shang. All rights reserved.
//


import 'dart:math';

import 'package:flutter/cupertino.dart';


extension EdgeInsetsExt on EdgeInsets{

  /// 负值转 0
  EdgeInsets get positive {
    return convert((e) => max(0, e));
    return EdgeInsets.only(
      top: top >= 0 ? top : 0,
      right: right >= 0 ? right : 0,
      bottom: bottom >= 0 ? bottom : 0,
      left: left >= 0 ? left : 0,
    );
  }

  /// 根据函数转化
  EdgeInsets convert(double Function(double value) cb) {
    return EdgeInsets.only(
      top: cb(top),
      right: cb(right),
      bottom: cb(bottom),
      left: cb(left),
    );
  }

  /// 合并阴影 BoxShadows
  EdgeInsets mergeShadows({List<BoxShadow>? shadows}) {
    if (shadows == null || shadows.isEmpty) {
      return this;
    }
    return mergeShadow(shadow: shadows[0]);
  }

  /// 合并阴影 BoxShadow
  EdgeInsets mergeShadow({BoxShadow? shadow}) {
    if (shadow == null) {
      return this;
    }

    final shadowRadius = shadow.spreadRadius + shadow.blurRadius;
    
    final topOffset = shadowRadius - shadow.offset.dy;
    final bottomOffset = shadowRadius + shadow.offset.dy;
    final rightOffset = shadowRadius + shadow.offset.dx;
    final leftOffset = shadowRadius - shadow.offset.dx;

    // final marginNew = EdgeInsets.only(
    //   top: top + topOffset,
    //   bottom: bottom + bottomOffset,
    //   right: right + rightOffset,
    //   left: left + leftOffset,
    // );

    final marginNew = EdgeInsets.only(
      top: max(top, topOffset),
      bottom: max(bottom, bottomOffset),
      right: max(right, rightOffset),
      left: max(left, leftOffset),
    );
    return marginNew;
  }
}