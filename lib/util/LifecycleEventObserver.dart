//
//  LifecycleEventObserver.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/18 14:25.
//  Copyright © 2024/1/18 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/util/debug_log.dart';
import 'package:get/get.dart';


class LifecycleEventObserver extends WidgetsBindingObserver{

  LifecycleEventObserver({
    required this.onResume,
    required this.onInactive,
    required this.onPause,
    required this.onDetached,
    this.data,
  });

  final AsyncCallback onResume;
  final AsyncCallback onInactive;
  final AsyncCallback onPause;
  final AsyncCallback onDetached;
  final dynamic data;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    DDLog('${Get.currentRoute} APP状态监听：$state, ${data ?? ""}');

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
    }
  }
}


mixin LifecycleEventObserverMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver{
  late final _lifecycleEvent = LifecycleEventObserver(
    onResume: onResume,
    onInactive: onInactive,
    onPause: onPause,
    onDetached: onDetached,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleEvent);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleEvent);
    super.dispose();
  }

  Future<void> onResume() async {
    throw UnimplementedError();
  }

  Future<void> onInactive() async {
    throw UnimplementedError();
  }

  Future<void> onPause() async {
    throw UnimplementedError();
  }

  Future<void> onDetached() async {
    throw UnimplementedError();
  }

}