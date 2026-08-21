//
//  TypeWriterText.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/9 10:02.
//  Copyright © 2024/9/9 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';

class NTypeWriterText extends StatefulWidget {
  const NTypeWriterText({
    super.key,
    required this.text,
    this.onChanged,
  });

  final String text;
  final Widget Function(String value)? onChanged;

  @override
  State<NTypeWriterText> createState() => _NTypeWriterTextState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ObjectFlagProperty<Widget Function(String value)?>.has('onChanged', onChanged));
  }
}

class _NTypeWriterTextState extends State<NTypeWriterText>
    with SafeSetStateMixin {
  late String text = widget.text;
  String displayedText = "";
  int charPosition = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    displayedText = "";
    charPosition = 0;
    _typeWriterEffect();
  }

  void _typeWriterEffect() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (charPosition < text.length) {
        displayedText += text[charPosition];
        charPosition++;
        setState(() {});
        _typeWriterEffect();
      }
    });
  }

  @override
  void didUpdateWidget(covariant NTypeWriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // DLog.d("oldWidget.text: ${oldWidget.text}");
    // DLog.d("widget.text: ${widget.text}");
    if (oldWidget.text != widget.text) {
      text = widget.text;
      initData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.onChanged?.call(displayedText) ??
        Text(displayedText, style: TextStyle(fontSize: 16));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(StringProperty('displayedText', displayedText));
    properties.add(IntProperty('charPosition', charPosition));
  }
}
