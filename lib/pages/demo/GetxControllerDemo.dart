import 'package:flutter/material.dart';
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
  bool get hideApp =>
      "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final tagController = Get.put(TagGetxController());

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
          children: [
            Text("$widget"),
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
}
