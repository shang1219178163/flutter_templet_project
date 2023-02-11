import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

abstract class ConnectivityListener {
  void onNetStateChaneged(ConnectivityResult result);
}

class ConnectivityService {
  static ConnectivityService? _instance;

  ConnectivityService._() {
    try {
      _connectivity.onConnectivityChanged.listen((event) {
        for (final listener in listeners) {
          listener.onNetStateChaneged(event);
        }
      });
    } catch (e, trace) {
      Log.error('ConnectivityService', e, trace);
    }
  }

  static ConnectivityService get instance => _shareInstance();

  static ConnectivityService _shareInstance() {
    _instance ??= ConnectivityService._();
    return _instance!;
  }

  final Connectivity _connectivity = Connectivity();
  final List<ConnectivityListener> listeners = [];

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
    try {
      if (connectivityListener != null) {
        ConnectivityService.instance.removeListener(connectivityListener!);
      }
    } catch (e) {
      log("remove error occur on init state auto listener connect!");
    }
    if (connectivityListener != null) {
      ConnectivityService.instance.addListener(connectivityListener!);
    }
    super.initState();
  }

  void onNetStateChaneged(ConnectivityResult result);

  @override
  void dispose() {
    try {
      if (connectivityListener != null) {
        ConnectivityService.instance.removeListener(connectivityListener!);
      }
    } catch (e) {
      log("remove error occur on dispose state auto listener connect!");
    }
    super.dispose();
  }

  ConnectivityListener? get connectivityListener;
}
