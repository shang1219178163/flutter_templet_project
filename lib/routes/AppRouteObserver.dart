import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/route_ext.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:get/get.dart';
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

  static Future<void> routingCallback(Routing? routing) async {
    if (routing == null) {
      return;
    }
    if (routing.route?.settings.name == AppPage.INITIAL) {
      return;
    }

    /// 缓存退出前最后一次路由页面
    await CacheService().setMap(CacheKey.lastPageRoute.name, routing.route?.settings.toJson());
    // DLog.d([routing.route?.settings.toJson(), CacheService().getMap(CacheKey.lastPageRoute.name)].asMap());
  }

  /// 恢复路由
  static Future<void> resetRoute() async {
    final lastRouteInfo = CacheService().getMap(CacheKey.lastPageRoute.name);
    final settings = RouteSettingsExt.fromJson(lastRouteInfo);
    if (AppPage.routes.firstWhereOrNull((e) => e.name == settings.name) == null) {
      return;
    }
    await Get.toNamed(settings.name!, arguments: settings.arguments);
  }
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
