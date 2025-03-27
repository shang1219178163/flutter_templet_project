import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/type_util.dart';
import 'package:flutter_templet_project/network/controller/tag_gex_controller.dart';
import 'package:get/get.dart';

class GetxControllerDemo extends StatefulWidget {
  GetxControllerDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<GetxControllerDemo> createState() => _GetxControllerDemoState();
}

class _GetxControllerDemoState extends State<GetxControllerDemo> {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final tagController = Get.put(TagGetxController());

  late final items = <ActionRecord>[
    (e: "onTest", action: onTest),
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
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: buildSectionBox(items: items),
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    tagController.increment();
                  },
                  child: Text("加"),
                ),
                OutlinedButton(
                  onPressed: () {
                    tagController.updateCount(onUpdate: (val) {
                      val.value--;
                    });
                  },
                  child: Text("减少"),
                ),
              ],
            ),
            GetBuilder<TagGetxController>(
              builder: (controller) {
                return Text(
                  "计数器值为: ${controller.count}",
                  style: TextStyle(color: Colors.red, fontSize: 30),
                );
              },
            ),
            GetBuilder<TagGetxController>(
              id: 'jimi_count',
              builder: (controller) {
                return Text(
                  "计数器值为: ${controller.count}",
                  style: TextStyle(color: Colors.green, fontSize: 30),
                );
              },
            ),
          ],
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
    final tagController = Get.put(TagGetxController());
    final tagController1 = Get.put(TagGetxController());
    DLog.d([tagController, tagController1, tagController == tagController1].asMap());
  }
}
