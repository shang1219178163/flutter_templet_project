//
//  DividerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/9/19 21:40.
//  Copyright © 2025/9/19 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:get/get.dart';

class DividerDemo extends StatefulWidget {
  const DividerDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<DividerDemo> createState() => _DividerDemoState();
}

class _DividerDemoState extends State<DividerDemo> {
  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  final heightVN = ValueNotifier(50.0);
  final thicknessVN = ValueNotifier(10.0);
  final indentVN = ValueNotifier(50.0);
  final endIndentVN = ValueNotifier(50.0);

  @override
  void didUpdateWidget(covariant DividerDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

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
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([
                heightVN,
                thicknessVN,
                indentVN,
                endIndentVN,
              ]),
              builder: (context, child) {
                return Row(
                  children: [
                    Container(
                      width: 180,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Divider(
                        color: Colors.green,
                        height: heightVN.value,
                        thickness: thicknessVN.value,
                        indent: indentVN.value,
                        endIndent: endIndentVN.value,
                      ),
                    ),
                    Container(
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                      ),
                      child: VerticalDivider(
                        color: Colors.green,
                        width: heightVN.value,
                        thickness: thicknessVN.value,
                        indent: indentVN.value,
                        endIndent: endIndentVN.value,
                      ),
                    ),
                  ],
                );
              },
            ),
            NSlider(
              leading: Text("height"),
              min: 10,
              max: 100,
              value: heightVN.value,
              onChanged: (v) {
                heightVN.value = v;
              },
            ),
            NSlider(
              leading: Text("thickness"),
              min: 1,
              max: 20,
              value: thicknessVN.value,
              onChanged: (v) {
                thicknessVN.value = v;
              },
            ),
            NSlider(
              leading: Text("indent"),
              min: 10,
              max: 100,
              value: indentVN.value,
              onChanged: (v) {
                indentVN.value = v;
              },
            ),
            NSlider(
              leading: Text("endIndent"),
              min: 10,
              max: 100,
              value: endIndentVN.value,
              onChanged: (v) {
                endIndentVN.value = v;
              },
            ),
          ],
        ),
      ),
    );
  }
}
