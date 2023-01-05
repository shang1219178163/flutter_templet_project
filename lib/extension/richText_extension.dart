//
//  richText_extension.dart
//  flutter_templet_project
//
//  Created by shang on 7/31/21 1:48 PM.
//  Copyright © 7/31/21 shang. All rights reserved.
//


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

extension RichTextExt on RichText{

  /// List<TextSpan> by [String text], [Map<String, String> linkMap], prefix = "《", suffix = "》"
  static List<TextSpan> createTextSpans(BuildContext context, {
    required String text,
    Map<String, String>? linkMap,
    String prefix = "《",
    String suffix = "》",
    TextStyle? style,
    TextStyle? linkStyle,
    required void onTap(String key, String? value)}) {
    assert(text.isNotEmpty && prefix.isNotEmpty && suffix.isNotEmpty);

    linkMap?.forEach((key, value) {
      assert(key.startsWith(prefix) && key.endsWith("$suffix") && text.contains(key));
    });

    final origin = '$prefix[^$prefix$suffix]+$suffix';
    final reg = RegExp(origin, multiLine: true).allMatches(text);
    List<String> matchTitles = reg.map((e) => e.group(0)).whereType<String>().toList();

    final titles = linkMap?.keys ?? matchTitles;
    final list = text.split(RegExp('$prefix|$suffix'));

    List<TextSpan> textSpans = list
        .map((e) => !titles.contains("$prefix$e$suffix")
        ? TextSpan(text: e, style: style)
        : TextSpan(
      text: "$prefix$e$suffix",
      style: linkStyle ??
          TextStyle(color: Theme.of(context).primaryColor),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onTap("$prefix$e$suffix", linkMap?["$prefix$e$suffix"]);
        },
    )).toList();
    return textSpans;
  }

}