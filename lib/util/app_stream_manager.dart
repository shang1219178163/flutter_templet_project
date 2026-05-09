//
//  AppStreamManager.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/9 10:39.
//  Copyright © 2026/5/9 shang. All rights reserved.
//

import 'dart:async';
import 'package:flutter/widgets.dart';

class AppStreamManager {
  static final _controller = StreamController<Map<String, dynamic>>.broadcast();

  /// 发送事件
  static void emit(Map<String, dynamic> data) {
    _controller.add(data);
  }

  /// 监听事件
  static Stream<Map<String, dynamic>> get stream => _controller.stream;

  static void dispose() {
    _controller.close();
  }
}

class AppEventManager {
  static StreamSubscription? _subscription;

  static void init() {
    dispose();
    _subscription = AppStreamManager.stream.listen((e) {
      debugPrint("收到全局点击事件: $e");

      /// 埋点
      /// 上传服务器
      /// 行为统计
      /// 路由跳转
    });
  }

  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
