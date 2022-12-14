//
//  SizeExtension.dart
//  三翼鸟工作台
//
//  Created by shang on 9/23/22 12:48 PM.
//
//


import 'dart:ui';

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

