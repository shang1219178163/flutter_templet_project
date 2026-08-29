import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

/// AI 对话网络/流式错误文案与分类
abstract final class AiChatError {
  /// 本模块 [CancelToken.cancel] 使用的 reason（非 Dio 时仅认这些，避免误吞含 cancel 的真实错误）
  static const _cancelReasons = {'user_stop', 'dispose', 'fail'};

  static bool _isTimeoutOrConnectionType(DioExceptionType type) => switch (type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.connectionError =>
          true,
        _ => false,
      };

  /// 转为用户可读中文提示
  static String format(Object error) {
    if (error is DioException) {
      if (CancelToken.isCancel(error) || error.type == DioExceptionType.cancel) {
        return '已取消';
      }
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.transformTimeout:
          return '连接超时，请检查网络后重试';
        case DioExceptionType.connectionError:
          return '网络连接失败，请检查网络后重试';
        case DioExceptionType.badCertificate:
          return '证书校验失败';
        case DioExceptionType.badResponse:
          final code = error.response?.statusCode;
          return switch (code) {
            401 => 'API Key 无效（401）',
            null => '请求失败：${error.message ?? error}',
            _ => '请求失败（$code）',
          };
        case DioExceptionType.cancel:
          return '已取消';
        case DioExceptionType.unknown:
          final inner = error.error;
          if (inner != null) {
            return format(inner);
          }
          return _matchMessage(error.message) ?? '网络异常，请重试';
      }
    }
    if (error is SocketException) {
      return '网络连接中断，请检查网络后重试';
    }
    if (error is HttpException) {
      return '链接中断，请重试';
    }
    if (error is TimeoutException) {
      return '连接超时，请重试';
    }
    return _matchMessage(error.toString()) ?? error.toString();
  }

  /// 用户主动取消（不应弹错误 Banner）
  static bool isCancel(Object error) {
    if (error is DioException) {
      return CancelToken.isCancel(error) || error.type == DioExceptionType.cancel;
    }
    final s = error.toString();
    return _cancelReasons.any((r) => s == r || s.endsWith(': $r') || s.endsWith('($r)'));
  }

  /// 链接中断 / 网络不可用 / 超时等
  static bool isConnectionIssue(Object error) {
    if (error is String) {
      return error.contains('链接中断') ||
          error.contains('连接超时') ||
          error.contains('网络连接') ||
          error.contains('网络异常') ||
          _matchMessage(error) != null;
    }
    if (error is DioException) {
      if (_isTimeoutOrConnectionType(error.type)) {
        return true;
      }
      if (error.type == DioExceptionType.unknown) {
        final inner = error.error;
        if (inner != null) {
          return isConnectionIssue(inner);
        }
        return _matchMessage(error.message) != null;
      }
      return false;
    }
    if (error is SocketException || error is HttpException || error is TimeoutException) {
      return true;
    }
    return _matchMessage(error.toString()) != null;
  }

  /// 从原始英文/底层文案识别连接类问题
  static String? _matchMessage(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    final s = raw.toLowerCase();
    const keys = [
      'connection closed',
      'connection reset',
      'connection refused',
      'connection abort',
      'broken pipe',
      'network is unreachable',
      'failed host lookup',
      'socketexception',
      'stream closed',
      'connection error',
      'software caused connection abort',
      'clientexception',
      'http exception',
    ];
    for (final k in keys) {
      if (s.contains(k)) {
        return '链接中断，请检查网络后重试';
      }
    }
    if (s.contains('timed out') || s.contains('timeout')) {
      return '连接超时，请检查网络后重试';
    }
    return null;
  }
}
