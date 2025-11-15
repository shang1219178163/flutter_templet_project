//
//  CurvedNavigationBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/22 15:58.
//  Copyright © 2025/1/22 shang. All rights reserved.
//

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:get/get.dart';

class CurvedNavigationBarDemo extends StatefulWidget {
  const CurvedNavigationBarDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<CurvedNavigationBarDemo> createState() => _CurvedNavigationBarDemoState();
}

class _CurvedNavigationBarDemoState extends State<CurvedNavigationBarDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final tabIndex = ValueNotifier(0);

  @override
  void didUpdateWidget(covariant CurvedNavigationBarDemo oldWidget) {
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
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: context.scaffoldBackgroundColor,
        items: <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.compare_arrows, size: 30),
          Icon(Icons.share, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          debugPrint("$widget $index");
          tabIndex.value = index;
        },
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
