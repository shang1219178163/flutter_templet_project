import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
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
    DLog.d("$widget initState");

    // _lifecycleListener = AppLifecycleListener(
    //   onRestart: () {
    //     DLog.d("$widget onRestart - AppLifecycleListener");
    //   },
    //   onResume: () {
    //     DLog.d("$widget onResume - AppLifecycleListener");
    //   },
    //   onInactive: () {
    //     DLog.d("$widget onInactive - AppLifecycleListener");
    //   },
    //   onPause: () {
    //     DLog.d("$widget onPause - AppLifecycleListener");
    //   },
    //   onDetach: () {
    //     DLog.d("$widget onDetach - AppLifecycleListener");
    //   },
    //   onHide: () {
    //     DLog.d("$widget onHide - AppLifecycleListener");
    //   },
    // );
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
      var now = DateTime.now();
      var duration = now.difference(_startTime);
      durationVN.value = duration;

      // countVN.value++;
      // DLog.d("countVN.value: ${countVN.value}");
    });
  }

  /// ************* AppLifecycleObserverMixin **************
  @override
  void onAppLifecycleStateChanged(AppLifecycleState state) {
    DLog.d("$widget ${state.name}");
  }
}
