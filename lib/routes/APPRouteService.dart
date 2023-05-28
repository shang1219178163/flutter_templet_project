
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/observers/route_observer.dart';

/// 路由监听工具类
class APPRouteService{

  /// 路由监听
// static RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  static RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

  /// getx路由监听
  static ValueChanged<Routing?>? routingCallback;

}


