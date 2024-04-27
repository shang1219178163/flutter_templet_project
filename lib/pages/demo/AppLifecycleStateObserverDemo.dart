

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/AppLifecycleObserver.dart';
import 'package:flutter_templet_project/util/debug_log.dart';

class AppLifecycleStateObserverDemo extends StatefulWidget {

  AppLifecycleStateObserverDemo({
    super.key, 
    this.title
  });

  final String? title;

  @override
  State<AppLifecycleStateObserverDemo> createState() => _AppLifecycleStateObserverDemoState();
}

class _AppLifecycleStateObserverDemoState extends State<AppLifecycleStateObserverDemo> with
    AppLifecycleObserverMixin {

  final _scrollController = ScrollController();

  late AppLifecycleListener _lifecycleListener;

  @override
  void dispose() {
    // TODO: implement dispose
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _lifecycleListener = AppLifecycleListener(
      onRestart: (){
        ddLog("$widget onRestart - AppLifecycleListener");
      },
      onResume: (){
        ddLog("$widget onResume - AppLifecycleListener");
      },
      onInactive: (){
        ddLog("$widget onInactive - AppLifecycleListener");
      },
      onPause: (){
        ddLog("$widget onPause - AppLifecycleListener");
      },
      onDetach: (){
        ddLog("$widget onDetach - AppLifecycleListener");
      },
      onHide: (){
        ddLog("$widget onHide - AppLifecycleListener");
      },
    );
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
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),
          ],
        ),
      ),
    );
  }

  /*************** AppLifecycleObserverMixin ***************/
  @override
  Future<void> onResume() async {
    // TODO: implement onResume
    ddLog("$widget onResume");
  }

  @override
  Future<void> onInactive() async {
    // TODO: implement onInactive
    ddLog("$widget onInactive");
  }

  @override
  Future<void> onPause() async {
    // TODO: implement onPause
    ddLog("$widget onPause");
  }

  @override
  Future<void> onDetach() async {
    // TODO: implement onDetached
    ddLog("$widget onDetached");
  }

  @override
  Future<void> onHidden() async {
    // TODO: implement onHidden
    ddLog("$widget onHidden");
  }
}


