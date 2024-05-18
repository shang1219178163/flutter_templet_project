import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/duration_ext.dart';
import 'package:flutter_templet_project/util/AppLifecycleObserver.dart';

class AppLifecycleStateObserverDemo extends StatefulWidget {
  AppLifecycleStateObserverDemo({super.key, this.title});

  final String? title;

  @override
  State<AppLifecycleStateObserverDemo> createState() =>
      _AppLifecycleStateObserverDemoState();
}

class _AppLifecycleStateObserverDemoState
    extends State<AppLifecycleStateObserverDemo>
    with AppLifecycleObserverMixin {
  final _scrollController = ScrollController();

  late AppLifecycleListener _lifecycleListener;

  late Timer _timer;
  late DateTime _startTime;
  final countVN = ValueNotifier(0);

  final durationVN = ValueNotifier(Duration(milliseconds: 0));

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
      onRestart: () {
        ddlog("$widget onRestart - AppLifecycleListener");
      },
      onResume: () {
        ddlog("$widget onResume - AppLifecycleListener");
      },
      onInactive: () {
        ddlog("$widget onInactive - AppLifecycleListener");
      },
      onPause: () {
        ddlog("$widget onPause - AppLifecycleListener");
      },
      onDetach: () {
        ddlog("$widget onDetach - AppLifecycleListener");
      },
      onHide: () {
        ddlog("$widget onHide - AppLifecycleListener");
      },
    );
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
                  onPressed: () {
                    timeUpdate();
                  },
                ))
            .toList(),
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
            ValueListenableBuilder(
              valueListenable: durationVN,
              builder: (context, value, child) {
                final desc = value.toTime();
                return Text("定时器:$desc");
              },
            ),
            ValueListenableBuilder(
              valueListenable: countVN,
              builder: (context, value, child) {
                return Text("countVN: $value");
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 时间重置
  timeReset() {
    _startTime = DateTime.now();
    countVN.value = 0;
  }

  timeUpdate() {
    timeReset();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      DateTime now = DateTime.now();
      Duration duration = now.difference(_startTime);
      durationVN.value = duration;

      // countVN.value++;
      // ddlog("countVN.value: ${countVN.value}");
    });
  }

  /*************** AppLifecycleObserverMixin ***************/
  @override
  Future<void> onResume() async {
    // TODO: implement onResume
    ddlog("$widget onResume");
  }

  @override
  Future<void> onInactive() async {
    // TODO: implement onInactive
    ddlog("$widget onInactive");
  }

  @override
  Future<void> onPause() async {
    // TODO: implement onPause
    ddlog("$widget onPause");
  }

  @override
  Future<void> onDetach() async {
    // TODO: implement onDetached
    ddlog("$widget onDetached");
  }

  @override
  Future<void> onHidden() async {
    // TODO: implement onHidden
    ddlog("$widget onHidden");
  }
}
