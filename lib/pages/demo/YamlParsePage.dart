import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/util/yaml_ext.dart';
import 'package:path/path.dart' as path;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await onParse();
                    // final path = _scriptPath();
                    // ddlog("path: $path");

                    // final currentDirectory = dirname(_scriptPath());
                    // final filePath = normalize(join(currentDirectory, 'pubspec.yaml'));
                    // ddlog("currentDirectory: $currentDirectory");
                    // ddlog("filePath: $filePath");
                    //
                    // final data = await rootBundle.loadString(filePath);
                    // final mapData = loadYaml(data);
                    // ddlog("parseYaml: $mapData");
                  },
                ))
            .toList(),
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
          children: [
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

  onParse() async {
    // 获取当前文件的 URI
    Uri currentScript = Platform.script;
    // 将 URI 转换为文件系统路径
    String currentPath = currentScript.toFilePath();
    ddlog('当前文件路径: $currentPath');

    String yamlPath1 = path.dirname(currentPath);
    ddlog("yamlPath1: $yamlPath1");

    String yamlPath3 = path.join(yamlPath1, '../pubspec.yaml');
    ddlog("yamlPath3: $yamlPath3");

    String yamlPath4 = Uri.file(yamlPath3).path;
    ddlog("yamlPath4: $yamlPath4");

    String yamlPath =
        '/Users/shang/GitHub/flutter_templet_project/pubspec.yaml';
    ddlog("yamlPath: $yamlPath");

    File file = File(yamlPath);
    String yamlStr = file.readAsStringSync();
    contentVN.value = yamlStr;

    final yamlMap = await YamlMapExt.parseYaml(path: yamlPath);

    final encoder = JsonEncoder.withIndent('  '); // 使用带缩进的 JSON 编码器
    contentVN.value = encoder.convert(yamlMap);
  }
}
