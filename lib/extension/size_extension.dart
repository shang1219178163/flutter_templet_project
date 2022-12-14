//
//  SizeExtension.dart
//  三翼鸟工作台
//
//  Created by shang on 9/23/22 12:48 PM.
//
//


import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizeExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => ScreenUtil().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => ScreenUtil().setHeight(this);

  ///[ScreenUtil.setSp]
  double get sp => ScreenUtil().setSp(this);

  ///屏幕宽度的倍数
  double get sw => ScreenUtil().screenWidth * this;

  ///屏幕高度的倍数
  double get sh => ScreenUtil().screenHeight * this;
}


extension SizeExt on Size {
  /// 等比缩放大小
  Size adjustToWidth(double width) {
    final scale = width / this.width;
    final heightNew = scale * this.height;
    // print("SizeExt:${heightNew}");
    return Size(width, heightNew);
  }
  /// 等比缩放大小
  Size adjustToHeight(double height) {
    final scale = height / this.height;
    final widthNew = scale * this.width;
    // print("SizeExt:${widthNew}");
    return Size(widthNew, height);
  }
}



wrapBaseWidget

