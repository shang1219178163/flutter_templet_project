//
//  build_context_ext.dart
//  flutter_templet_project
//
//  Created by shang on 10/14/21 2:21 PM.
//  Copyright © 10/14/21 shang. All rights reserved.
//

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


extension BuildContextExt on BuildContext {

  /// 获取当前组件的 RenderBox
  RenderBox? get renderBox {
    var renderObj = findRenderObject();
    return renderObj is RenderBox ? renderObj : null;
  }

  /// 获取当前组件的坐标点
  Offset? origin({Offset offset = Offset.zero}) {
    return renderBox?.localToGlobal(offset); //组件坐标
  }

  /// 获取当前组件的 Size
  Size? get renderBoxSize => renderBox?.size;

  double? minX({Offset offset = Offset.zero}) {
    return origin(offset: offset)?.dx;
  }

  double? minY({Offset offset = Offset.zero}) {
    return origin(offset: offset)?.dy;
  }

  double? maxX({Offset offset = Offset.zero}) {
    if (minX(offset: offset) == null || size == null) {
      return null;
    }
    return minX(offset: offset)! + size!.width;
  }

  double? maxY({Offset offset = Offset.zero}) {
    if (minX(offset: offset) == null || size == null) {
      return null;
    }
    return minX(offset: offset)! + size!.height;
  }

  double? midX({Offset offset = Offset.zero}) {
    if (minX(offset: offset) == null || size == null) {
      return null;
    }
    return origin()!.dx + size!.width * 0.5;
  }

  double? midY({Offset offset = Offset.zero}) {
    if (minX(offset: offset) == null || size == null) {
      return null;
    }
    return origin()!.dy + size!.height * 0.5;
  }

  ///扩展方法
  void logRendBoxInfo() {
    debugPrint("${[DateTime.now(), origin(), size]}");
  }

  /// 扩展属性 Theme.of(context)
  ThemeData get theme => Theme.of(this);
  /// 扩展属性 Theme.of(context).primaryColor
  Color get primaryColor => theme.primaryColor;

  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  Color get dialogBackgroundColor => theme.dialogBackgroundColor;

  /// 扩展属性 MediaQuery.of(context)
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// 扩展属性 MediaQuery.of(this).devicePixelRatio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// 扩展属性 MediaQuery.of(context).size
  Size get screenSize => mediaQuery.size;


  /// 安全区域距离顶部高度(电池栏高度:有刘海的屏幕:47 没有刘海的屏幕为20)
  double get safeAreaTop => mediaQuery.viewPadding.top;
  /// 安全区域底部高度(有刘海的屏幕:34 没有刘海的屏幕0)
  double get safeAreaBottom => mediaQuery.viewPadding.bottom;
  /// 安全区高度(去除电池栏高度和 iphone底部34)
  double get safeAreaHeight => mediaQuery.size.height
      - mediaQuery.viewPadding.top
      - mediaQuery.viewPadding.bottom;

  /// 状态栏高度
  double get statusBarHeight => safeAreaTop;
  /// appbar 高度
  double get appBarHeight => kToolbarHeight;

  /// 视图距离底边的高度(有键盘:键盘高度 + 34, 无键盘 0)
  double get viewBottom => mediaQuery.viewInsets.bottom;

  /// 截图(组件必须是 RepaintBoundary)
  Future<ui.Image?> toImage({ double? pixelRatio }) async {
    var boundary = findRenderObject() as RenderRepaintBoundary?;
    var image = await boundary?.toImage(pixelRatio: pixelRatio ?? ui.window.devicePixelRatio);

    // ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List? pngBytes = byteData?.buffer.asUint8List() ?? Uint8List(10);
    // ui.Image img = ui.Image.memory(pngBytes);
    return image;
  }

  /// 组件截图转 ByteData (组件必须是 RepaintBoundary)
  Future<ByteData?> toImageByteData({ double? pixelRatio }) async {
    final image = await toImage(pixelRatio: pixelRatio);
    final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
    return byteData;
  }

  /// 组件截图转 Uint8List (组件必须是 RepaintBoundary)
  Future<Uint8List?> toImageUint8List({ double? pixelRatio }) async {
    final byteData = await toImageByteData(pixelRatio: pixelRatio);
    final uint8List = byteData?.buffer.asUint8List();
    return uint8List;
  }

  /// 组件截图转 Image Widget(组件必须是 RepaintBoundary)
  Future<Image?> toImageWidget({ double? pixelRatio }) async {
    final pngBytes = await toImageUint8List(pixelRatio: pixelRatio);
    if (pngBytes == null) {
      return null;
    }
    final img = Image.memory(pngBytes);
    return img;
  }
}

extension StatefulWidgetExt<T extends StatefulWidget> on State<T> {
  /// 扩展属性 Theme.of(context)
  ThemeData get theme => context.theme;

  /// 扩展属性 Theme.of(context)
  Color get primaryColor => theme.primaryColor;

  /// 扩展属性 MediaQuery.of(context)
  MediaQueryData get mediaQuery => context.mediaQuery;

  /// 安全区域距离顶部高度(电池栏高度:有刘海的屏幕:44 没有刘海的屏幕为20)
  double get safeAreaTop => context.safeAreaTop;
  /// 没有弹出键盘时底部高度(有刘海的屏幕:34 没有刘海的屏幕0)
  double get safeAreaBottom => context.safeAreaBottom;
  /// 安全区高度(去除电池栏高度和 iphone底部34)
  double get safeAreaHeight => context.safeAreaHeight;

  /// 扩展属性 MediaQuery.of(context).size
  Size get screenSize => context.screenSize;
  /// 扩展属性 MediaQuery.of(.devicePixelRatio
  double get devicePixelRatio => context.devicePixelRatio;

}


extension GlobalKeyExt on GlobalKey{

  /// 获取当前组件的 RenderBox
  RenderBox? get renderBox => currentContext?.renderBox;
  /// 获取当前组件的 position
  Offset? position({Offset offset = Offset.zero}) => currentContext?.origin(offset: offset);
  /// 获取当前组件的 Size
  Size? get size => currentContext?.size;

  double? minX({Offset offset = Offset.zero}) => currentContext?.minX(offset: offset);
  double? minY({Offset offset = Offset.zero}) => currentContext?.minY(offset: offset);
  double? midX({Offset offset = Offset.zero}) => currentContext?.midX(offset: offset);
  double? midY({Offset offset = Offset.zero}) => currentContext?.midY(offset: offset);
  double? maxX({Offset offset = Offset.zero}) => currentContext?.maxX(offset: offset);
  double? maxY({Offset offset = Offset.zero}) => currentContext?.maxY(offset: offset);

}
