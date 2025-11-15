//
//  TextPainterExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/8/29 20:19.
//  Copyright © 2023/8/29 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

extension TextPainterExt on TextPainter {
  /// 获取布局后的文字属性
  static TextPainter getTextPainter({
    required String text,
    TextStyle? textStyle,
    required int? maxLine,
    required double maxWidth,
  }) {
    final keyView = WidgetsBinding.instance.platformDispatcher.views.first;

    var textSpan = TextSpan(text: text, style: textStyle);
    var textPainter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
      locale: keyView.platformDispatcher.locale,
      text: textSpan,
      maxLines: maxLine,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter;
  }
}
