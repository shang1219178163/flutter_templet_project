//
//  ListBodyDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/26 10:25.
//  Copyright © 2024/7/26 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListBodyDemo extends StatefulWidget {
  const ListBodyDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ListBodyDemo> createState() => _ListBodyDemoState();
}

class _ListBodyDemoState extends State<ListBodyDemo> {
  bool get hideApp =>
      "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: mainView(),
      ),
    );
  }

  Widget mainView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListBody(
          mainAxis: Axis.horizontal,
          reverse: true,
          children: [
            Container(
              color: Colors.green,
              height: 100,
              child: const Center(
                child: Text('Item 1'),
              ),
            ),
            Container(
              color: Colors.blue,
              height: 100,
              child: const Center(
                child: Text('Item 2'),
              ),
            ),
            Container(
              color: Colors.red,
              height: 100,
              child: const Center(
                child: Text('Item 3'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
