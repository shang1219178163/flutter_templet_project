import 'package:flutter_templet_project/pages/app_tab_bar_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppTabBarController(), permanent: true);
    // Get.lazyPut(() => LoginController(LoginRepo()), fenix: true);
    // Get.lazyPut(() => HomeController(HomeRepo()), fenix: true);
  }
}
