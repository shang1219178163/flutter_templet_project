//
//  MetaDataDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/27 09:07.
//  Copyright © 2025/3/27 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/type_util.dart';
import 'package:get/get.dart';

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
    DLog.d("AAA");
  }
}
