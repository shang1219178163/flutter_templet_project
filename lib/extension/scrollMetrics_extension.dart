//
//  ScrollMetricsExtension.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/22 3:34 PM.
//  Copyright © 12/15/22 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';

extension ScrollMetricsExt on ScrollMetrics{

  printInfo() {
    ScrollMetrics metrics = this;
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
    print(info);
  }

  //顶部
  bool get isStart => this.atEdge && this.extentBefore <= 0;
  //底部
  bool get isEnd => this.atEdge && this.extentAfter <= 0;

}



