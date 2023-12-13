//
//  MinMaxTextInputFormatter.dart
//  flutter_templet_project
//
//  Created by shang on 2023/12/13 21:50.
//  Copyright © 2023/12/13 shang. All rights reserved.
//

import 'package:flutter/services.dart';

/// int 最大最小值
class MinMaxTextInputFormatter extends TextInputFormatter {

  MinMaxTextInputFormatter({
    this.min = 0,
    required this.max,
  })  : assert(min >= 0),
        assert(max >= min);

  final int max;
  final int min;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // debugPrint("newValue.text: ${newValue.text}");
    final newNum = int.tryParse(newValue.text) ?? 0;
    final isBeyond = newNum < min || newNum > max;
    final isStartZero = oldValue.text.isEmpty && newValue.text == "0";
    if (isBeyond || isStartZero) {
      return oldValue;
    }
    return newValue;
  }
}


