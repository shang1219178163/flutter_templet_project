//
//  n_attributed_string.dart
//  flutter_templet_project
//
//  Created by shang on 7/31/21 12:08 PM.
//  Copyright © 7/31/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/rich_text_ext.dart';


///富文本处理
class NAttributedString{

  NAttributedString({
    required this.context,
    required this.text,
    this.linkMap,
    this.prefix = "《",
    this.suffix = "》",
    this.style,
    this.linkStyle,
    required this.onTap
  });

  final BuildContext context;

  final String text;

  final Map<String, String>? linkMap;

  final String prefix;

  final String suffix;

  final TextStyle? style;

  final TextStyle? linkStyle;

  final void Function(String key, String? value) onTap;
  /// List<TextSpan> by [String text], [Map<String, String> linkMap]
  List<TextSpan>? get textSpans => _createTextSpans(context,
    text: text,
    linkMap: linkMap,
    style: style,
    linkStyle: linkStyle,
    prefix: prefix,
    suffix: suffix,
    onTap: onTap
  );

  /// List<TextSpan> by [String text], [Map<String, String> linkMap]
  List<TextSpan> _createTextSpans(BuildContext context, {
    required String text,
    Map<String, String>? linkMap,
    String prefix = "《",
    String suffix = "》",
    TextStyle? style,
    TextStyle? linkStyle,
    required void Function(String key, String? value) onTap}) {
    return RichTextExt.createTextSpans(context,
      text: text,
      linkMap: linkMap,
      prefix: prefix,
      suffix: suffix,
      onTap: onTap
    );
  }
}