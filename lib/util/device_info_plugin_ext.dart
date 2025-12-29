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
  /// 支持的平台
  static bool get supportPlatforms => [Platform.isIOS, Platform.isAndroid].contains(true);

  /// 获取机器信息
  static FutureOr<T> getDeviceInfo<T>({
    required T Function(IosDeviceInfo iosInfo) iosCb,
    required T Function(AndroidDeviceInfo androidInfo) androidCb,
  }) async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      return iosCb(deviceInfo);
    }
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    return androidCb(deviceInfo);
  }

  /// 是真机
  static FutureOr<bool> isPhysicalDevice() async {
    if (!supportPlatforms) {
      return false;
    }
    return getDeviceInfo(
      iosCb: (v) => v.isPhysicalDevice,
      androidCb: (v) => v.isPhysicalDevice,
    );
  }

  /// 是模拟器
  static FutureOr<bool> isSimulator() async {
    final result = await isPhysicalDevice();
    return !result;
  }

  /// 获取设备Id
  static FutureOr<String> getDeviceId() async {
    if (!supportPlatforms) {
      return "";
    }
    return getDeviceInfo(
      iosCb: (v) => v.identifierForVendor ?? "",
      androidCb: (v) => v.display,
    );
  }

  /// 是pad
  static FutureOr<bool> isPad() async {
    if (!supportPlatforms) {
      return false;
    }

    return getDeviceInfo(
      iosCb: (v) => v.utsname.machine.contains("iPad"),
      androidCb: (v) => v.model.contains("Pad"),
    );
  }
}
