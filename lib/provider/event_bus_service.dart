import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:event_bus/event_bus.dart';


class EventBusService {
  EventBusService._();

  static EventBusService _instance = EventBusService._();

  factory EventBusService() => _instance;

  static EventBusService get instance => _instance;

  // static EventBusService _shareInstance() {
  //   _instance ??= EventBusService._();
  //   return _instance!;
  // }

  final EventBus _eventBus = EventBus();

  /// 触发事件
  fire(event) {
    _eventBus.fire(event);
  }

  /// 监听事件
  Stream<T> on<T>() {
    return _eventBus.on<T>();
  }

  void destroy() {
    _eventBus.destroy();
  }
}

/// 监听方法封装
mixin EventBusServiceListener<T extends StatefulWidget> on State<T> {
  StreamSubscription? subscription;

  listenEventOn<E>(
    void Function(E)? onData,
  {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError
  }) {
    subscription = EventBusService.instance.on<E>().listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }
}