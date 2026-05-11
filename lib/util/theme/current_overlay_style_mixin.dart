import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:route_stack_manager/route_stack_manager.dart';

/// 电池栏颜色单独处理 mixin
mixin CurrentOverlayStyleMixin<T extends StatefulWidget> on State<T> {
  @protected
  SystemUiOverlayStyle get currentOverlayStyle;

  @protected
  SystemUiOverlayStyle get otherOverlayStyle;

  @protected
  bool needOverlayStyleChanged({Route? from, Route? to}) {
    throw UnimplementedError("❌$this Not implemented onRouteListener");
  }

  @override
  void dispose() {
    RouteManager().removeListener(onRouteListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    RouteManager().addListener(onRouteListener);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _onChange(style: currentOverlayStyle);
    // });
  }

  void onRouteListener({Route? from, Route? to}) {
    final fromName = from?.settings.name;
    final toName = to?.settings.name;
    final needChange = needOverlayStyleChanged(from: from, to: to);
    // DLog.d([fromName, toName, needChange].join(" >>> "));
    if (needChange) {
      _onChange(style: currentOverlayStyle);
    } else {
      _onChange(style: otherOverlayStyle, duration: Duration.zero);
    }
  }

  Future<void> _onChange({
    Duration duration = const Duration(milliseconds: 300),
    required SystemUiOverlayStyle style,
  }) async {
    if (duration == Duration.zero) {
      SystemChrome.setSystemUIOverlayStyle(style);
    } else {
      Future.delayed(duration, () {
        SystemChrome.setSystemUIOverlayStyle(style);
      });
    }
    // DLog.d("$this onLight ${duration} ${style.statusBarBrightness?.name}");
  }

  /// 电池栏状态修改(push 到新页面回调)
  void currentOverlayStyleRoutePush() {
    Route? from = RouteManager().pageRoutes[RouteManager().pageRoutes.length - 2];
    Route? to = RouteManager().pageRoutes.last;
    onRouteListener(from: from, to: to);
  }
}
