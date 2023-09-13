import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

abstract class NetConnectivityListener {
  void onNetStateChaneged(ConnectivityResult result);
}

class ConnectivityService {

  ConnectivityService._() {
    try {
      _connectivity.onConnectivityChanged.listen((event) {
        debugPrint(">>> ConnectivityService: $event");
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

  static final ConnectivityService _instance = ConnectivityService._();

  factory ConnectivityService() => _instance;

  // static ConnectivityService get instance => _instance;

  final Connectivity _connectivity = Connectivity();

  final listeners = <NetConnectivityListener>[];
  /// 网络当前状态(wifi, mobile, none); 可通过 ValueListenableBuilder 监听网络状态改变
  final netState = ValueNotifier<ConnectivityResult>(ConnectivityResult.mobile);
  /// 是否联网; 可通过 ValueListenableBuilder 监听网络状态改变
  final onLine = ValueNotifier<bool>(true);

  Future<ConnectivityResult> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }

  addListener(NetConnectivityListener? listener) {
    if (listener != null) {
      listeners.add(listener);
    }
  }

  removeListener(NetConnectivityListener? listener) {
    if (listener != null) {
      listeners.remove(listener);
    }
  }

  clearListeners() {
    listeners.clear();
  }
}


mixin NetConnectivityMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    ConnectivityService().removeListener(connectivityListener);
    ConnectivityService().addListener(connectivityListener);

    super.initState();
  }

  void onNetStateChaneged(ConnectivityResult result);

  @override
  void dispose() {
    ConnectivityService().removeListener(connectivityListener);

    super.dispose();
  }

  NetConnectivityListener get connectivityListener;
}