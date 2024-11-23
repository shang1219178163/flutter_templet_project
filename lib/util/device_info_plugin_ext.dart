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
  /// 是否是模拟器
  static FutureOr<bool> isSimulator() async {
    final result = await isPhysicalDevice();
    return !result;
  }

  /// 是真机
  static FutureOr<bool> isPhysicalDevice() async {
    final supports = [Platform.isIOS, Platform.isAndroid];
    if (!supports.contains(true)) {
      return false;
    }

    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      return deviceInfo.isPhysicalDevice;
    }

    final deviceInfo = await deviceInfoPlugin.androidInfo;
    return deviceInfo.isPhysicalDevice;
  }

  /// 是pad
  static FutureOr<bool> isPad() async {
    final supports = [Platform.isIOS, Platform.isAndroid];
    if (!supports.contains(true)) {
      return false;
    }

    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      return deviceInfo.utsname.machine.contains("iPad");
    }

    final deviceInfo = await deviceInfoPlugin.androidInfo;
    return deviceInfo.model.contains("Pad");
  }
}
