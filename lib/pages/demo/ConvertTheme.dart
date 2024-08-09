//
//  NTransformTheme.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/8 10:14.
//  Copyright © 2024/8/8 shang. All rights reserved.
//

import 'dart:async';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_transform_view.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';
import 'package:flutter_templet_project/mixin/create_file_mixin.dart';
import 'package:flutter_templet_project/pages/demo/convert/WidgetThemeConvert.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class ConvertTheme extends StatefulWidget {
  ConvertTheme({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ConvertTheme> createState() => _ConvertThemeState();
}

class _ConvertThemeState extends State<ConvertTheme> with CreateFileMixin {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final _scrollController = ScrollController();

  final transformViewController = NTransformViewController();

  late final actionItems = <({String name, VoidCallback action})>[
    (name: "Generate", action: onGenerate),
    (name: "Paste", action: onPaste),
    (name: "Clear", action: onClear),
    (name: "Try", action: onTry),
  ];

  final canDrag = ValueNotifier(Platform.isMacOS);

  List<File> files = [];
  List<Tuple2<String, SelectableText>> tabItems = [];

  final themeConvert = WidgetThemeConvert();

  @override
  void initState() {
    super.initState();
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
    return NTransformView(
      controller: transformViewController,
      // title: NText(
      //   '根据 Widget 组件生成对应的 Theme',
      //   fontSize: 20,
      //   fontWeight: FontWeight.w500,
      // ),
      // message: NText(
      //   "这是一条提示信息",
      //   maxLines: 3,
      // ),
      // canDrag: true,
      // onDropChanged: (files) async {
      //   ddlog(files);
      //   String content = await files.first.readAsString();
      //   transformViewController.out = content;
      // },
      start: canDrag.value == false
          ? null
          : buildDragBox(
              onDropChanged: (List<File> files) async {
                ddlog(files);
                // String content1 = await files.first.readAsString();
                // transformViewController.out = content1;

                final list = <Tuple2<String, SelectableText>>[];
                for (final e in files) {
                  final tuple = await themeConvert.convertFile(file: e);
                  if (tuple == null) {
                    continue;
                  }
                  final item = Tuple2(
                    tuple.nameNew ?? "",
                    SelectableText(tuple.contentNew ?? ""),
                  );
                  list.add(item);
                }
                tabItems = list;
                setState(() {});
              },
            ),
      toolbarBuilder: (_) {
        return ValueListenableBuilder(
          valueListenable: canDrag,
          builder: (context, value, child) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...actionItems.map((e) {
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
                NPair(
                  icon: Text(
                    "Drag",
                    style: TextStyle(fontSize: 14),
                  ),
                  child: SizedBox(
                    // width: 50,
                    height: 28,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: CupertinoSwitch(
                        value: canDrag.value,
                        onChanged: (val) {
                          onDrag(val);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      end: canDrag.value == false || tabItems.isEmpty
          ? null
          : NPageView(
              items: tabItems,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              isThemeBg: false,
              isBottom: false,
              needSafeArea: false,
            ),
    );
  }

  Widget buildDragBox({
    required ValueChanged<List<File>> onDropChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.blue),
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return DropTarget(
            onDragDone: (detail) {
              files = detail.files.map((e) => File(e.path)).toList();
              onDropChanged.call(files);
              if (files.isEmpty) {
                return;
              }
              // 读取第一个文件
              // final file = files.first;
              // debugPrint("file: ${file.path}");
              setState(() {});
            },
            onDragEntered: (detail) {
              // setState(() {});
            },
            onDragExited: (detail) {
              // setState(() {});
            },
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...files
                          .map(
                            (e) => SelectableText(
                              e.path,
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                          .toList(),
                      if (files.isEmpty)
                        NText(
                          "拖拽文件",
                          style: TextStyle(color: fontColor737373),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  onGenerate() async {
    if (canDrag.value) {
      for (final e in tabItems) {
        try {
          onConvert(text: e.item2.data ?? "");
        } catch (e) {
          debugPrint("❌$this $e");
          continue;
        }
      }
    } else {
      onConvert(text: transformViewController.textEditingController.text);
    }
  }

  onConvert({required String text}) async {
    final model = await themeConvert.convert(content: text);
    if (model == null) {
      ddlog("❌convert 转换失败");
      return;
    }

    transformViewController.out = model.contentNew ?? "";

    final isSuccess = await onCreate(
      fileName: model.nameNew ?? "",
      content: model.contentNew ?? "",
    );
    if (isSuccess) {}
  }

  onClear() {
    transformViewController.clear();
    files.clear();
    tabItems.clear();
    setState(() {});
  }

  onPaste() async {
    transformViewController.paste();
    onGenerate();
  }

  onTry() async {
    transformViewController.textEditingController.text =
        themeConvert.exampleTemplet();
    onGenerate();
  }

  onDrag(bool? val) async {
    canDrag.value = val ?? !canDrag.value;
    setState(() {});
  }

  Future<bool> onCreate(
      {required String fileName, required String content}) async {
    return onCreateFile(name: fileName, content: content);
  }
}
