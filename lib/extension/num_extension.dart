//
//  NumExtension.dart
//  lib
//
//  Created by shang on 11/29/21 3:38 PM.
//  Copyright © 11/29/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/cupertino.dart';

int randomInt({required int min, required int max}) {
  return min + Random().nextInt(max - min);
}


extension NumExt on num {
  /// empty padding height
  SizedBox get ph => SizedBox(height: toDouble(),);

  /// empty padding width
  SizedBox get pw => SizedBox(width: toDouble(),);
}

