
import 'package:flutter/material.dart';

///资源整合
class R {
  static final _R_String string = _R_String._OB;
  static final _R_Color color = _R_Color._OB;
  static final _R_Event event = _R_Event._OB;

}

class _R_String {
  static final _R_String _OB = _R_String();

  final share = "分享";

}

class _R_Color {
  static final _R_Color _OB = _R_Color();

  final theme = Colors.blue;

}

class _R_Event {
  static final _R_Event _OB = _R_Event();

  final eventID = 6000;

}