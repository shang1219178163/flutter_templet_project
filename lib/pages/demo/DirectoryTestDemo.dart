import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:get/get.dart';import 'package:flutter_templet_project/extension/extension_local.dart';

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

  late final items = <ActionRecord>[
    (e: "current", action: onDone),
    (e: "assets", action: onAssets),
  ];

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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              buildSectionBox(items: items),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionBox({
    required List<ActionRecord> items,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((e) {
        return InkWell(
          onTap: e.action,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: NText(
              e.e,
              color: context.primaryColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  void onDone() {
    // 获取当前脚本的路径
    var currentPath = Directory.current.path;
    // 获取项目根目录路径（假设你要向上回溯路径，具体要根据实际情况处理）
    var projectPath = path.dirname(path.dirname(currentPath));

    DLog.d('Current Directory: $currentPath');
    DLog.d('Project Directory: $projectPath');
  }

  void onAssets() {
    listAssets();
  }

  Future<void> listAssets() async {}
}
