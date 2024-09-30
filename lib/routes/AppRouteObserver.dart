import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get_navigation/src/routes/observers/route_observer.dart';

class AppRouteObserver {
  AppRouteObserver._();

  //这是个单例
  static final AppRouteObserver _instance = AppRouteObserver._();

  factory AppRouteObserver() => _instance;

  //这是实际上的路由监听
  static final _routeObserver = RouteObserver<ModalRoute<dynamic>>();

  /// 通过单例的get方法轻松获取路由监听器
  RouteObserver<ModalRoute<dynamic>> get routeObserver => _routeObserver;

  /// getx路由监听
  ValueChanged<Routing?>? routingCallback;
}

/// RouteAware混入
mixin RouteAwareMixin<T extends StatefulWidget> on State<T>, RouteAware {
  @override
  void dispose() {
    super.dispose();
    AppRouteObserver().routeObserver.unsubscribe(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppRouteObserver().routeObserver.subscribe(this, ModalRoute.of(context)!);
  }
}

/// 自定义路由监听器
class CustomRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    RouteManager().push(route);
    RouteManager().preRoute = previousRoute;
    RouteManager().logRoutes();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    RouteManager().pop(route);
    RouteManager().preRoute = route;
    RouteManager().logRoutes();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null && newRoute != null) {
      RouteManager().pop(oldRoute);
      RouteManager().push(newRoute);
      RouteManager().preRoute = oldRoute;
      RouteManager().logRoutes();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    RouteManager().pop(route);
    RouteManager().logRoutes();
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    debugPrint("didStartUserGesture: ${[
      route,
      previousRoute
    ].map((e) => e?.settings)}");
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    debugPrint("didStopUserGesture: ");
  }
}

/// 路由堆栈管理器
class RouteManager {
  static final RouteManager _instance = RouteManager._();
  RouteManager._();
  factory RouteManager() => _instance;
  static RouteManager get instance => _instance;

  /// 是都打印日志
  bool isDebug = false;

  /// 路由堆栈
  final List<Route<dynamic>> _routes = [];

  /// 当前路由堆栈
  List<Route<dynamic>> get routes => _routes;

  /// 当前路由名堆栈
  List<String?> get routeNames => routes.map((e) => e.settings.name).toList();

  /// 之前路由
  Route<dynamic>? preRoute;

  /// 当前路由
  String? get preRouteName => preRoute?.settings.name;

  /// 当前路由
  Route<dynamic>? get currentRoute => routes.isEmpty ? null : routes.last;

  /// 当前路由
  String? get current => currentRoute?.settings.name;

  /// 当前路由类型是 PopupRoute
  bool get isPopupOpen => currentRoute is PopupRoute;

  /// 当前路由类型是 DialogRoute
  bool get isDialogOpen => currentRoute is DialogRoute;

  /// 当前路由类型是 ModalBottomSheetRoute
  bool get isSheetOpen => currentRoute is ModalBottomSheetRoute;

  /// 进出堆栈过滤条件(默认仅支持PageRoute, 过滤弹窗)
  bool Function(Route<dynamic> route) filterRoute =
      (route) => route is PageRoute && route.settings.name != null;

  /// 更新回调
  ValueChanged<RouteManager>? onChanged;

  /// 是否存在路由堆栈中
  bool contain(String routeName) {
    return routeNames.contains(routeName);
  }

  /// 路由对应的参数
  Object? getArguments(String routeName) {
    final route = routes.firstWhere((e) => e.settings.name == routeName);
    return route.settings.arguments;
  }

  /// 入栈
  void push(Route<dynamic> route) {
    if (!filterRoute(route)) {
      debugPrint("❌push ${[route.runtimeType, route.settings.name]}");
      return;
    }
    if (_routes.isNotEmpty &&
        _routes.last.settings.name == route.settings.name) {
      return;
    }
    _routes.add(route);
  }

  /// 出栈
  void pop(Route<dynamic> route) {
    if (!filterRoute(route)) {
      return;
    }
    _routes.removeWhere((e) => e.settings.name == route.settings.name);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isDebug'] = isDebug;
    data['routes'] = routes.map((e) => e.toString()).toList();
    data['routeNames'] = routeNames;
    data['preRouteName'] = preRouteName;
    data['current'] = current;
    data['isPopupOpen'] = isPopupOpen;
    data['isDialogOpen'] = isDialogOpen;
    data['isSheetOpen'] = isSheetOpen;

    return data;
  }

  @override
  String toString() {
    const encoder = JsonEncoder.withIndent('  ');
    final descption = encoder.convert(toJson());
    return "$runtimeType: $descption";
  }

  void logRoutes() {
    onChanged?.call(this);
    if (!isDebug) {
      return;
    }
    DLog.d(toString());
  }
}
