//
//  AppLifecycleStateMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/14 09:18.
//  Copyright © 2024/9/14 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/app_tab_bar_controller.dart';
import 'package:get/get.dart';

/// 通过 GetX obs
mixin AppLifecycleStateMixin<T extends StatefulWidget> on State<T> {
  final _appTabBarController = Get.find<AppTabBarController>();

  // 前后台切换监听器
  late StreamSubscription? _appStateSubscription;

  // 切后台切换回调
  late Function(AppLifecycleState state) appLifecycleStateChanged;

  @override
  void initState() {
    // 前后台切换监听
    _appStateSubscription =
        _appTabBarController.appState.listen(appLifecycleStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    // 移除监听器
    _appStateSubscription?.cancel();
    super.dispose();
  }
}

/// 通过 ValueNotifier
mixin AppLifecycleStateMixinOne<T extends StatefulWidget> on State<T> {
  final _appTabBarController = Get.find<AppTabBarController>();

  // 切后台切换回调
  late Function(AppLifecycleState state) appLifecycleStateChanged;

  @override
  void dispose() {
    _appTabBarController.appStateVN.removeListener(appLifecycleListener);
    super.dispose();
  }

  @override
  void initState() {
    _appTabBarController.appStateVN.addListener(appLifecycleListener);
    super.initState();
  }

  void appLifecycleListener() {
    final state = _appTabBarController.appStateVN.value;
    appLifecycleStateChanged(state);
  }
}

/// 通过 WidgetsBindingObserver
mixin AppLifecycleStateOriginMixin<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  /// AppLifecycleState 改变回调
  late void Function(AppLifecycleState state) appLifecycleStateChanged;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleStateChanged(state);
  }
}
