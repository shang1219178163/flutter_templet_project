import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/object_ext.dart';
import 'package:flutter_templet_project/util/yaml_ext.dart';
import 'package:path/path.dart' as path;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:yaml/yaml.dart';

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
        (title: "读取 pubspec.yaml", action: onRead),
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
                return Text("$value");
              },
            ),
          ],
        ),
      ),
    );
  }

  String _scriptPath() {
    var script = Platform.script.toString();
    ddlog("script: $script");

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
    ddlog('当前文件路径: $currentPath');

    String yamlPath1 = path.dirname(currentPath);
    ddlog("yamlPath1: ${"目录${Directory(yamlPath1).existsSync() ? "" : "不"}存在"} $yamlPath1");

    String yamlPath3 = path.join(yamlPath1, '../pubspec.yaml');
    ddlog("yamlPath3: ${"文件${File(yamlPath3).existsSync() ? "" : "不"}存在"} $yamlPath3");

    String yamlPath4 = Uri.file(yamlPath3).path;
    ddlog("yamlPath4: ${"文件${File(yamlPath4).existsSync() ? "" : "不"}存在"} $yamlPath4");
  }

  onRead() async {
    String source = await rootBundle.loadString("pubspec.yaml");
    // debugPrint('source: $source');
    contentVN.value = source;

    // final Map mapData = await YamlMapExt.fromString(content: source);
    // contentVN.value = mapData.formatedString();

    // 转为模型
    // final parsed = Pubspec.parse(source);
    // ddlog('parsed: ${parsed}');
    // contentVN.value = parsed.toString();
  }

  onParse() async {
    String yamlPath = '/Users/shang/GitHub/flutter_templet_project/pubspec.yaml';
    ddlog("yamlPath: $yamlPath");

    File file = File(yamlPath);
    if (!file.existsSync()) {
      contentVN.value = "文件不存在";
      return;
    }

    final yamlMap = await YamlMapExt.parseYaml(path: yamlPath);
    final encoder = JsonEncoder.withIndent('  '); // 使用带缩进的 JSON 编码器
    contentVN.value = encoder.convert(yamlMap);

    // 通过 pubspec_parse 解析,返回模型
    String yamlStr = file.readAsStringSync();
    final parsed = Pubspec.parse(yamlStr);
    ddlog('parsed: ${parsed}');
  }
}
