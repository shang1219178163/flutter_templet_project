//
//  EasyListenster.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/5 11:16.
//  Copyright © 2024/5/5 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

/// 自定义个监听触发类
class EasyNotifier {
  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) {
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    for (final entry in _listeners) {
      if (entry == listener) {
        _listeners.remove(entry);
        return;
      }
    }
  }

  void notify() {
    for (final entry in _listeners) {
      entry.call();
    }
  }

  void dispose() {
    _listeners.clear();
  }
}

class EasyNotifierController {
  final notifier = EasyNotifier();

  ///刷新控件
  void update() {
    notifier.notify();
  }
}
