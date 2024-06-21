//
//  PhonePermission.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/19 11:40.
//  Copyright © 2023/10/19 shang. All rights reserved.
//


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionUtil {
  /// [源方法]检查权限
  /// permission - Permission.camera/Permission.photos ...
  /// name 权限名称
  static Future<bool> check({
    required Permission permission,
    required String name,
    List<PermissionStatus> statuses = const [
      PermissionStatus.granted,
      PermissionStatus.limited,
    ],
    /// 权限名称
    VoidCallback? onConfirm,
  }) async {
    var status = await permission.status;

    final isGranted = statuses.contains(status);
    if (isGranted) {
      return true;
    }

    Map<Permission, PermissionStatus> statusMap = await [
      permission,
    ].request();

    if (!statuses.contains(statusMap[permission])) {
      // GetDialog.showConfirm(
      //     title: '提示',
      //     message: '$name权限被禁用，请到设置中打开',
      //     confirm: onConfirm ??
      //             () {
      //           Get.back();
      //           openAppSettings();
      //         });
      return false;
    }

    final result = statuses.contains(statusMap[permission]);
    return result;
  }

  /// 检查相册权限
  static Future<bool> checkCamera({VoidCallback? onConfirm}) {
    return PermissionUtil.check(
      permission: Permission.camera,
      name: "摄像头",
      onConfirm: onConfirm,
    );
  }

  /// 检查相册权限
  static Future<bool> checkPhotoAlbum({VoidCallback? onConfirm}) async {
    if ([
      Platform.isIOS,
      Platform.isAndroid
    ].contains(true) == false) {
      return true;
    }

    if (Platform.isIOS) {
      var permission = Permission.photos;
      return PermissionUtil.check(
        permission: permission,
        name: "相册",
        onConfirm: onConfirm,
      );
    }

    var deviceInfo = DeviceInfoPlugin();
    var androidInfo = await deviceInfo.androidInfo;
    // debugPrint('设备信息：$androidInfo');
    int sdkInt = androidInfo.version.sdkInt;
    var permission = sdkInt < 33 ? Permission.storage : Permission.photos;
    return await PermissionUtil.check(
      permission: permission,
      name: "相册",
      onConfirm: onConfirm,
    );
  }

  /// 检查摄像头和麦克风权限
  static Future<bool> checkCameraAndMicrophone() async {
    var cameraStatusIsGranted = await Permission.camera.status.isGranted;
    var microphoneStatusIsGranted =
        await Permission.microphone.status.isGranted;
    if (!cameraStatusIsGranted || !microphoneStatusIsGranted) {
      var statusMap = await [
        Permission.camera,
        Permission.microphone,
      ].request();

      debugPrint('statusMap: $statusMap');
      // 这里针对华为手机，华为手机禁用权限一次之后为永久禁用，去要跳转到设置中打开
      // 安卓手机禁用后，下次还会唤起权限选择
      // if (statuses[Permission.camera] == PermissionStatus.permanentlyDenied &&
      //     statuses[Permission.microphone] == PermissionStatus.permanentlyDenied) {
      //   GetDialog.showConfirm(
      //       title: '提示',
      //       message: '相机和麦克风的权限被禁用，请到设置中打开',
      //       confirm: () {
      //         Get.back();
      //         openAppSettings();
      //       });
      //   return false;
      // }

      if (statusMap[Permission.camera] == PermissionStatus.permanentlyDenied ||
          statusMap[Permission.camera] == PermissionStatus.denied ||
          statusMap[Permission.microphone] == PermissionStatus.permanentlyDenied ||
          statusMap[Permission.microphone] == PermissionStatus.denied) {
        // GetDialog.showConfirm(
        //     title: '提示',
        //     message: '相机/麦克风权限被禁用，请到设置中打开',
        //     confirm: () {
        //       Get.back();
        //       openAppSettings();
        //     });
        return false;
      }

      // if (statuses[Permission.microphone] == PermissionStatus.permanentlyDenied) {
      //   GetDialog.showConfirm(
      //       title: '提示',
      //       message: '麦克风权限被禁用，请到设置中打开',
      //       confirm: () {
      //         Get.back();
      //         openAppSettings();
      //       });
      //   return false;
      // }

      if (statusMap[Permission.camera] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  ///检查麦克风权限
  static Future<bool> checkMicrophone({VoidCallback? onConfirm}) async {
    var microphoneStatusIsGranted =
        await Permission.microphone.status.isGranted;
    if (!microphoneStatusIsGranted) {
      var statusMap = await [
        Permission.microphone,
      ].request();

      if (statusMap[Permission.microphone] == PermissionStatus.permanentlyDenied ||
          statusMap[Permission.microphone] == PermissionStatus.denied) {
        // GetDialog.showConfirm(
        //     title: '提示',
        //     message: '麦克风权限被禁用，请到设置中打开',
        //     confirm: () {
        //       onConfirm?.call();
        //       Get.back();
        //       openAppSettings();
        //     });
        return false;
      }

      if (statusMap[Permission.microphone] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  /// 检查位置权限
  static Future<bool> checkLocation() async {
    final permi = Permission.location;
    var isGranted = await permi.status.isGranted;
    var isPermanentlyDenied = await permi.status.isPermanentlyDenied;
    int getCount = CacheService().getInt("getCount") ?? 0;
    if (!isGranted) {
      Map<Permission, PermissionStatus> statuses = {};
      if (!isPermanentlyDenied) {
        statuses = await [Permission.location].request();
      }

      if (statuses[Permission.location] == PermissionStatus.permanentlyDenied ||
          statuses[Permission.location] == PermissionStatus.denied) {
        CacheService().setInt("getCount", getCount + 1);
        if (getCount > 0) {
          // GetDialog.showConfirm(
          //     title: '提示',
          //     message: '位置权限被禁用，请在设置-应用管理-执业版中开启位置权限，以正常使用定位功能',
          //     confirm: () {
          //       Get.back();
          //       openAppSettings();
          //     },
          //     cancel: () {});
          return false;
        }
      }

      if (statuses[Permission.location] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  /// 检查安装权限
  static Future<bool> checkInstall({VoidCallback? onConfirm}) async{
    Permission permission = Permission.requestInstallPackages;
    return await PermissionUtil.check(
      permission: permission,
      name: "文件管理被禁止安装应用，可在系统设置中修改安装未知应用权限",
      onConfirm: onConfirm,
    );
  }

  /// (文档)文件权限
  static Future<bool> checkDocument() async {
    if (Platform.isIOS) {
      return true;
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    int sdkInt = androidInfo.version.sdkInt;
    Permission permission =
    sdkInt < 33 ? Permission.storage : Permission.photos;
    return check(
      permission: permission,
      name: '文件',
    );
  }

}
