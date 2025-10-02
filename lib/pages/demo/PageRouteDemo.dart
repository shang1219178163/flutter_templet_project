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
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: Wrap(
                runSpacing: 8,
                spacing: 8,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(50, 18),
                    ),
                    onPressed: () {
                      pushPage(page: buildPage());
                    },
                    child: Text("FadeTransition"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(50, 18),
                    ),
                    onPressed: () {
                      pushPageOne(page: buildPage());
                    },
                    child: Text("NFadePageRoute"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(50, 18),
                    ),
                    onPressed: () {
                      pushPageTwo(page: buildPage());
                    },
                    child: Text("向上"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(50, 18),
                    ),
                    onPressed: () {
                      pushPageThree(page: buildPage());
                    },
                    child: Text("右进"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    HapticFeedback.heavyImpact();
  }

  Widget buildPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: Text("测试页面"),
      ),
    );
  }

  void pushPage({
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

  void pushPageOne({
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

  void pushPageTwo({required Widget page}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1), // 从底部
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  void pushPageThree({required Widget page}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), // 从底部
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }
}
