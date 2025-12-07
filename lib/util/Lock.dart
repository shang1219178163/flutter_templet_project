import 'dart:async';

/// Add lock/unlock API for interceptors.
class Lock {
  Future? _lock;

  late Completer _completer;

  /// 标识拦截器是否被上锁
  bool get locked => _lock != null;

  /// Lock the interceptor.
  ///
  ///一旦请求/响应拦截器被锁，后续传入的请求/响应拦截器将被添加到队列中，它们将不会
  ///继续，直到拦截器解锁
  void lock() {
    if (!locked) {
      _completer = Completer();
      _lock = _completer.future;
    }
  }

  /// Unlock the interceptor. please refer to [lock()]
  void unlock() {
    if (locked) {
      //调用complete()
      _completer.complete();
      _lock = null;
    }
  }

  /// Clean the interceptor queue.
  void clear([String msg = 'cancelled']) {
    if (locked) {
      //complete[future] with an error
      _completer.completeError(msg);
      _lock = null;
    }
  }

  /// If the interceptor is locked, the incoming request/response task
  /// will enter a queue.
  ///
  /// [callback] the function  will return a `Future`
  /// @nodoc
  Future? enqueue(EnqueueCallback callback) {
    if (locked) {
      // we use a future as a queue
      return _lock!.then((d) => callback());
    }
    return null;
  }
}
