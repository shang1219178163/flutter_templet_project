import 'package:flutter/material.dart';
import 'package:flutter_templet_project/routes/AppRouteObserver.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';

/// 路由监听
class AppRouteAwareDemoOne extends StatefulWidget {
  AppRouteAwareDemoOne({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AppRouteAwareDemoOneState createState() => _AppRouteAwareDemoOneState();
}

class _AppRouteAwareDemoOneState extends State<AppRouteAwareDemoOne> with RouteAware, RouteAwareMixin {
  @override
  void dispose() {
    debugPrint("------> $widget dispose");
    super.dispose();
  }

  @override
  void initState() {
    debugPrint("------> $widget initState");
    super.initState();
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
