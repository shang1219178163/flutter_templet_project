//
//  NTweenTransitionDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/30 10:02.
//  Copyright © 2024/9/30 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_tween_transition.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get.dart';

class NTweenTransitionDemo extends StatefulWidget {
  const NTweenTransitionDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NTweenTransitionDemo> createState() => _NTweenTransitionDemoState();
}

class _NTweenTransitionDemoState extends State<NTweenTransitionDemo> {
  bool get hideApp =>
      "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant NTweenTransitionDemo oldWidget) {
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
            buildTweenTransition(),
          ],
        ),
      ),
    );
  }

  Widget buildTweenTransition() {
    return NTweenTransition(
      duration: Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (_, animation) {
        return ValueListenableBuilder(
          valueListenable: animation,
          builder: (context, value, child) {
            DLog.d("animation.value: ${animation.value}");
            return Container(
              width: 200,
              height: 200,
              child: Text("${animation.value.toStringAsFixed(2)}"),
            );
          },
        );
      },
    );
  }
}
