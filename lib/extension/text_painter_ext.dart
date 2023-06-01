

import 'package:flutter/cupertino.dart';

extension TextPainterExt on TextPainter{

  static TextPainter getTextPainter({
    required String text,
    required TextStyle textStyle,
    required int maxLine,
    required double maxWidth
  }) {
    var textSpan = TextSpan(text: text, style: textStyle);
    var textPainter = TextPainter(
        text: textSpan,
        maxLines: maxLine,
        textDirection: TextDirection.ltr
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter;
  }

  // 是否超出最大行
  static bool isExceedMaxLines({
    required String text,
    required TextStyle textStyle,
    required int maxLine,
    required double maxWidth
  }) {

    var textPainter = getTextPainter(
      text: text,
      textStyle: textStyle,
      maxLine: maxLine,
      maxWidth: maxWidth,
    );
    // debugPrint("text textPainter.height: ${textPainter.height}");
    if (textPainter.didExceedMaxLines) {
      return true;
    }
    return false;
  }
}