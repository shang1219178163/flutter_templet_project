//
//  PlatformDispatcherDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/13 15:49.
//  Copyright © 2025/3/13 shang. All rights reserved.
//

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class PlatformDispatcherDemo extends StatefulWidget {
  const PlatformDispatcherDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<PlatformDispatcherDemo> createState() => _PlatformDispatcherDemoState();
}

class _PlatformDispatcherDemoState extends State<PlatformDispatcherDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  late final items = [(title: "platformDispatcher", event: onPrint)];

  final message = """
final keyView = WidgetsBinding.instance.platformDispatcher.views.first;
final mediaQueryData = MediaQueryData.fromView(keyView);
打印:

  {
    "size": {
      "width": 393.0,
      "height": 852.0
    },
    "devicePixelRatio": 3.0,
    "textScaleFactor": 1.0,
    "platformBrightness": "light",
    "padding": {
      "left": 0.0,
      "top": 59.0,
      "right": 0.0,
      "bottom": 34.0
    },
    "viewInsets": {
      "left": 0.0,
      "top": 0.0,
      "right": 0.0,
      "bottom": 0.0
    },
    "systemGestureInsets": {
      "left": 0.0,
      "top": 0.0,
      "right": 0.0,
      "bottom": 0.0
    },
    "viewPadding": {
      "left": 0.0,
      "top": 59.0,
      "right": 0.0,
      "bottom": 34.0
    },
    "alwaysUse24HourFormat": true,
    "accessibleNavigation": false,
    "invertColors": false,
    "highContrast": false,
    "onOffSwitchLabels": false,
    "disableAnimations": false,
    "boldText": false,
    "navigationMode": "traditional",
    "gestureSettings": {
      "touchSlop": null
    },
    "displayFeatures": []
  }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.map((e) {
                return OutlinedButton(
                  onPressed: e.event,
                  child: Text(e.title),
                );
              }).toList(),
            ),
            Text(
              message,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void onPrint() {
    final keyView = WidgetsBinding.instance.platformDispatcher.views.first;
    final mediaQueryData = MediaQueryData.fromView(keyView);
    var dpr = View.of(context).devicePixelRatio;
    var physicalSize = View.of(context).physicalSize;

    var dpr1 = keyView.devicePixelRatio;
    var physicalSize1 = keyView.physicalSize;

    DLog.d([
      WidgetsBinding.instance.platformDispatcher.views,
      WidgetsBinding.instance.platformDispatcher.implicitView,
      mediaQueryData.toJson().formatedString(),
    ].asMap());
  }
}
