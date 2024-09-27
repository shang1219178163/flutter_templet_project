//
//  NestedNavigatorDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/27 16:14.
//  Copyright © 2024/9/27 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/Pages/second_page.dart';
import 'package:flutter_templet_project/pages/third_page.dart';
import 'package:get/get.dart';

class NestedNavigatorDemo extends StatefulWidget {
  const NestedNavigatorDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NestedNavigatorDemo> createState() => _NestedNavigatorDemoState();
}

class _NestedNavigatorDemoState extends State<NestedNavigatorDemo> {
  bool get hideApp =>
      "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant NestedNavigatorDemo oldWidget) {
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
            Text("$widget"),
          ],
        ),
      ),
    );
  }
}
