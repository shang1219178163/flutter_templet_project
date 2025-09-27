import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectionService {
  InternetConnectionService._() {
    try {
      _createChecker().onStatusChange.listen((event) {
        var connected = switch (event) {
          InternetConnectionStatus.connected => true,
          InternetConnectionStatus.disconnected => false,
        };
        onLine.value = connected;
      });
    } catch (e, trace) {
      debugPrint(
        '❌ ConnectivityService: $e, $trace',
      );
    }
  }

  static final _instance = InternetConnectionService._();

  factory InternetConnectionService() => _instance;

  /// 是否联网; 可通过 ValueListenableBuilder 监听网络状态改变
  final onLine = ValueNotifier<bool>(true);

  InternetConnectionChecker _createChecker() =>
      InternetConnectionChecker.createInstance(
        checkTimeout: const Duration(seconds: 3),
        checkInterval: const Duration(seconds: 3),
        addresses: [
          AddressCheckOptions(
            address: InternetAddress(
              '114.114.114.114', // CloudFlare
              type: InternetAddressType.IPv4,
            ),
          ),
          ...InternetConnectionChecker.DEFAULT_ADDRESSES,
        ],
      );

  // StreamSubscription<InternetConnectionStatus>? _listener;

  final listeners = <InternetConnectionListener>[];

  addListener(InternetConnectionListener? listener) {
    if (listener != null) {
      listeners.add(listener);
    }
  }

  removeListener(InternetConnectionListener? listener) {
    if (listener != null) {
      listeners.remove(listener);
    }
  }

  clearListeners() {
    listeners.clear();
  }
}

abstract class InternetConnectionListener {
  void onNetStateChaneged(ConnectivityResult result);
}

mixin InternetConnectionMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    InternetConnectionService().removeListener(connectionListener);
    InternetConnectionService().addListener(connectionListener);

    super.initState();
  }

  void onNetStateChaneged(ConnectivityResult result);

  @override
  void dispose() {
    InternetConnectionService().removeListener(connectionListener);

    super.dispose();
  }

  InternetConnectionListener get connectionListener;
}
