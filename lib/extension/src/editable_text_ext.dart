//
//  EditableTextExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/9/7 17:16.
//  Copyright © 2023/9/7 shang. All rights reserved.
//

import 'package:flutter/material.dart';

extension TextEditingControllerExt on TextEditingController {
  /// 删除单个字符
  deleteChar() {
    final textBeforeCursor = selection.textBefore(text).characters.skipLast(1).toString();
    final textAfterCursor = selection.textAfter(text);
    text = textBeforeCursor + textAfterCursor;

    // debugPrint("newTextBeforeCursor: $textBeforeCursor");
    // debugPrint("newTextAfterCursor: $textAfterCursor");
    // 重置光标位置
    selection = TextSelection.fromPosition(TextPosition(
      affinity: TextAffinity.downstream,
      offset: textBeforeCursor.length,
    ));
  }

  /// 移动光标到最后
  moveCursorEnd() {
    selection = TextSelection.fromPosition(TextPosition(
      affinity: TextAffinity.downstream,
      offset: text.length,
    ));

    // selection = TextSelection.collapsed(offset: text.length);
  }

  /// 创建 InputDecoration 的 Counter 组件
  Widget? buildInputDecorationCounter({
    required int? maxLength,
    Color? current,
    Color? total,
  }) {
    if (maxLength == null) {
      return null;
    }
    return ValueListenableBuilder(
      valueListenable: this,
      builder: (context, value, child) {
        var items = <({String text, Color color})>[
          (
            text: "${value.text.characters.length}",
            color: current ?? Colors.black87,
          ),
          (
            text: '/$maxLength',
            color: total ?? Color(0xFF737373),
          ),
        ];

        return Text.rich(
          TextSpan(
            children: items.map((e) {
              return TextSpan(
                text: e.text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: e.color,
                ),
              );
            }).toList(),
          ),
          maxLines: 1,
        );
      },
    );
  }
}

extension TextFieldExt on TextField {}
