//
//  EnumExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/10 09:47.
//  Copyright © 2024/7/10 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

/// 可空 name 匹配
extension EnumExt<T extends Enum> on Iterable<T> {
  /// Finds the enum value in this list with name [name].
  T? byNullableName(String? name) {
    if (name == null) {
      return null;
    }
    try {
      return byName(name);
    } catch (e) {
      debugPrint("❌ $e");
    }
    return null;
  }

  /// Finds the enum value in this list with test.
  T? by(bool Function(T e) test) {
    for (final e in this) {
      if (test(e)) {
        return e;
      }
    }
    return null;
  }
}

extension EnumStringExt<T extends Enum> on String? {
  /// 字符串转枚举
  /// values - 枚举数组
  T? enumOf(Iterable<T> values) {
    return values.byNullableName(this);
  }
}
