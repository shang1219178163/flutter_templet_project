import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_convert_view.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class NTransformViewDemo extends StatefulWidget {
  NTransformViewDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NTransformViewDemo> createState() => _NTransformViewDemoState();
}

class _NTransformViewDemoState extends State<NTransformViewDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final transformViewController = NTransformViewController();

  late final actionItems = <({String name, VoidCallback action})>[
    (name: "Generate", action: onGenerate),
    (name: "Paste", action: onPaste),
    (name: "Clear", action: onClear),
    (name: "Create", action: onCreate),
  ];

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
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
            ),
      body: NConvertView(
        controller: transformViewController,
        title: NText(
          '测试',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        message: NText(
          "这是一条提示信息",
          maxLines: 3,
        ),
        toolbarBuilder: (_) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: actionItems.map((e) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: e.action,
                child: NText(e.name),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  onGenerate() async {
    final result = transformViewController.textEditingController.text * 2;
    transformViewController.out = result;
  }

  onClear() {
    transformViewController.clear();
  }

  onPaste() async {
    transformViewController.paste();
    onGenerate();
  }

  onCreate() {
    DLog.d(transformViewController.out);
  }
}
