//
//  ddlog.dart
//  ddlog
//
//  Created by shang on 7/4/21 3:53 PM.
//  Copyright © 7/4/21 shang. All rights reserved.
//

import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// DLog 日志打印
// class DLog {
//   static void d(
//     Object? obj, {
//     String prefix = "DLog",
//     bool hasTime = true,
//     }) {
//     if (kReleaseMode) {
//       return;
//     }
//     developer.log("$prefix ${hasTime ? DateTime.now() : ""} $obj");
//   }
//
//   static void center(List<String> list) {
//     String line(String text, {String fill = "", required int maxLength}) {
//       final fillCount = maxLength - text.length;
//       final left = List.filled(fillCount ~/ 2, fill);
//       final right = List.filled(fillCount - left.length, fill);
//       return left.join() + text + right.join();
//     }
//
//     final listNew = [...list];
//     listNew.sort((a, b) => b.length.compareTo(a.length));
//     final maxLength = listNew.first.length;
//
//     for (final e in list) {
//       d(line(e, fill: ' ', maxLength: maxLength));
//     }
//   }
// }

class DLog {
  /// 是否启用日志打印
  static bool enableLog = true;

  /// 开启颜色
  static bool enableColor = false;

  // ANSI 颜色代码
  static const String _ansiReset = '\x1B[0m';
  static const String _ansiRed = '\x1B[31m';
  static const String _ansiGreen = '\x1B[32m';
  static const String _ansiYellow = '\x1B[33m';
  static const String _ansiBlue = '\x1B[34m';
  static const String _ansiGray = '\x1B[37m';

  // Web 控制台颜色样式
  static const String _webRed = 'color: red';
  static const String _webGreen = 'color: #4CAF50';
  static const String _webYellow = 'color: #FFC107';
  static const String _webBlue = 'color: #2196F3';
  static const String _webGray = 'color: #9E9E9E';

  // 打印调试日志
  static void d(dynamic message) {
    _printLog('DEBUG', message, _ansiBlue, _webBlue);
  }

  // 打印信息日志
  static void i(dynamic message) {
    _printLog('INFO', message, _ansiGreen, _webGreen);
  }

  // 打印警告日志
  static void w(dynamic message) {
    _printLog('WARN', message, _ansiYellow, _webYellow);
  }

  // 打印错误日志
  static void e(dynamic message) {
    _printLog('ERROR', message, _ansiRed, _webRed);
  }

  static void center(List<String> list) {
    String line(String text, {String fill = "", required int maxLength}) {
      final fillCount = maxLength - text.length;
      final left = List.filled(fillCount ~/ 2, fill);
      final right = List.filled(fillCount - left.length, fill);
      return left.join() + text + right.join();
    }

    final listNew = [...list];
    listNew.sort((a, b) => b.length.compareTo(a.length));
    final maxLength = listNew.first.length;

    for (final e in list) {
      d(line(e, fill: ' ', maxLength: maxLength));
    }
  }

  // 获取调用信息
  static (String className, String functionName, String fileName, int lineNumber) _getCallerInfo() {
    try {
      final frames = StackTrace.current.toString().split('\n');
      // 第一帧是当前方法，第二帧是日志方法（d/i/w/e），第三帧是调用者
      if (frames.length > 2) {
        final frame = frames[3]; // 获取调用者的帧
        // 匹配类名和方法名
        final classMatch = RegExp(r'#\d+\s+([^.]+)\.(\w+)').firstMatch(frame);
        final className = classMatch?.group(1) ?? 'Unknown';
        final functionName = classMatch?.group(2) ?? 'unknown';

        // 匹配文件名和行号
        final fileMatch = RegExp(r'\((.+?):(\d+)(?::\d+)?\)').firstMatch(frame);
        final fileName = fileMatch?.group(1) ?? 'unknown';
        final lineNumber = int.tryParse(fileMatch?.group(2) ?? '0') ?? 0;

        return (className, functionName, fileName, lineNumber);
      }
    } catch (e) {
      debugPrint('Error getting caller info: $e');
    }
    return ('', '', '', 0);
  }

  // 获取当前平台
  static String _getPlatform() {
    if (kIsWeb) {
      return 'Web';
    }
    try {
      return Platform.operatingSystem;
    } catch (e) {
      // 如果 Platform 不可用，返回 Unknown
      return '';
    }
  }

  // 内部打印方法
  static void _printLog(String level, dynamic message, String ansiColor, String webColor) {
    if (!enableLog || !kDebugMode) {
      return;
    }

    final (className, functionName, fileName, lineNumber) = _getCallerInfo();
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
    final platform = _getPlatform();

    final logMessage = kIsWeb
        ? '[$timeStr][$level][$platform]$message'
        : '[$timeStr][$level][$platform][$className.$functionName $lineNumber] $message';

    if (kIsWeb) {
      _printLogWeb(level, logMessage, webColor);
    } else {
      _printLogNative(level, logMessage, ansiColor);
    }
  }

  // Web 平台的打印实现
  static void _printLogWeb(String level, String message, String webColor) {
    developer.log(message);
  }

  // 原生平台的打印实现
  static void _printLogNative(String level, String message, String ansiColor) {
    final sb = StringBuffer();
    if (enableColor) {
      sb.write(ansiColor);
    }
    sb.write(message);
    if (enableColor) {
      sb.write(_ansiReset);
    }
    developer.log(sb.toString());
  }
}
