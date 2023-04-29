


import 'package:flutter/foundation.dart';

/// 防止日志被截断
void printWrapped(String text) {
  if (!kDebugMode) {
    return;
  }
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}
