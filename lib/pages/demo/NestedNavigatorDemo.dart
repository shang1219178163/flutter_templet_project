//
//  NestedNavigatorDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/27 16:14.
//  Copyright © 2024/9/27 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/Pages/second_page.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/pages/app_tab_page.dart';
import 'package:flutter_templet_project/pages/demo/CupertinoTabScaffoldDemo.dart';
import 'package:flutter_templet_project/pages/third_page.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
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
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  List<({String title, VoidCallback action})> get items => [
        (title: "独立导航", action: onNavigator),
      ];

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
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items.map((e) {
                  return ElevatedButton(
                    style: TextButton.styleFrom(
                      // padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(24, 28),
                      // foregroundColor: Colors.blue,
                    ),
                    onPressed: e.action,
                    child: Text(e.title),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Object?> onNavigator() async {
    Alignment alignment = Alignment.centerLeft;
    Tween<Offset> getTween() {
      // debugPrint("alignment:${alignment} ${alignment.y}");
      if ([-1, 1].contains(alignment.y)) {
        return Tween<Offset>(begin: Offset(0, alignment.y), end: Offset.zero);
      }

      if ([-1, 1].contains(alignment.x)) {
        return Tween<Offset>(begin: Offset(alignment.x, 0), end: Offset.zero);
      }

      return Tween<Offset>(begin: Offset(0, 0), end: Offset.zero);
    }

    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            alignment: alignment,
            child: _buildPhrasesDrawer(),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = getTween().chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
        opaque: false,
        barrierColor: Colors.black54,
        barrierDismissible: true,
      ),
    );
  }

  final _canPopNotifier = ValueNotifier(true);

  Widget _buildPhrasesDrawer() {
    // 内部页面跳转使用 [Navigator] 子路由实现
    // 通过检测 [_canPopNotifier] 来实现回复语编辑中的后退拦截
    return ListenableBuilder(
      listenable: _canPopNotifier,
      builder: (_, child) {
        return PopScope(
          canPop: _canPopNotifier.value,
          child: child!,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
          },
        );
      },
      child: SizedBox(
        width: screenSize.width * 0.7,
        child: Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: false,
            appBarTheme: AppBarTheme.of(context).copyWith(
              elevation: 0,
            ),
          ),
          child: Navigator(
            initialRoute: APPRouter.appTabPage,
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => CupertinoTabScaffoldDemo(),
              );
            },
          ),
        ),
      ),
    );
  }
}
