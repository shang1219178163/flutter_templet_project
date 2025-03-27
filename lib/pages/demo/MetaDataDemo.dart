//
//  MetaDataDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/27 09:07.
//  Copyright © 2025/3/27 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/type_util.dart';
import 'package:get/get.dart';

class MetaDataDemoNew extends StatelessWidget {
  const MetaDataDemoNew({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context) {
    // dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("$this"),
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
      body: Text(arguments.toString()),
    );
  }
}

class MetaDataDemo extends StatefulWidget {
  const MetaDataDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<MetaDataDemo> createState() => _MetaDataDemoState();
}

class _MetaDataDemoState extends State<MetaDataDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  late final items = <ActionRecord>[
    (e: "onTest", action: onTest),
  ];

  @override
  void didUpdateWidget(covariant MetaDataDemo oldWidget) {
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
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionBox(items: items),
              MetaData(
                metaData: {'key': 'MetaData', 'value': 'MetaData自定义数据'},
                child: Builder(
                  builder: (context) {
                    // 通过 context 获取 MetaData
                    final metaData = context.findAncestorWidgetOfExactType<MetaData>()?.metaData;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            DLog.d('MetaData 参数: $metaData');
                          },
                          child: Text('打印 MetaData'),
                        ),
                        SizedBox(height: 20),
                        Text('MetaData: ${metaData ?? "-"}'),
                      ],
                    );
                  },
                ),
              ),
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

  void onTest() {
    // DLog.d("AAA");
    try {
      var map = {};
      jsonDecode(map["a"]);
    } catch (e) {
      debugPrint("$this $e"); //flutter: _MetaDataDemoState#d5486 type 'Null' is not a subtype of type 'String'
      DLog.d(
          "$e"); //[log] [2025-03-27 10:13:00.725182][DEBUG][ios][_MetaDataDemoState.onTest Line:161]: type 'Null' is not a subtype of type 'String'
      DLog.i(
          "$e"); //[log] [2025-03-27 10:13:00.725901][INFO][ios][_MetaDataDemoState.onTest Line:162]: type 'Null' is not a subtype of type 'String'
      DLog.w(
          "$e"); //[log] [2025-03-27 10:13:00.726502][WARN][ios][_MetaDataDemoState.onTest Line:163]: type 'Null' is not a subtype of type 'String'
      DLog.e(
          "$e"); //[log] [2025-03-27 10:13:00.727041][ERROR][ios][_MetaDataDemoState.onTest Line:164]: type 'Null' is not a subtype of type 'String'
    }
  }
}
