//
//  AppLifecycleObserver.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/18 14:25.
//  Copyright © 2024/1/18 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

/// app 前后台生命周期函数监听
class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver({
    required this.onResume,
    required this.onInactive,
    required this.onPause,
    required this.onDetach,
    required this.onHidden,
    this.onStateChanged,
  }) {
    // WidgetsBinding.instance.addObserver(this);
  }

  final ValueChanged<AppLifecycleState>? onStateChanged;

  /// 切回前台(App 处于具有输入焦点且可见的正在运行的状态。)
  final VoidCallback onResume;

  /// 切至后台(在 Android 和 iOS 上， inactive 可以认为它们马上会进入 hidden 和 paused 状态。)
  final VoidCallback onInactive;

  /// 切至后台(App 当前对用户不可见，并且不响应用户行为。)
  final VoidCallback onPause;

  /// 销毁页面(般不严谨要求的情况下，可以简单用于退出 App 的状态监听。)
  final VoidCallback onDetach;
  final VoidCallback onHidden;

  // @mustCallSuper
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // DDLog('${Get.currentRoute} APP状态监听：$state, ${data ?? ""}');
    if (onStateChanged != null) {
      onStateChanged?.call(state);
      return;
    }

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
        onDetach();
        break;
      case AppLifecycleState.hidden:
        onHidden();
        break;
    }
  }
}

/// app 前后台生命周期函数混入封装
mixin AppLifecycleObserverMixin<T extends StatefulWidget> on State<T> {
  late final _lifecycleObserver = AppLifecycleObserver(
    onStateChanged: onAppLifecycleStateChanged,
    onResume: onResume,
    onInactive: onInactive,
    onPause: onPause,
    onDetach: onDetach,
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

  void onAppLifecycleStateChanged(AppLifecycleState state) {
    // debugPrint('onStateChanged didChangeAppLifecycleState state');
  }

  void onResume() {
    // throw UnimplementedError("❌: $this 未实现 onResume");
  }

  void onInactive() {
    // throw UnimplementedError("❌: $this 未实现 onInactive");
  }

  void onPause() {
    // throw UnimplementedError("❌: $this 未实现 onPause");
  }

  void onDetach() {
    // throw UnimplementedError("❌: $this 未实现 onDetached");
  }

  void onHidden() {
    // throw UnimplementedError("❌: $this 未实现 onHidden");
  }
}
