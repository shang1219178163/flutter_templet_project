import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class AppTabBarState<T extends StatefulWidget> extends State<T> {
  /// tab bar item 单击回调
  @mustCallSuper
  void onBarTap(int index);

  /// tab bar item 双击回调
  @protected
  void onBarDoubleTap(int index) {}
}

class AppTabBarController extends GetxController {
  // late final messageController = Get.find<MessageController>();
  // late final userController = Get.find<UserController>();

  /// 全局 app 前后台切换
  var appState = AppLifecycleState.resumed.obs;

  /// 返回 appTabPage
  void backTabPage() {
    Get.until((route) => route.settings.name == APPRouter.appTabPage);
  }

  // 获取应用版本信息并存储
  Future<PackageInfo> getPackageInfo() async {
    var info = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;// 医链健康执业版
    // String packageName = packageInfo.packageName;// com.yilian.ylHealthApp
    // String version = packageInfo.version;// 1.0.0
    // String buildNumber = packageInfo.buildNumber;//1
    // debugPrint("packageInfo: ${packageInfo.toString()}");

    await CacheService().setString(CACHE_APP_NAME, info.appName);
    await CacheService().setString(CACHE_APP_PACKAGE_NAME, info.packageName);
    await CacheService().setString(CACHE_APP_VERSION, info.version);
    return Future.value(info);
  }

  /// 获取 devTool 链接 serverUri
  FutureOr<Uri?> getObservatoryUri() async {
    final serviceProtocolInfo = await Service.getInfo();
    final serverUri = serviceProtocolInfo.serverUri;
    final serverWebSocketUri = serviceProtocolInfo.serverWebSocketUri;
    // ddlog("serverUri: $serverUri");
    // ddlog("serverWebSocketUri: $serverWebSocketUri");
    return serverUri;
  }
}
