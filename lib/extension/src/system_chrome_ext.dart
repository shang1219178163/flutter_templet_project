//
//  SystemChromeExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/13 21:55.
//  Copyright © 2024/6/13 shang. All rights reserved.
//

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

extension SystemChromeExt on SystemChrome {
  /// 改变设备方向
  static Future<void> changeDeviceFullScreen({required bool isPortrait}) async {
    if (!isPortrait) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  /// 进入横屏模式
  static setOrientationLandscape({int milliseconds = 300}) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    });
  }

  /// 进入竖屏模式
  static setOrientationPortrait({int milliseconds = 0}) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    });
  }

  /// 横竖切换
  static toggleOrientation() {
    final current = WidgetsBinding.instance.platformDispatcher.views.first;
    Size screenSize = current.physicalSize / current.devicePixelRatio;
    final isPortrait = screenSize.height > screenSize.width;
    if (isPortrait) {
      setOrientationLandscape();
    } else {
      setOrientationPortrait();
    }
  }
}
