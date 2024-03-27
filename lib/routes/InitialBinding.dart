


import 'package:get/get_instance/src/bindings_interface.dart';


class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => LoginController(LoginRepo()), fenix: true);
    // Get.lazyPut(() => HomeController(HomeRepo()), fenix: true);
  }
}