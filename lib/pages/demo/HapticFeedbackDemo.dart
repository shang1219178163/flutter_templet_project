//
//  HapticFeedbackDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/10/3 22:06.
//  Copyright © 2024/10/3 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class HapticFeedbackDemo extends StatefulWidget {
  const HapticFeedbackDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<HapticFeedbackDemo> createState() => _HapticFeedbackDemoState();
}

class _HapticFeedbackDemoState extends State<HapticFeedbackDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final feedbacks = <({String name, Future<void> action})>[
    (name: "vibrate", action: HapticFeedback.vibrate()),
    (name: "lightImpact", action: HapticFeedback.lightImpact()),
    (name: "mediumImpact", action: HapticFeedback.mediumImpact()),
    (name: "heavyImpact", action: HapticFeedback.heavyImpact()),
    (name: "selectionClick", action: HapticFeedback.selectionClick()),
  ];

  @override
  void didUpdateWidget(covariant HapticFeedbackDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

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
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            ...feedbacks.map(
              (e) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    onHaptic(e.name);
                  },
                  child: Text(e.name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 点击反馈
  Future<void> onHaptic(String name) async {
    switch (name) {
      case "vibrate":
        await HapticFeedback.vibrate();
        break;
      case "lightImpact":
        await HapticFeedback.lightImpact();
        break;
      case "mediumImpact":
        await HapticFeedback.mediumImpact();
        break;
      case "heavyImpact":
        await HapticFeedback.heavyImpact();
        break;
      case "selectionClick":
        await HapticFeedback.selectionClick();
        break;
      default:
        DLog.d("name: $name");
        break;
    }
  }
}
