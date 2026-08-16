/// 简易彩色日志：分级输出，支持 ANSI 颜色（终端不支持时自动降级为纯文本）。
library;

import 'dart:io';

/// 日志级别
enum LogLevel { debug, info, success, warn, error }

/// 简易日志器
class Logger {
  Logger({this.enableColor = true});

  /// 是否启用 ANSI 颜色
  final bool enableColor;

  void debug(String msg) => _log(LogLevel.debug, msg);

  void info(String msg) => _log(LogLevel.info, msg);

  void success(String msg) => _log(LogLevel.success, msg);

  void warn(String msg) => _log(LogLevel.warn, msg);

  void error(String msg) => _log(LogLevel.error, msg);

  void _log(LogLevel level, String msg) {
    final code = _colorCode(level);
    final prefix = switch (level) {
      LogLevel.debug => 'DEBUG',
      LogLevel.info => 'INFO',
      LogLevel.success => 'OK',
      LogLevel.warn => 'WARN',
      LogLevel.error => 'ERROR',
    };
    final text = '$prefix  $msg';
    if (enableColor && code != null) {
      stdout.writeln('\x1B[${code}m$text\x1B[0m');
    } else {
      stdout.writeln(text);
    }
  }

  String? _colorCode(LogLevel level) => switch (level) {
        LogLevel.debug => null,
        LogLevel.info => '36', // 青色
        LogLevel.success => '32', // 绿色
        LogLevel.warn => '33', // 黄色
        LogLevel.error => '31', // 红色
      };
}
