//
//  ScanBarcodeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/21 09:59.
//  Copyright © 2025/3/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanBarcodeDemo extends StatefulWidget {
  const ScanBarcodeDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ScanBarcodeDemo> createState() => _ScanBarcodeDemoState();
}

class _ScanBarcodeDemoState extends State<ScanBarcodeDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant ScanBarcodeDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

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
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Text("$widget"),
          ],
        ),
      ),
    );
  }
}
