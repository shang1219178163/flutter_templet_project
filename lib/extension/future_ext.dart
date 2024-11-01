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
}
