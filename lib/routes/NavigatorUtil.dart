
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:get/get.dart';

class NavigatorUtil {

  /// 返回登录页
  static toLoginPage() {
    if (Get.currentRoute != APPRouter.loginPage) {
      Get.offAllNamed(APPRouter.loginPage);
    }
  }

  static toPage(String page, ) {
    if (Get.currentRoute != page) {
      Get.toNamed(page);
    }
  }
}