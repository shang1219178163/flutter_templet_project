//
//  EnumExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/10 09:47.
//  Copyright © 2024/7/10 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

/// 可空 name 匹配
extension EnumByNullableName<T extends Enum> on Iterable<T> {
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
}
