import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';

// example:
// EventBusService().fire(UnreadMessageChangeEvent<List<V2TimConversation>>(<V2TimConversation>[]));

// EventBusService().on<UnreadMessageChangeEvent>().listen((event) {
//   debugPrint("listenEventOn:${event.data}");
// });

// listenEventOn<UnreadMessageChangeEvent>((event) {
//   debugPrint("listenEventOn:${event.data}");
// });


class EventBusService {
  EventBusService._();

  static final EventBusService _instance = EventBusService._();

  factory EventBusService() => _instance;

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
mixin EventBusServiceListenerMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription? subscription;

  listenEventOn<E>(
    void Function(E)? onData,
  {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError
  }) {
    subscription = EventBusService().on<E>().listen(
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