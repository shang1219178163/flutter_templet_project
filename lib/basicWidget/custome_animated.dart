//
//  custome_animated.dart
//  fluttertemplet
//
//  Created by shang on 10/21/21 8:54 AM.
//  Copyright © 10/21/21 shang. All rights reserved.
//


import 'package:flutter/animation.dart';
import 'dart:math';

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t * math.PI * 2);
  }
}