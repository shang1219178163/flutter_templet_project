//
//  EditableTextExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/9/7 17:16.
//  Copyright © 2023/9/7 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';

extension TextEditingControllerExt on TextEditingController{

  /// 删除单个字符
  deleteChar() {
    final textBeforeCursor = selection.textBefore(text)
        .characters.skipLast(1).toString();
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
  }
}