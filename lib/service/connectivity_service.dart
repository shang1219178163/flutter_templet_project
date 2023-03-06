import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

abstract class ConnectivityListener {
  void onNetStateChaneged(ConnectivityResult result);
}

class ConnectivityService {
  static ConnectivityService? _instance;

  ConnectivityService._() {
    try {
      _connectivity.onConnectivityChanged.listen((event) {
        netState.value = event;
        onLine.value = (event != ConnectivityResult.none);
        for (final listener in listeners) {
          listener.onNetStateChaneged(event);
        }
      });
    } catch (e, trace) {
      // Log.error('ConnectivityService', e, trace);
    }
  }

  static ConnectivityService get instance => _shareInstance();

  static ConnectivityService _shareInstance() {
    _instance ??= ConnectivityService._();
    return _instance!;
  }

  final Connectivity _connectivity = Connectivity();
  final List<ConnectivityListener> listeners = [];
  /// 网络当前状态(wifi, mobile, none); 可通过 ValueListenableBuilder 监听网络状态改变
  final netState = ValueNotifier<ConnectivityResult>(ConnectivityResult.mobile);
  /// 是否联网; 可通过 ValueListenableBuilder 监听网络状态改变
  final onLine = ValueNotifier<bool>(true);

  Future<ConnectivityResult> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }

  addListener(ConnectivityListener? listener) {
    if (listener != null) {
      listeners.add(listener);
    }
  }

  removeListener(ConnectivityListener? listener) {
    if (listener != null) {
      listeners.remove(listener);
    }
  }

  clearListener() {
    listeners.clear();
  }
}


mixin AutoListenerConnection<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    ConnectivityService.instance.removeListener(connectivityListener);
    ConnectivityService.instance.addListener(connectivityListener);

    super.initState();
  }

  void onNetStateChaneged(ConnectivityResult result);

  @override
  void dispose() {
    ConnectivityService.instance.removeListener(connectivityListener);

    super.dispose();
  }

  ConnectivityListener? get connectivityListener;
}
