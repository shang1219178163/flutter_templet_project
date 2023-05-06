


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
