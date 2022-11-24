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
  RenderBox? get renderBox {
    RenderObject? renderObj = this.currentContext?.findRenderObject();
    return renderObj is RenderBox ? renderObj : null;
  }

  /// 获取当前组件的 position
  Offset? position({Offset offset = Offset.zero}) {
    return this.renderBox?.localToGlobal(offset); //组件坐标
  }

  /// 获取当前组件的 Size
  Size? get size => this.renderBox?.size;

  double? minX({Offset offset = Offset.zero}) {
    return this.position(offset: offset)?.dx;
  }

  double? minY({Offset offset = Offset.zero}) {
    return this.position(offset: offset)?.dy;
  }

  double? maxX({Offset offset = Offset.zero}) {
    if (this.minX(offset: offset) == null || this.size == null) {
      return null;
    }
    return this.minX(offset: offset)! + this.size!.width;
  }

  double? maxY({Offset offset = Offset.zero}) {
    if (this.minX(offset: offset) == null || this.size == null) {
      return null;
    }
    return this.minX(offset: offset)! + this.size!.height;
  }

  double? midX({Offset offset = Offset.zero}) {
    if (this.minX(offset: offset) == null || this.size == null) {
      return null;
    }
    return this.position()!.dx + this.size!.width * 0.5;
  }

  double? midY({Offset offset = Offset.zero}) {
    if (this.minX(offset: offset) == null || this.size == null) {
      return null;
    }
    return this.position()!.dy + this.size!.height * 0.5;
  }

}