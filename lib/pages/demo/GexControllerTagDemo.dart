//
//  GexControllerTagDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/11 20:18.
//  Copyright © 2024/9/11 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/network/controller/tag_gex_controller.dart';
import 'package:get/get.dart';

class GexControllerTagDemo extends StatefulWidget {
  const GexControllerTagDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<GexControllerTagDemo> createState() => _GexControllerTagDemoState();
}

class _GexControllerTagDemoState extends State<GexControllerTagDemo> {
  String controllerTag = "controllerTag";
  String controllerTagOne = "controllerTagOne";

  final moduleController = Get.put(TagGetxController(), tag: "controllerTag");
  final moduleControllerOne =
      Get.put(TagGetxController(), tag: "controllerTagOne");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Text("通过 tag 创造多个内存实例"),
        Row(
          children: [
            Expanded(
              child: GetBuilder<TagGetxController>(
                tag: controllerTag,
                builder: (controller) {
                  return Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(controllerTag),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: GetBuilder<TagGetxController>(
                tag: controllerTagOne,
                builder: (controller) {
                  return Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(controllerTagOne),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
