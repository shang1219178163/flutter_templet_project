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
