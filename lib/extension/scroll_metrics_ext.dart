//
//  ScrollMetricsExtension.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/22 3:34 PM.
//  Copyright © 12/15/22 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

extension ScrollMetricsExt on ScrollMetrics {
  printInfo() {
    var metrics = this;
    final info = """
    ScrollMetrics####################
    atEdge: ${metrics.atEdge}
    axis: ${metrics.axis}
    axisDirection: ${metrics.axisDirection}
    extentAfter: ${metrics.extentAfter}
    extentBefore: ${metrics.extentBefore}
    extentInside: ${metrics.extentInside}
    hasContentDimensions: ${metrics.hasContentDimensions}
    maxScrollExtent: ${metrics.maxScrollExtent}
    minScrollExtent: ${metrics.minScrollExtent}
    outOfRange: ${metrics.outOfRange}
    pixels: ${metrics.pixels}
    viewportDimension: ${metrics.viewportDimension}
    """;
    debugPrint(info);
  }

  //顶部
  bool get isStart => atEdge && extentBefore <= 0;
  //底部
  bool get isEnd => atEdge && extentAfter <= 0;
  //滚动进度
  double get progress => pixels / maxScrollExtent;
  //滚动进度
  String get progressPerecent => "${(progress * 100).toInt()}%";
}
