import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/util/yaml_ext.dart';
import 'package:path/path.dart' as path;
import 'package:pubspec_parse/pubspec_parse.dart';

/// 解析 Yaml
class YamlParsePage extends StatefulWidget {
  YamlParsePage({super.key, this.title});

  final String? title;

  @override
  State<YamlParsePage> createState() => _YamlParsePageState();
}

class _YamlParsePageState extends State<YamlParsePage> {
  final _scrollController = ScrollController();

  final contentVN = ValueNotifier("");

  List<({String title, VoidCallback action})> get items => [
        (title: "路径检测", action: onPath),
        (title: "解析 pubspec.yaml", action: onParse),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Wrap(
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
            ),
            ValueListenableBuilder(
              valueListenable: contentVN,
              builder: (context, value, child) {
                return Text(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _scriptPath() {
    var script = Platform.script.toString();
    DLog.d("script: $script");

    if (script.startsWith("file://")) {
      script = script.substring(7);
    } else {
      final idx = script.indexOf("file:/");
      script = script.substring(idx + 5);
    }
    return script;
  }

  onPath() async {
    // 获取当前文件的 URI
    Uri currentScript = Platform.script;
    // 将 URI 转换为文件系统路径
    String currentPath = currentScript.toFilePath();
    DLog.d('当前文件路径: $currentPath');

    String yamlPath1 = path.dirname(currentPath);
    DLog.d("yamlPath1: ${"目录${Directory(yamlPath1).existsSync() ? "" : "不"}存在"} $yamlPath1");

    String yamlPath3 = path.join(yamlPath1, '../pubspec.yaml');
    DLog.d("yamlPath3: ${"文件${File(yamlPath3).existsSync() ? "" : "不"}存在"} $yamlPath3");

    String yamlPath4 = Uri.file(yamlPath3).path;
    DLog.d("yamlPath4: ${"文件${File(yamlPath4).existsSync() ? "" : "不"}存在"} $yamlPath4");

    String yamlPath = '/Users/shang/GitHub/flutter_templet_project/pubspec.yaml';
    DLog.d("yamlPath: $yamlPath");

    File file = File(yamlPath);
    if (!file.existsSync()) {
      contentVN.value = "文件不存在";
      return;
    }
    contentVN.value = "文件存在";
  }

  onParse() async {
    String content = await rootBundle.loadString("pubspec.yaml");
    final yamlMap = await YamlMapExt.fromString(content: content);
    final encoder = JsonEncoder.withIndent('  '); // 使用带缩进的 JSON 编码器
    contentVN.value = encoder.convert(yamlMap);

    // 通过 pubspec_parse 解析,返回模型
    final pubspecModel = Pubspec.parse(content);
    DLog.d('pubspecModel: $pubspecModel');
  }
}
