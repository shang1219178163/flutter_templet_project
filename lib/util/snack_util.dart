import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/app_service.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';

/// 全局 SnackBar 工具（通过 [scaffoldKey] 无需页面 BuildContext）
class SnackUtil {
  SnackUtil._();

  /// 挂到 [MaterialApp.router.scaffoldMessengerKey]
  static final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static final List<SnackBar> _snackBars = <SnackBar>[];

  /// 当前已展示 / 排队中的 SnackBar（只读）
  static List<SnackBar> get snackBars => List<SnackBar>.unmodifiable(_snackBars);

  static ScaffoldMessengerState? get _currentState => scaffoldKey.currentState;

  /// 当前主题配色。
  /// 应取 Theme **之下** 的 Navigator context，或 [AppThemeService]。
  static ColorScheme get _colorScheme {
    final navContext = AppService.navigatorKey.currentContext;
    if (navContext != null) {
      return Theme.of(navContext).colorScheme;
    }
    final theme = AppThemeService();
    return theme.buildColorScheme(theme.brightness);
  }

  /// 移除尚未消失的旧弹窗
  static void clear() {
    if (_snackBars.isEmpty) {
      return;
    }
    _currentState?.clearSnackBars();
    _snackBars.clear();
  }

  /// 错误：error / onError + 圆形警告图标
  static void error(
    String message, {
    IconData icon = Icons.error,
    Duration? duration,
    bool clear = false,
  }) {
    custom(
      message,
      backgroundColor: _colorScheme.error,
      textColor: _colorScheme.onError,
      icon: icon,
      duration: duration,
      clear: clear,
    );
  }

  /// 警告：tertiary / onTertiary + 三角警告图标
  static void warn(
    String message, {
    IconData icon = Icons.warning_amber_rounded,
    Duration? duration,
    bool clear = false,
  }) {
    custom(
      message,
      backgroundColor: _colorScheme.tertiary,
      textColor: _colorScheme.onTertiary,
      icon: icon,
      duration: duration,
      clear: clear,
    );
  }

  /// 成功：主题 primary / onPrimary + 成功图标
  static void show(
    String message, {
    IconData icon = Icons.check_circle,
    Duration? duration,
    bool clear = false,
  }) {
    custom(
      message,
      backgroundColor: _colorScheme.primary,
      textColor: _colorScheme.onPrimary,
      icon: icon,
      duration: duration,
      clear: clear,
    );
  }

  /// 自定义提示（默认同 [show]，均可覆盖）
  static void custom(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData icon = Icons.check_circle,
    Color? iconColor,
    Duration? duration,
    SnackBarAction? action,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    bool clear = false,
  }) {
    if (clear || _snackBars.isNotEmpty) {
      SnackUtil.clear();
    }
    final bg = backgroundColor ?? _colorScheme.primary;
    final fg = textColor ?? _colorScheme.onPrimary;
    final fgIcon = iconColor ?? fg;
    final snackBar = SnackBar(
      backgroundColor: bg,
      behavior: behavior,
      duration: duration ?? const Duration(seconds: 2),
      action: action,
      content: Row(
        children: [
          Icon(icon, color: fgIcon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TextStyle(color: fg)),
          ),
        ],
      ),
    );
    final controller = _currentState?.showSnackBar(snackBar);
    if (controller == null) {
      return;
    }
    _snackBars.add(snackBar);
    controller.closed.then((_) {
      _snackBars.remove(snackBar);
    });
  }

  /// 隐藏当前 SnackBar
  static void hide({bool clear = false}) {
    if (clear) {
      _currentState?.clearSnackBars();
      _snackBars.clear();
      return;
    }
    _currentState?.hideCurrentSnackBar();
    if (_snackBars.isNotEmpty) {
      _snackBars.removeLast();
    }
  }
}
