
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/observers/route_observer.dart';

/// 路由监听工具类
class RouteService{

  /// 路由监听
  // static final routeObserver = RouteObserver<PageRoute>();
  static final routeObserver = RouteObserver<ModalRoute>();

  /// getx路由监听
  static ValueChanged<Routing?>? routingCallback;

}

/// RouteAware混入
mixin RouteAwareMixin<T extends StatefulWidget> on State<T> {

  @override
  void dispose() {
    super.dispose();
    RouteService.routeObserver.unsubscribe(this as RouteAware);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RouteService.routeObserver.subscribe(this as RouteAware, ModalRoute.of(context)!);
  }

  @override
  void didPush() {
    debugPrint('$widget didPush');
  }

  @override
  void didPop() {
    debugPrint('$widget didPop');
  }

  @override
  void didPopNext() {
    debugPrint('$widget didPopNext');
  }

  @override
  void didPushNext() {
    debugPrint('$widget didPushNext');
  }
}

