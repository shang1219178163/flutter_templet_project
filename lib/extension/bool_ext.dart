//
//  BoolExt.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/25 09:38.
//  Copyright © 2024/6/25 shang. All rights reserved.
//

extension BoolExt on bool? {
  /// 转字符串
  String toValue({String trueValue = "Y", String falseValue = "N"}) {
    return this == true ? trueValue : falseValue;
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
