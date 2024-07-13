import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetConnectivityListener {
  void onNetStateChaneged(bool onLine);
}

class ConnectivityService {
  ConnectivityService._() {
    try {
      _listener = _connectivity.onConnectivityChanged.listen((result) async {
        _changedOnline(result);
      });
    } catch (e, trace) {
      debugPrint(
        '❌ ConnectivityService: $e, $trace',
      );
    }
  }

  static final ConnectivityService _instance = ConnectivityService._();

  factory ConnectivityService() => _instance;

  // static ConnectivityService get instance => _instance;

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _listener;

  final _listeners = <NetConnectivityListener>[];

  /// 网络当前状态(wifi, mobile, none); 安卓手机不准,推荐使用 onLine
  final netState = ValueNotifier<ConnectivityResult>(ConnectivityResult.mobile);

  /// 是否联网; 可通过 ValueListenableBuilder 监听网络状态改变
  final onLine = ValueNotifier<bool>(true);

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return _changedOnline(result);
  }

  Future<bool> _changedOnline(ConnectivityResult result) async {
    debugPrint(">>> ConnectivityService: $result");
    // netState.value = result;
    onLine.value = [
      ConnectivityResult.wifi,
      ConnectivityResult.ethernet,
      ConnectivityResult.mobile,
      ConnectivityResult.vpn,
    ].contains(result);
    // for (final listener in listeners) {
    //   listener.onNetStateChaneged(result);
    // }
    if (result != ConnectivityResult.none) {
      onLine.value = await InternetConnectionChecker().hasConnection;
    } else {
      onLine.value = false;
    }
    return onLine.value;
  }

  void cancel() {
    _listener?.cancel();
  }

  addListener(NetConnectivityListener? listener) {
    if (listener != null) {
      _listeners.add(listener);
    }
  }

  removeListener(NetConnectivityListener? listener) {
    if (listener != null) {
      _listeners.remove(listener);
    }
  }

  clearListeners() {
    _listeners.clear();
  }
}

mixin NetConnectivityMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    ConnectivityService().removeListener(connectivityListener);
    ConnectivityService().addListener(connectivityListener);

    super.initState();
  }

  void onNetStateChaneged(bool onLine);

  @override
  void dispose() {
    ConnectivityService().removeListener(connectivityListener);

    super.dispose();
  }

  NetConnectivityListener get connectivityListener;
}
