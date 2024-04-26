

import 'package:get/get.dart';


class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({required this.newRouteCb});

  final String Function(GetNavConfig route) newRouteCb;

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    // you can do whatever you want here
    // but it's preferable to make this method fast
    // await Future.delayed(Duration(milliseconds: 500));

    final newRoute = newRouteCb(route);
    if (newRoute.isNotEmpty) {
      return GetNavConfig.fromRoute(newRoute);
    }
    return super.redirectDelegate(route);
  }

}
