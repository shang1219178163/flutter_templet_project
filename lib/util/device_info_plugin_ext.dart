//
//  DeviceInfoPluginExt.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/5/30 14:22.
//  Copyright © 2024/5/30 shang. All rights reserved.
//

import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

extension DeviceInfoPluginExt on DeviceInfoPlugin {
  /// 是真机(true)
  FutureOr<bool> isPhysicalDevice() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (!Platform.isIOS && !Platform.isAndroid) {
      return true;
    }

    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      return deviceInfo.isPhysicalDevice;
    }

    final deviceInfo = await deviceInfoPlugin.androidInfo;
    return deviceInfo.isPhysicalDevice;
  }
}
