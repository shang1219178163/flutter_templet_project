//
//  NumberFormat.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:18.
//  Copyright © 2023/8/29 shang. All rights reserved.
//


import 'package:intl/intl.dart';

extension NumberFormatExt on NumberFormat{
  /// 转为百分比描述
  // 返回千分位分隔的金额
  static String? formatAmount(String? val) {
    if (val == '' || val == null) {
      return null;
    }
    double? num = double.tryParse(val);
    if (num == null) {
      return null;
    }
    if (num > 999) {
      var format = NumberFormat('0,000.00');
      return format.format(num);
    } else {
      return val;
    }
  }
}
