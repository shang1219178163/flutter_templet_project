//
//  OrientationExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/10/13 14:01.
//  Copyright © 2024/10/13 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

extension OrientationExt on Orientation {
  /// 进入横屏模式
  static setScreenLandscape(BuildContext context, {int milliseconds = 300}) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return;
    }

    Future.delayed(Duration(milliseconds: milliseconds), () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    });
  }

  /// 进入竖屏模式
  static setScreenPortrait(BuildContext context, {int milliseconds = 0}) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return;
    }

    Future.delayed(Duration(milliseconds: milliseconds), () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    });
  }

  /// 横竖切换
  static screenToggle(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final orientations = orientation == Orientation.portrait
        ? [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]
        : [DeviceOrientation.portraitUp];
    SystemChrome.setPreferredOrientations(orientations);
  }
}
