//
//  NestedNavigatorDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/27 16:14.
//  Copyright © 2024/9/27 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/pages/demo/CupertinoTabScaffoldDemo.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
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
              buildNavigatorBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigatorBox() {
    onNext({required BuildContext context, required String title}) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return NestedNavigatorSubpage(
              appBar: AppBar(
                centerTitle: true,
                title: Text(title),
                actions: [
                  GestureDetector(
                    onTap: () {
                      DLog.d("error");
                    },
                    child: Icon(Icons.info_outline),
                  ),
                ]
                    .map((e) => Container(
                          padding: EdgeInsets.only(right: 8),
                          child: e,
                        ))
                    .toList(),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onNext(context: context, title: title);
                    },
                    child: Text('next page'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Go back'),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...List.generate(Random().nextInt(9), (index) {
                        final title = "选项_$index";

                        return OutlinedButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(50, 18),
                            // primary: primary,
                          ),
                          onPressed: () {
                            DLog.d(title);
                          },
                          child: Text(title),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return Container(
      height: 400,
      child: Theme(
        data: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.lightBlueAccent,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            toolbarTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            iconTheme: IconThemeData(
              color: Colors.white, // 图标颜色
              size: 24.0, // 图标大小
              opacity: 0.8, // 图标透明度
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.white, // 图标颜色
              size: 24.0, // 图标大小
              opacity: 0.8, // 图标透明度
            ),
          ),
        ),
        child: Navigator(
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (context) {
                return NestedNavigatorSubpage(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text("嵌套导航主页面"),
                  ),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          onNext(context: context, title: "子页面");
                        },
                        child: Text('next page'),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<Object?> onNavigator() async {
    var alignment = Alignment.centerLeft;
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
        width: context.screenSize.width * 0.7,
        child: Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme.of(context).copyWith(
              elevation: 0,
            ),
          ),
          child: Navigator(
            initialRoute: AppRouter.appTabPage,
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

/// 嵌套导航子视图
class NestedNavigatorSubpage extends StatefulWidget {
  const NestedNavigatorSubpage({
    super.key,
    this.appBar,
    required this.child,
  });

  final AppBar? appBar;

  final Widget child;

  @override
  State<NestedNavigatorSubpage> createState() => _NestedNavigatorSubpageState();
}

class _NestedNavigatorSubpageState extends State<NestedNavigatorSubpage> {
  final scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant NestedNavigatorSubpage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.appBar != widget.appBar || oldWidget.child != widget.child) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ??
          AppBar(
            title: Text("$widget"),
          ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: color,
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        children: [
          // NPickerToolBar(
          //   title: title,
          //   onCancel: onBack,
          //   onConfirm: onNext,
          // ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
