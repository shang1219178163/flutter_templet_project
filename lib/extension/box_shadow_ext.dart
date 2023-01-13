//
//  BoxShadowExt.dart
//  flutter_templet_project
//
//  Created by shang on 1/13/23 6:17 PM.
//  Copyright © 1/13/23 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';


extension BoxShadowExt on BoxShadow{

  /// 获取阴影 EdgeInsets
  EdgeInsets shadowMargin({required EdgeInsets margin}) {
    BoxShadow shadow = this;

    final shadowRadius = shadow.spreadRadius + shadow.blurRadius;
    margin = EdgeInsets.only(
      top: margin.top + shadowRadius - shadow.offset.dy,
      bottom: margin.bottom + shadow.blurRadius + shadow.offset.dy,
      right: margin.right + shadowRadius + shadow.offset.dx,
      left: margin.left + shadowRadius - shadow.offset.dx,
    );
    return margin;
  }
}