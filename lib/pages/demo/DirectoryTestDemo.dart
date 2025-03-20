import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get.dart';

import 'dart:io';
import 'package:path/path.dart' as path;

class DirectoryTestDemo extends StatefulWidget {
  const DirectoryTestDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<DirectoryTestDemo> createState() => _DirectoryTestDemoState();
}

class _DirectoryTestDemoState extends State<DirectoryTestDemo> {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

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
                        onPressed: onDone,
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
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
        child: Column(
          children: [
            Text("$widget"),
          ],
        ),
      ),
    );
  }

  void onDone() {
    // 获取当前脚本的路径
    String currentPath = Directory.current.path;
    // 获取项目根目录路径（假设你要向上回溯路径，具体要根据实际情况处理）
    String projectPath = path.dirname(path.dirname(currentPath));

    DLog.d('Current Directory: $currentPath');
    DLog.d('Project Directory: $projectPath');
  }
}
