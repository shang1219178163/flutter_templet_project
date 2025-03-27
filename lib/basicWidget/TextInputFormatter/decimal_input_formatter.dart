//
//  DecimalInputFormatter.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/18 11:38.
//  Copyright © 2024/12/18 shang. All rights reserved.
//

import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  DecimalInputFormatter({
    this.fractionDigits = 2,
  });

  /// 小数位
  final int fractionDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // 正则表达式用于限制最多两位小数
    var newText = newValue.text;

    // 如果输入是空字符串，允许
    if (newText.isEmpty) {
      return newValue;
    }

    // 如果输入包含小数点，处理小数位数
    if (newText.contains('.')) {
      var decimalIndex = newText.indexOf('.');
      var integerPart = newText.substring(0, decimalIndex);
      var decimalPart = newText.substring(decimalIndex + 1);

      if (decimalPart.length > fractionDigits) {
        // 如果小数部分超过两位，截断
        decimalPart = decimalPart.substring(0, fractionDigits);
      }

      newText = '$integerPart.$decimalPart';
    }

    // 如果输入符合要求，返回新的 TextEditingValue
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
