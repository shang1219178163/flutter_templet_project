//
//  block_text_input_formatter.dart
//  flutter_templet_project
//
//  Created by shang on 2023/12/13 21:50.
//  Copyright © 2023/12/13 shang. All rights reserved.
//

import 'package:flutter/services.dart';

class BlockTextInputFormatter extends TextInputFormatter {
  BlockTextInputFormatter({
    required this.banBlock,
  });

  /// 禁用回调
  final bool Function(TextEditingValue oldValue, TextEditingValue newValue)
      banBlock;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // debugPrint("newValue.text: ${newValue.text}");
    if (banBlock(oldValue, newValue)) {
      return oldValue;
    }
    return newValue;
  }
}
