//
//  ScrollControllerExtension.dart
//  flutter_templet_project
//
//  Created by shang on 12/12/22 9:16 AM.
//  Copyright © 12/12/22 shang. All rights reserved.
//


import 'dart:ui' as ui;

import 'package:flutter/material.dart';


extension ScrollControllerExt on ScrollController{

  printInfo(){
    ScrollController scrollController = this;
    this.position.printInfo();

    // print('/***********************ScrollController***********************/');
    // print('minScrollExtent: ${scrollController.position.minScrollExtent}');
    // print('maxScrollExtent: ${scrollController.position.maxScrollExtent}');
    // print('pixels: ${scrollController.position.pixels}');
    // print('viewportDimension: ${scrollController.position.viewportDimension}');
    // print('extentAfter: ${scrollController.position.extentAfter}');
    // print('extentBefore: ${scrollController.position.extentBefore}');
    // print('extentInside: ${scrollController.position.extentInside}');
  }

  /// 滚动到
  Future<void> scrollTo(
      double offset, {
        Duration duration = const Duration(milliseconds: 200),
        Curve curve = Curves.ease,
      }) async {
    await this.animateTo(0, duration: duration, curve: curve, );
  }

  ///水平移动
  JumToHorizontal({
    required GlobalKey key,
    required double offsetX,
    Duration? duration = const Duration(milliseconds: 200),
  }) {
    try {
      ScrollController scrollController = this;
      final position = offsetX;
      // final position = (ScreenUtil().screenWidth / 2 - 12.w);
      // final position = (MediaQuery.of(context).size.width / 2);

      double animateToOffset = 0;
      RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        return;
      }

      final size = renderBox.paintBounds.size;
      final vector3 = renderBox.getTransformTo(null).getTranslation();
      print("scrollToItemNew vector3:${vector3}");

      final offset = scrollController.offset;
      final extentAfter = scrollController.position.extentAfter;
      final needScrollPixels = vector3.x - position + size.width / 2;
      if (needScrollPixels < extentAfter) {
        animateToOffset = offset + needScrollPixels;
      } else {
        animateToOffset = offset + extentAfter;
      }
      if (animateToOffset < 0) animateToOffset = 0;
      if (scrollController.hasClients) {
        scrollController.animateTo(animateToOffset,
          duration: duration ?? const Duration(milliseconds: 200),
          curve: Curves.linear
        );
      }
    } catch (e) {
      print('JumToHorizontal->$e');
    }
  }


  scrollToItemNew({
    required GlobalKey itemKey,
    required GlobalKey scrollKey,
    Axis scrollDirection = Axis.vertical,
    Duration? duration = const Duration(milliseconds: 200),
  }) {
    ScrollController scrollController = this;

    RenderBox? renderBox = itemKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      print("Please bind the key to the widget!!!");
      return;
    }

    Offset local = renderBox.localToGlobal(Offset.zero, ancestor: scrollKey.currentContext?.findRenderObject());
    Size size = renderBox.size;

    double value = scrollDirection == Axis.horizontal ? local.dx : local.dy;

    var offset = value + scrollController.offset;
    print("scrollToItemNew local:${local}, size:${size}, offset: ${scrollController.offset}, offset: ${offset}");

    EdgeInsets padding = MediaQueryData.fromWindow(ui.window).padding;
    double paddingStart = scrollDirection == Axis.horizontal ? padding.left : padding.top;

    final extentAfter = scrollController.position.extentAfter;
    if (extentAfter <= local.dy) {
      print("scrollToItemNew extentAfter:${extentAfter} local.dy:${local.dy}");
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: duration ?? Duration(milliseconds: 200),
          curve: Curves.linear
      );
      return;
    }

    if (scrollController.hasClients) {
      scrollController.animateTo(offset - paddingStart,
          duration: duration ?? Duration(milliseconds: 200),
          curve: Curves.linear
      );
    }
  }

  scrollToItem({
    required GlobalKey itemKey,
    required GlobalKey scrollKey,
    Duration? duration = const Duration(milliseconds: 200),
  }) {
    ScrollController scrollController = this;

    RenderBox? renderBox = itemKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      print("Please bind the key to the widget!!!");
      return;
    }

    double dy = renderBox.localToGlobal(Offset.zero, ancestor: scrollKey.currentContext?.findRenderObject()).dy;
    var offset = dy + scrollController.offset;
    double stateTopH = MediaQueryData.fromWindow(ui.window).padding.top;

    final extentAfter = scrollController.position.extentAfter;
    if (extentAfter <= 0.0) {
      return;
    }
    if (scrollController.hasClients) {
      scrollController.animateTo(offset - stateTopH,
          duration: duration ?? Duration(milliseconds: 200),
          curve: Curves.linear
      );
    }
  }
}


extension ListViewExt on ListView{

  // 滑动到指定下标的item
  scrollToIndex({
    required ScrollController scrollController,
    required GlobalKey globalKey,
    required double offsetX,
    Duration? duration = const Duration(milliseconds: 200),
  }) {
    RenderBox? renderBox = globalKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      print("Please bind the key to the widget!!!");
      return;
    }

    double dy = renderBox.localToGlobal(Offset.zero).dy;
    var offset = dy + scrollController.offset;
    double stateTopH = MediaQueryData.fromWindow(ui.window).padding.top;
    scrollController.animateTo(offset - stateTopH,
        duration: duration ?? Duration(milliseconds: 200),
        curve: Curves.linear
    );

    final extentAfter = scrollController.position.extentAfter;
    print('scrollController:${scrollController.position}');
  }
}

extension ScrollPositionExt on ScrollPosition{
  printInfo(){
    final result = """
  /*********************** ScrollPosition ***********************/
  minScrollExtent: ${this.minScrollExtent}
  maxScrollExtent: ${this.maxScrollExtent}
  pixels: ${this.pixels}
  viewportDimension: ${this.viewportDimension}
  extentAfter: ${this.extentAfter}
  extentBefore: ${this.extentBefore}
  extentInside: ${this.extentInside}
  outOfRange: ${this.outOfRange}
  atEdge: ${this.atEdge}
""";
    print(result);
  }
}



