import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:get/get.dart';

class AppUtil {
  // AppUtil._();
  //
  // static final AppUtil _instance = AppUtil._();
  //
  // factory AppUtil() => _instance;
  //
  // init() async {
  //   // debugPrint("init: $prefs");
  // }

  // 创建一个全局的GlobalKey
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  // 全局获取context
  static BuildContext getGlobalContext() {
    return navigatorKey.currentState!.overlay!.context;
  }

  // 移除输入框焦点
  static void removeInputFocus() {
    FocusManager.instance.primaryFocus?.unfocus();

    // // 延迟，保证获取到context
    // Future.delayed(Duration.zero, () {
    //   FocusScope.of(getGlobalContext()).requestFocus(FocusNode());
    // });
  }

  /// 返回登录页
  static toLoginPage() {
    if (Get.currentRoute != APPRouter.loginPage) {
      Get.offAllNamed(APPRouter.loginPage);
    }
  }

  static toPage(
    String page,
  ) {
    if (Get.currentRoute != page) {
      Get.toNamed(page);
    }
  }
}
