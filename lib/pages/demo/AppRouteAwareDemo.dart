import 'package:flutter/material.dart';
import 'package:flutter_templet_project/routes/AppRouteObserver.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';

/// 路由监听
class AppRouteAwareDemo extends StatefulWidget {
  AppRouteAwareDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AppRouteAwareDemoState createState() => _AppRouteAwareDemoState();
}

class _AppRouteAwareDemoState extends State<AppRouteAwareDemo> with RouteAware {
  @override
  void dispose() {
    AppRouteObserver().routeObserver.unsubscribe(this); //取消订阅
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    AppRouteObserver().routeObserver.subscribe(this, ModalRoute.of(context)!); //订阅
    super.didChangeDependencies();
  }

  @override
  void didPush() {
    debugPrint("------> $widget didPush");
    super.didPush();
  }

  @override
  void didPop() {
    debugPrint("------> $widget didPop");
    super.didPop();
  }

  @override
  void didPushNext() {
    debugPrint("------> $widget didPushNext");
    super.didPushNext();
  }

  @override
  void didPopNext() {
    debugPrint("------> $widget didPopNext");
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => debugPrint(e),
                  ))
              .toList(),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRouter.alertSheetDemo);
              },
              child: Text("next"),
            ),
          ],
        )));
  }
}
