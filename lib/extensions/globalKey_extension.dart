//
//  globalKey_extension.dart
//  flutter_templet_project
//
//  Created by shang on 7/29/21 2:04 PM.
//  Copyright © 7/29/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

extension GlobalKeyExt on GlobalKey{

  /// 获取当前组件的 RenderBox
  RenderBox? renderBox() {
    RenderObject? renderObj = this.currentContext?.findRenderObject();
    if (renderObj == null || renderObj is! RenderBox) {
      return null;
    }
    RenderBox renderBox = renderObj;
    return renderBox;
  }

  /// 获取当前组件的 position
  Offset? position({Offset offset = Offset.zero}) {
    if (this.renderBox() == null) {
      return null;
    }
    var point = this.renderBox()!.localToGlobal(offset); //组件坐标
    return point;
  }

  /// 获取当前组件的 Size
  Size? size() {
    if (this.renderBox() == null) {
      return null;
    }
    return this.renderBox()!.size;
  }

  // double? maxX() {
  //   if (this.position() == null || this.size() == null) {
  //     return null;
  //   }
  //   return this.position()!.dx + this.size()!.width;
  // }
  //
  // double? maxY() {
  //   if (this.position() == null || this.size() == null) {
  //     return null;
  //   }
  //   return this.position()!.dy + this.size()!.height;
  // }
  //
  // double? minX() {
  //   if (this.position() == null) {
  //     return null;
  //   }
  //   return this.position()!.dx;
  // }
  //
  // double? minY() {
  //   if (this.position() == null) {
  //     return null;
  //   }
  //   return this.position()!.dy;
  // }
  //
  // double? midX() {
  //   if (this.position() == null || this.size() == null) {
  //     return null;
  //   }
  //   return this.position()!.dx + this.size()!.width * 0.5;
  // }
  //
  // double? midY() {
  //   if (this.position() == null || this.size() == null) {
  //     return null;
  //   }
  //   return this.position()!.dy + this.size()!.height * 0.5;
  // }

}


extension SizeExt on Size{

}