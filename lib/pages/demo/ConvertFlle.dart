//
//  ConvertFlle.dart
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
import 'package:flutter_templet_project/basicWidget/n_convert_view.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/mixin/create_file_mixin.dart';
import 'package:flutter_templet_project/pages/demo/convert/ConvertProtocol.dart';
import 'package:flutter_templet_project/pages/demo/convert/CopyWithConvert.dart';
import 'package:flutter_templet_project/pages/demo/convert/PackageExportConvert.dart';
import 'package:flutter_templet_project/pages/demo/convert/SizeFilterConvert.dart';
import 'package:flutter_templet_project/pages/demo/convert/WidgetNameConvert.dart';
import 'package:flutter_templet_project/pages/demo/convert/WidgetThemeConvert.dart';
import 'package:flutter_templet_project/util/app_color.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class ConvertFlle extends StatefulWidget {
  ConvertFlle({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ConvertFlle> createState() => _ConvertFlleState();
}

class _ConvertFlleState extends State<ConvertFlle> with CreateFileMixin {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

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

  final progressVN = ValueNotifier(0.0);

  List<File> files = [];
  List<Tuple2<String, SelectableText>> tabItems = [];

  final convertTypeIndex = 0;

  final convertTypes = <ConvertProtocol>[
    WidgetThemeConvert(),
    WidgetNameConvert(),
    PackageExportConvert(),
    SizeFilterConvert(),
    CopyWithConvert(),
  ];

  late var current = convertTypes[convertTypeIndex];

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
              // bottom: buildBottomProgress(),
            ),
      body: buildBody(),
    );
  }

  /// 进度指示条
  PreferredSize? buildBottomProgress() {
    // if (!canDrag.value) {
    //   return null;
    // }
    return PreferredSize(
      preferredSize: const Size.fromHeight(2),
      child: ValueListenableBuilder<double>(
        valueListenable: progressVN,
        builder: (_, value, child) {
          var indicatorColor = value >= 1.0 ? Colors.transparent : Colors.green;
          return LinearProgressIndicator(
            value: value,
            color: indicatorColor,
            backgroundColor: Colors.transparent,
            minHeight: 5,
          );
        },
      ),
    );
  }

  Widget buildBody() {
    return NConvertView(
      controller: transformViewController,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: NMenuAnchor<ConvertProtocol>(
                  values: convertTypes,
                  initialItem: current,
                  cbName: (e) => e?.name ?? "请选择",
                  equal: (a, b) => a == b,
                  onChanged: (e) async {
                    debugPrint(e.name);
                    current = e;
                    onClear();
                    await onDragChanged();
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NText(
                current.message,
                fontSize: 14,
              ),
            ],
          ),
        ]
            .map((e) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: e,
                ))
            .toList(),
      ),
      start: canDrag.value == false
          ? null
          : buildDragBox(
              onDropChanged: (List<File> files) async {
                // DLog.d(files);
                this.files = files;
                await onDragChanged();
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
                          style: TextStyle(color: AppColor.fontColor737373),
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

  Future<void> onDragChanged() async {
    final list = <Tuple2<String, SelectableText>>[];
    for (final e in files) {
      final model = await current.convertFile(file: e);
      progressVN.value = files.indexOf(e) / (files.length - 1);
      if (model == null) {
        continue;
      }
      final item = Tuple2(
        model.nameNew ?? "",
        SelectableText(model.contentNew ?? ""),
      );
      list.add(item);
    }
    tabItems = list;
    setState(() {});
  }

  onGenerate({String? fileName}) async {
    if (canDrag.value) {
      for (final e in tabItems) {
        try {
          onCreateFile(name: e.item1, content: e.item2.data ?? "");
        } catch (e) {
          debugPrint("❌$this $e");
          continue;
        }
      }
    } else {
      onCreateFile(
        name: fileName ?? "未知文件_${DateTime.now()}.dart",
        content: transformViewController.out,
      );
    }
  }

  onConvert({
    required String content,
  }) async {
    final model = await current.convert(content: content);
    if (model == null) {
      DLog.d("❌convert 转换失败");
      return;
    }

    transformViewController.out = model.contentNew ?? "";

    final isSuccess = await onCreateFile(
      name: model.nameNew ?? "",
      content: model.contentNew ?? "",
    );
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
    transformViewController.input = current.exampleTemplet();

    final model = await current.convert(
      content: transformViewController.input,
    );
    transformViewController.out = model?.contentNew ?? "";
    onGenerate(fileName: model?.nameNew);
  }

  onDrag(bool? val) async {
    canDrag.value = val ?? !canDrag.value;
    setState(() {});
  }
}
