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
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:tuple/tuple.dart';

extension RichTextExt on RichText{

  /// List<TextSpan> by [String text], [Map<String, String> linkMap], prefix = "《", suffix = "》"
  static List<TextSpan> createTextSpans(BuildContext context, {
    required String text,
    Map<String, String>? linkMap,
    String prefix = "《",
    String suffix = "》",
    TextStyle? style,
    TextStyle? linkStyle,
    required void Function(String key, String? value) onTap
  }) {
    assert(text.isNotEmpty && prefix.isNotEmpty && suffix.isNotEmpty);

    linkMap?.forEach((key, value) {
      assert(key.startsWith(prefix) && key.endsWith(suffix) && text.contains(key));
    });

    final origin = '$prefix[^$prefix$suffix]+$suffix';
    final reg = RegExp(origin, multiLine: true).allMatches(text);
    var matchTitles = reg.map((e) => e.group(0)).whereType<String>().toList();

    final titles = linkMap?.keys ?? matchTitles;
    final list = text.split(RegExp('$prefix|$suffix'));

    var textSpans = list
        .map((e) => !titles.contains("$prefix$e$suffix")
        ? TextSpan(text: e, style: style)
        : TextSpan(
      text: "$prefix$e$suffix",
      style: linkStyle ??
          TextStyle(color: Theme.of(context).colorScheme.primary),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onTap("$prefix$e$suffix", linkMap?["$prefix$e$suffix"]);
        },
    )).toList();
    return textSpans;
  }

}


extension TextSpanExt on TextSpan{

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
    ValueChanged<String?>? onTap,
  }) {
    final content = text ?? this.text;

    TapGestureRecognizer? reco;
    if (onTap != null) {
      reco = TapGestureRecognizer()
        ..onTap = () => onTap.call(content);
    }

    return TextSpan(
      text: content,
      children: children ?? this.children,
      style: style ?? this.style,
      recognizer: reco ?? recognizer ?? this.recognizer,
      onEnter: onEnter ?? this.onEnter,
      onExit: onExit ?? this.onExit,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      locale: locale ?? this.locale,
      spellOut: spellOut ?? this.spellOut,
    );
  }

}