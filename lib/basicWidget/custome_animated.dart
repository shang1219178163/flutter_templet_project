//
//  custome_animated.dart
//  flutter_templet_project
//
//  Created by shang on 10/21/21 8:54 AM.
//  Copyright © 10/21/21 shang. All rights reserved.
//

import 'package:flutter/animation.dart';
import 'dart:math' as math;

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t * math.pi * 2);
  }
}
