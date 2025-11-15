import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({this.newRouteCb});

  final String Function(GetNavConfig route)? newRouteCb;

  // @override
  // RouteSettings? redirect(String? route) {
  //   DLog.d("$runtimeType redirect: ${[
  //     Get.arguments,
  //     Get.parameters,
  //     Get.rootDelegate.arguments(),
  //   ]}");
  //   bool isLogin = false;
  //   if (!isLogin) {
  //     // 如果未登录，重定向到登录页面
  //     return RouteSettings(
  //         name: AppRouter.aeReportPage, arguments: Get.arguments);
  //   }
  //   return null; // 继续访问原始路由
  // }

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    DLog.d("$runtimeType redirectDelegate: ${[
      Get.arguments,
      Get.parameters,
      Get.rootDelegate.arguments(),
    ]}");
    final args = route.currentPage?.arguments as Map<String, dynamic>?;

    // Check if arguments are as expected
    if (args != null) {
      bool isAuthorized = args['isAuthorized'] ?? false;

      if (!isAuthorized) {
        // If not authorized, redirect to an unauthorized page
        return GetNavConfig.fromRoute('/unauthorized');
      }
    }

    // Allow navigation if arguments are valid or not present
    return super.redirectDelegate(route);
  }
}
