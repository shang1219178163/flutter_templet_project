

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/LifecycleEventHandler.dart';
import 'package:flutter_templet_project/util/LifecycleEventObserver.dart';
import 'package:flutter_templet_project/util/debug_log.dart';

class LifecycleEventObserverDemo extends StatefulWidget {

  LifecycleEventObserverDemo({
    super.key, 
    this.title
  });

  final String? title;

  @override
  State<LifecycleEventObserverDemo> createState() => _LifecycleEventObserverDemoState();
}

class _LifecycleEventObserverDemoState extends State<LifecycleEventObserverDemo> with
    WidgetsBindingObserver,
    LifecycleEventObserverMixin {

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

  /*************** LifecycleEventObserverMixin ***************/

  @override
  Future<void> onResume() async {
    DDLog("onResume");
  }

  @override
  Future<void> onInactive() async {
    DDLog("onInactive");
  }

  @override
  Future<void> onPause() async {
    DDLog("onPause");
  }

  @override
  Future<void> onDetached() async {
    DDLog("onDetached");
  }
}


