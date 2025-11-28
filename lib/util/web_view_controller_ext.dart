import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:webview_flutter/webview_flutter.dart';

extension WebViewControllerExt on WebViewController {
  /// 改变背景色
  Future<void> changBodyStyle({
    required Color textColor,
    required Color bgColor,
  }) async {
    final textColorStr = textColor.toHex().replaceFirst("#ff", "#");
    final bgColorStr = bgColor.toHex().replaceFirst("#ff", "#");
    return runJavaScript('''
    var style = document.createElement('style');
    style.innerHTML = 'body { background: $bgColorStr !important; color: $textColorStr !important; }';
    document.head.appendChild(style);
  ''');
  }
}
