
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/routes/RouteService.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:get/get.dart';

/// 路由监听
class AppRouteObserverDemo extends StatefulWidget {

  AppRouteObserverDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _AppRouteObserverDemoState createState() => _AppRouteObserverDemoState();
}

class _AppRouteObserverDemoState extends State<AppRouteObserverDemo> with RouteAware {

  @override
  void dispose() {
    RouteService.routeObserver.unsubscribe(this); //取消订阅
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    RouteService.routeObserver.subscribe(this, ModalRoute.of(context)!); //订阅
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
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(APPRouter.alertSheetDemo);
              },
              child: Text("next"),
            ),
          ],
        )
      )
    );
  }


}