//
//  GetxStateDemo.dart
//  flutter_templet_project
//
//  Created by shang on 11/23/21 3:06 PM.
//  Copyright © 11/23/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetxStateDemoNew extends StatefulWidget {
  GetxStateDemoNew({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<GetxStateDemoNew> createState() => _GetxStateDemoNewState();
}

class _GetxStateDemoNewState extends State<GetxStateDemoNew> {
  final _scrollController = ScrollController();

  var count = 0.obs;

  final desc = "GetX".obs;

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
                  onPressed: () => debugPrint(e),
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
            Text("$widget"),
            Obx(() => Text(desc.value)),
            Obx(() => Text(
                  "count的值为：$count",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 20),
                )),
            ObxValue(
              (data) => Switch(
                value: data.value,
                onChanged: (flag) {
                  data.value = flag;
                  debugPrint("data: ${data.value}, ${data.runtimeType}");
                },
              ),
              false.obs,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              // 按钮点击count值++
              onPressed: () {
                count++;
                desc.value += "_9";
              },
              child: const Text("点击count++"),
            )
          ],
        ),
      ),
    );
  }
}
