

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// app 激活挂起监听
class LifecycleService {
  // final AsyncCallback? onActive;
  // final AsyncCallback? onInactive;

  LifecycleService({
    required AsyncCallback? onActive,
    required AsyncCallback? onInactive,
  }) {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      switch (msg) {
        case "AppLifecycleState.resumed":
          await onActive?.call();
          break;
        case "AppLifecycleState.paused":
        case "AppLifecycleState.detached":
        case "AppLifecycleState.inactive":
          await onInactive?.call();
          break;
        default:
          break;
      }
    });
  }
}

