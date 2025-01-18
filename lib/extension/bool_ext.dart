//
//  BoolExt.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/25 09:38.
//  Copyright © 2024/6/25 shang. All rights reserved.
//

import 'dart:math';
import 'package:flutter_templet_project/extension/num_ext.dart';

extension BoolExt on bool? {
  /// 转字符串
  String toValue({String trueValue = "Y", String falseValue = "N"}) {
    return this == true ? trueValue : falseValue;
  }

  /// 随机布尔值
  static bool random() {
    final result = Random().nextInt(2) == 1;
    return result;
  }
}

extension BoolStringExt on String? {
  /// 转字符串
  bool toBool({List<String> trueValues = const ["y", "true", "yes"]}) {
    final val = this?.toLowerCase();
    final result = trueValues.contains(val);
    return result;
  }
}
