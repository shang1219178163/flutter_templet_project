//
//  AppLifecycleObserver.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/18 14:25.
//  Copyright © 2024/1/18 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/util/debug_log.dart';
import 'package:get/get.dart';

/// app 前后台生命周期函数监听
class AppLifecycleObserver extends WidgetsBindingObserver{

  AppLifecycleObserver({
    required this.onResume,
    required this.onInactive,
    required this.onPause,
    required this.onDetached,
    required this.onHidden,
    this.onStateChange,
  }) {
    // WidgetsBinding.instance.addObserver(this);
  }

  final ValueChanged<AppLifecycleState>? onStateChange;

  final AsyncCallback onResume;
  final AsyncCallback onInactive;
  final AsyncCallback onPause;
  final AsyncCallback onDetached;
  final AsyncCallback onHidden;

  // @mustCallSuper
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // DDLog('${Get.currentRoute} APP状态监听：$state, ${data ?? ""}');
    onStateChange?.call(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        onHidden();
        break;
    }
  }
}

/// app 前后台生命周期函数混入封装
mixin AppLifecycleObserverMixin<T extends StatefulWidget> on State<T>{
  late final _lifecycleObserver = AppLifecycleObserver(
    onResume: onResume,
    onInactive: onInactive,
    onPause: onPause,
    onDetached: onDetach,
    onHidden: onHidden,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  Future<void> onResume() async {
    throw UnimplementedError("❌: $this 未实现 onResume");
  }

  Future<void> onInactive() async {
    // throw UnimplementedError("❌: $this 未实现 onInactive");
  }

  Future<void> onPause() async {
    throw UnimplementedError("❌: $this 未实现 onPause");
  }

  Future<void> onDetach() async {
    throw UnimplementedError("❌: $this 未实现 onDetached");
  }

  Future<void> onHidden() async {
    // throw UnimplementedError("❌: $this 未实现 onHidden");
  }
}