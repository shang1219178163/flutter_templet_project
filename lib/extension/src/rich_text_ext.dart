//
//  rich_text_ext.dart
//  flutter_templet_project
//
//  Created by shang on 7/31/21 1:48 PM.
//  Copyright © 7/31/21 shang. All rights reserved.
//

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension RichTextExt on RichText {
  /// 创建 List<TextSpan>
  ///
  /// text 整个段落
  /// textTaps 高亮字符串数组
  /// style 段落样式
  /// linkStyle 高亮样式
  /// prefix 切割符号,避免和文章包含字符串重复
  /// suffix 切割符号,避免和文章包含字符串重复
  /// onLink 高亮部分点击事件
  static List<TextSpan> createTextSpans({
    required String text,
    required List<String> textTaps,
    TextStyle? style,
    TextStyle? linkStyle,
    String prefix = "_&t",
    String suffix = "_&t",
    void Function(String textTap)? onLink,
  }) {
    final pattern = textTaps.map((d) => RegExp.escape(d)).join('|');
    final regExp = RegExp(pattern, multiLine: true, caseSensitive: false);
    final textNew = text.splitMapJoin(
      regExp,
      onMatch: (m) => '$prefix${m[0]}$suffix', // (or no onMatch at all)
      onNonMatch: (n) => n,
    );

    final list = textNew.split(RegExp('$prefix|$suffix'));
    return list.map((e) {
      if (e.isNotEmpty) {
        final isEquel = textTaps.contains(e) ||
            textTaps.contains(e.toLowerCase()) ||
            textTaps.contains(e.toUpperCase());
        if (isEquel) {
          return TextSpan(
            text: e,
            style: linkStyle ?? TextStyle(color: Colors.blue),
            recognizer: onLink == null ? null : TapGestureRecognizer()
              ?..onTap = () {
                onLink?.call(e);
              },
          );
        }
      }
      return TextSpan(text: e, style: style);
    }).toList();
  }
}

extension TextSpanExt on TextSpan {
  /// 二次赋值
  TextSpan copyWith({
    String? text,
    List<InlineSpan>? children,
    TextStyle? style,
    GestureRecognizer? recognizer,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    String? semanticsLabel,
    Locale? locale,
    bool? spellOut,
    ValueChanged<String?>? onLink,
  }) {
    final content = text ?? this.text;

    TapGestureRecognizer? gesture;
    if (onLink != null) {
      gesture = TapGestureRecognizer()..onTap = () => onLink.call(content);
    }

    return TextSpan(
      text: content,
      children: children ?? this.children,
      style: style ?? this.style,
      recognizer: gesture ?? recognizer ?? this.recognizer,
      onEnter: onEnter ?? this.onEnter,
      onExit: onExit ?? this.onExit,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      locale: locale ?? this.locale,
      spellOut: spellOut ?? this.spellOut,
    );
  }
}
