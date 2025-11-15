//
//  SystemChromeExt.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/13 21:55.
//  Copyright © 2024/6/13 shang. All rights reserved.
//

import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

extension SystemChromeExt on SystemChrome {
  // 强制竖屏
  static Future<void> setDeviceOrientationPortrait() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
