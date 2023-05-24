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
    var scrollController = this;
    position.printInfo();

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
    if (duration == Duration.zero) {
      jumpTo(offset);
      return;
    }
    await animateTo(offset, duration: duration, curve: curve, );
  }

  ///水平移动
  jumToHorizontal({
    required GlobalKey key,
    required double offsetX,
    Duration? duration = const Duration(milliseconds: 200),
  }) {
    try {
      var scrollController = this;
      final position = offsetX;
      // final position = (ScreenUtil().screenWidth / 2 - 12.w);
      // final position = (MediaQuery.of(context).size.width / 2);

      var animateToOffset = 0.0;
      var renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        return;
      }

      final size = renderBox.paintBounds.size;
      final vector3 = renderBox.getTransformTo(null).getTranslation();
      debugPrint("scrollToItemNew vector3:$vector3");

      final offset = scrollController.offset;
      final extentAfter = scrollController.position.extentAfter;
      final needScrollPixels = vector3.x - position + size.width / 2;
      if (needScrollPixels < extentAfter) {
        animateToOffset = offset + needScrollPixels;
      } else {
        animateToOffset = offset + extentAfter;
      }
      if (animateToOffset < 0) {
        animateToOffset = 0;
      }
      if (scrollController.hasClients) {
        scrollController.animateTo(animateToOffset,
          duration: duration ?? const Duration(milliseconds: 200),
          curve: Curves.linear
        );
      }
    } catch (e) {
      debugPrint('JumToHorizontal->$e');
    }
  }


  scrollToItemNew({
    required GlobalKey itemKey,
    required GlobalKey scrollKey,
    Axis scrollDirection = Axis.vertical,
    Duration? duration = const Duration(milliseconds: 200),
  }) {
    var scrollController = this;

    var renderBox = itemKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      debugPrint("Please bind the key to the widget!!!");
      return;
    }

    var local = renderBox.localToGlobal(Offset.zero, ancestor: scrollKey.currentContext?.findRenderObject());
    var size = renderBox.size;

    var value = scrollDirection == Axis.horizontal ? local.dx : local.dy;

    var offset = value + scrollController.offset;
    debugPrint("scrollToItemNew local:$local, size:$size, offset: ${scrollController.offset}, offset: $offset");

    var padding = MediaQueryData.fromWindow(ui.window).padding;
    var paddingStart = scrollDirection == Axis.horizontal ? padding.left : padding.top;

    final extentAfter = scrollController.position.extentAfter;
    if (extentAfter <= local.dy) {
      debugPrint("scrollToItemNew extentAfter:$extentAfter local.dy:${local.dy}");
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: duration ?? const Duration(milliseconds: 200),
          curve: Curves.linear
      );
      return;
    }

    if (scrollController.hasClients) {
      scrollController.animateTo(offset - paddingStart,
          duration: duration ?? const Duration(milliseconds: 200),
          curve: Curves.linear
      );
    }
  }

  scrollToItem({
    required GlobalKey itemKey,
    required GlobalKey scrollKey,
    Duration? duration = const Duration(milliseconds: 200),
  }) {
    var scrollController = this;

    var renderBox = itemKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      debugPrint("Please bind the key to the widget!!!");
      return;
    }

    var dy = renderBox.localToGlobal(Offset.zero, ancestor: scrollKey.currentContext?.findRenderObject()).dy;
    var offset = dy + scrollController.offset;
    var stateTopH = MediaQueryData.fromWindow(ui.window).padding.top;

    final extentAfter = scrollController.position.extentAfter;
    if (extentAfter <= 0.0) {
      return;
    }
    if (scrollController.hasClients) {
      scrollController.animateTo(offset - stateTopH,
          duration: duration ?? const Duration(milliseconds: 200),
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
    var renderBox = globalKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      debugPrint("Please bind the key to the widget!!!");
      return;
    }

    var dy = renderBox.localToGlobal(Offset.zero).dy;
    var offset = dy + scrollController.offset;
    var stateTopH = MediaQueryData.fromWindow(ui.window).padding.top;
    scrollController.animateTo(offset - stateTopH,
        duration: duration ?? const Duration(milliseconds: 200),
        curve: Curves.linear
    );

    final extentAfter = scrollController.position.extentAfter;
    debugPrint('scrollController:${scrollController.position}');
  }
}

extension ScrollPositionExt on ScrollPosition{
  printInfo(){
    final result = """
  /*********************** ScrollPosition ***********************/
  minScrollExtent: $minScrollExtent
  maxScrollExtent: $maxScrollExtent
  pixels: $pixels
  viewportDimension: $viewportDimension
  extentAfter: $extentAfter
  extentBefore: $extentBefore
  extentInside: $extentInside
  outOfRange: $outOfRange
  atEdge: $atEdge
""";
    debugPrint(result);
  }
}



