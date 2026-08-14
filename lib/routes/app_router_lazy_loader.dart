import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/routes/app_router_lazy.dart' deferred as lazy;
import 'package:get/get.dart';

/// Lazily loads demo GetPages so startup / hot restart does not compile the full demo graph.
class AppRouterLazyLoader {
  AppRouterLazyLoader._();

  static bool _ready = false;
  static Future<void>? _loading;
  static final Set<String> _routeNames = <String>{};

  static bool get isReady => _ready;

  static bool hasRoute(String name) => _routeNames.contains(name);

  static Future<void> ensure() {
    if (_ready && _routeInTree()) {
      return Future.value();
    }
    if (_ready && !_routeInTree()) {
      // Hot reload / routeTree cleared: force re-register.
      _ready = false;
    }
    return _loading ??= _load();
  }

  static Future<void> _load() async {
    try {
      await lazy.loadLibrary();
      final pages = lazy.AppRouterLazy.pages;
      final existing = Get.routeTree.routes.map((e) => e.name).toSet();
      final toAdd = pages.where((p) => !existing.contains(p.name)).toList();
      if (toAdd.isNotEmpty) {
        Get.addPages(toAdd);
      }
      _routeNames
        ..clear()
        ..addAll(pages.map((e) => e.name));
      _ready = true;
    } catch (e, s) {
      debugPrint('AppRouterLazyLoader: failed to load lazy routes: $e\n$s');
      rethrow;
    } finally {
      // Allow retry after failure (or clear in-flight handle after success).
      _loading = null;
    }
  }

  /// 抽样检查 GetX [Get.routeTree] 是否仍持有已注册的 lazy 路由。
  ///
  /// 热重载或 [Get.clearRouteTree] 后，[_ready] 可能仍为 true，但树已被清空；
  /// 用首个路由名做存在性探测，避免误判为已注册而跳过 [ensure]。
  static bool _routeInTree() {
    if (_routeNames.isEmpty) {
      return false;
    }
    final sample = _routeNames.first;
    return Get.routeTree.routes.any((r) => r.name == sample);
  }
}
