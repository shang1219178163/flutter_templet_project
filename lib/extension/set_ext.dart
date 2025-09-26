//
//  ListExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/21/21 10:11 AM.
//  Copyright © 10/21/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/foundation.dart';

extension SetExt<T, E> on Set<E> {
  /// 相等判断
  bool equal(Set<E> other) {
    return setEquals(this, other);
  }
}
