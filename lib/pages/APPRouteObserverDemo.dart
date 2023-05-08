




import 'package:flutter/material.dart';
import 'package:flutter_templet_project/routes/AppRouteObserver.dart';

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

  final message = "用 getX管理路由时, RouteAware 会失效;请使用 routingCallback 拦截";

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
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

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
      body: Text(message)
    );
  }


}