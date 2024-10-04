//
//  PageRouteDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/10/3 13:00.
//  Copyright © 2024/10/3 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_fade_page_route.dart';
import 'package:get/get.dart';

class PageRouteDemo extends StatefulWidget {
  const PageRouteDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<PageRouteDemo> createState() => _PageRouteDemoState();
}

class _PageRouteDemoState extends State<PageRouteDemo> {
  bool get hideApp =>
      "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant PageRouteDemo oldWidget) {
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

    HapticFeedback.heavyImpact();
  }

  pushPage({
    required Widget page,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(opacity: animation, child: page);
        },
      ),
    );
  }

  pushPageOne({
    required Widget page,
  }) {
    Navigator.push(
      context,
      NFadePageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }
}
