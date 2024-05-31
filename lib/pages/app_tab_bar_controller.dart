import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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

  // /// 返回 appTabPage
  // void backTabPage() {
  //   Get.until((route) => route.settings.name == APPRouter.appTabPage);
  // }
}
