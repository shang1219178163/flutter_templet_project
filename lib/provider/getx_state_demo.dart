//
//  GetxStateDemo.dart
//  flutter_templet_project
//
//  Created by shang on 11/23/21 3:06 PM.
//  Copyright © 11/23/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:get/get.dart';

class GetxStateDemo extends StatelessWidget {
  const GetxStateDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GetX"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    /// 通过依赖注入方式实例化的控制器
    final counter = Get.put(CounterController());
    final counter1 = Get.put(CounterController());
    final isOne = (counter == counter1); //重复put时不会重复插入,可通过此方式避免使用时没有注入的问题;
    DLog.d([counter.hashCode, counter1.hashCode, isOne].asMap());

    return Scrollbar(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    "count的值为：${counter.count}",
                    style: const TextStyle(color: Colors.redAccent, fontSize: 20),
                  )),
              GetX<CounterController>(
                init: counter,
                builder: (controller) {
                  return Text(
                    "count的值为：${controller.count}",
                    style: const TextStyle(color: Colors.redAccent, fontSize: 20),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                // 按钮点击count值++
                onPressed: () {
                  counter.increase();
                },
                child: const Text("点击count++"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CounterController extends GetxController {
  final count = 0.obs;

  final count1 = 1.obs;
  final count2 = 2.obs;

  int get sum => count1.value + count2.value;

  increase() {
    count.value++;
    update();
  }
}
