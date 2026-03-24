//
//  AlignmentExtension.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/12 20:57.
//  Copyright © 2023/1/12 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

extension CurveExt on Curve {
  /// 九个方位变量集合
  static const allCases = <Curve>[
    Curves.linear,
    Curves.decelerate,
    Curves.fastLinearToSlowEaseIn,
    Curves.ease,
    Curves.easeIn,
    Curves.easeInToLinear,
    Curves.easeInSine,
    Curves.easeInQuad,
    Curves.easeInCubic,
    Curves.easeInQuart,
    Curves.easeInQuint,
    Curves.easeInExpo,
    Curves.easeInCirc,
    Curves.easeInBack,
    Curves.easeOut,
    Curves.linearToEaseOut,
    Curves.easeOutSine,
    Curves.easeOutQuad,
    Curves.easeOutCubic,
    Curves.easeOutQuart,
    Curves.easeOutQuint,
    Curves.easeOutExpo,
    Curves.easeOutCirc,
    Curves.easeOutBack,
    Curves.easeInOut,
    Curves.easeInOutSine,
    Curves.easeInOutQuad,
    Curves.easeInOutCubic,
    Curves.easeInOutQuart,
    Curves.easeInOutQuint,
    Curves.easeInOutExpo,
    Curves.easeInOutCirc,
    Curves.easeInOutBack,
    Curves.fastOutSlowIn,
    Curves.slowMiddle,
  ];
}
