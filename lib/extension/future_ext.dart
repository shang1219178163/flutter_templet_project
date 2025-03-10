import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

extension FutureWidgetEx<T> on Future<T> {
  FutureBuilder when({
    required Widget Function(T data) data,
    required Widget Function(Object? e, StackTrace? s) error,
    required Widget Function() loading,
  }) {
    return FutureBuilder<T>(
      future: this,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return error(snapshot.error, snapshot.stackTrace);
        }
        if (snapshot.hasData) {
          return data(snapshot.data as T);
        }
        return loading();
      },
    );
  }

  FutureBuilder maybeWhen({
    Widget Function(T data)? data,
    Widget Function(Object? e, StackTrace? s)? error,
    Widget Function()? loading,
    required Widget Function() orElse,
  }) {
    return when(
      data: data ?? (_) => orElse(),
      error: error ?? (err, stack) => orElse(),
      loading: loading ?? () => orElse(),
    );
  }

  /// 统计 Future 的耗时
  Future<T> trackTime(String methodName, {Function(int time)? onResult}) async {
    final stopwatch = Stopwatch()..start();
    try {
      T result = await this;
      stopwatch.stop();
      int elapsed = stopwatch.elapsedMilliseconds;

      // 如果提供了回调，则回调耗时
      onResult?.call(elapsed);

      // 默认打印耗时
      debugPrint("📊 [$methodName] 方法耗时：${elapsed}ms");
      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint("❌ [$methodName] 执行异常，耗时：${stopwatch.elapsedMilliseconds}ms");
      rethrow;
    }
  }
}
