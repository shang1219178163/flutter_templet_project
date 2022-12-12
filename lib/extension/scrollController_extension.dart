//
//  ScrollControllerExtension.dart
//  flutter_templet_project
//
//  Created by shang on 12/12/22 9:16 AM.
//  Copyright © 12/12/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

extension ScrollControllerExt on ScrollController{
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
      print('home_crash:animateToCurSelectedSecondaryTab->$e');
    }
  }
}






