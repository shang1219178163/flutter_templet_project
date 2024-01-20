

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
    WidgetsBindingObserver,
    AppLifecycleObserverMixin {

  final _scrollController = ScrollController();

  // late final _lifecycleEvent = LifecycleEventObserver(
  //   data: "$widget",
  //   onResume: () async {
  //
  //   },
  //   onInactive: () async {
  //
  //   },
  //   onPause: () async {
  //
  //   },
  //   onDetached: () async {
  //
  //   }
  // );
  //
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(_lifecycleEvent);
  // }
  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(_lifecycleEvent);
  //   super.dispose();
  // }


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
    DDLog("$widget onResume");
  }

  @override
  Future<void> onInactive() async {
    // TODO: implement onInactive
    DDLog("$widget onInactive");
  }

  @override
  Future<void> onPause() async {
    // TODO: implement onPause
    DDLog("$widget onPause");
  }

  @override
  Future<void> onDetached() async {
    // TODO: implement onDetached
    DDLog("$widget onDetached");
  }
}


