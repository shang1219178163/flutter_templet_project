

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

class YamlParsePage extends StatefulWidget {

  YamlParsePage({
    super.key, 
    this.title
  });

  final String? title;

  @override
  State<YamlParsePage> createState() => _YamlParsePageState();
}

class _YamlParsePageState extends State<YamlParsePage> {

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            await parseYaml();
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
        )).toList(),
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
            Text("$widget"),
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

  parseYaml() async {
    String yamlPath1 = path.dirname(Platform.script.toFilePath());
    ddlog("yamlPath1: $yamlPath1");

    String yamlPath = path.join(yamlPath1, '../pubspec.yaml');
    yamlPath = '/Users/shang/GitHub/flutter_templet_project/pubspec.yaml';
    ddlog("yamlPath: $yamlPath");

    File f = File(yamlPath);
    String yamlText = f.readAsStringSync();
    ddlog("yamlText: $yamlText");

    Map yamlMap = loadYaml(yamlText);
    ddlog("yamlMap: $yamlMap");
  }
}