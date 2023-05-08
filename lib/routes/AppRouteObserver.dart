import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppRouteObserver {
  AppRouteObserver._();

  //这是个单例
  static final AppRouteObserver _instance = AppRouteObserver._();

  factory AppRouteObserver() => _instance;

  //这是实际上的路由监听
  static final _routeObserver = RouteObserver<ModalRoute<dynamic>>();

  //通过单例的get方法轻松获取路由监听器
  RouteObserver<ModalRoute<dynamic>> get routeObserver => _routeObserver;

  // //getx路由监听
  // final ValueChanged<Routing?>? getRoutingCallback = (routing) {
  //
  // }

}