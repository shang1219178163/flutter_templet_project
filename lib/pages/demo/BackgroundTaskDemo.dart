import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/rich_text_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

import 'package:get/get.dart';

class BackgroundTaskDemo extends StatefulWidget {
  const BackgroundTaskDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<BackgroundTaskDemo> createState() => _BackgroundTaskDemoState();
}

class _BackgroundTaskDemoState extends State<BackgroundTaskDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final linkMap = {
    "WorkManager 是跨平台后台任务可靠解决方案": "https://mp.weixin.qq.com/s/UF_ay4qROLGqlr1tIMc43g",
  };

  @override
  void didUpdateWidget(covariant BackgroundTaskDemo oldWidget) {
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
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            ...linkMap.entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  DLog.d(entry.value);
                },
                child: Text(
                  '${entry.key}, \nhttps://pub.dev/packages/workmanager',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue, // 下划线颜色
                    decorationThickness: 1.0, // 下划线粗细
                    decorationStyle: TextDecorationStyle.solid, // 虚线样式
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
