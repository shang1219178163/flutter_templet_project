//
//  LocalAuthDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/8/20 20:42.
//  Copyright © 2025/8/20 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_button.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

/// 生物识别技术（例如指纹或面部识别） https://pub.dev/packages/local_auth
class LocalAuthDemo extends StatefulWidget {
  const LocalAuthDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<LocalAuthDemo> createState() => _LocalAuthDemoState();
}

class _LocalAuthDemoState extends State<LocalAuthDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant LocalAuthDemo oldWidget) {
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
            NButton(
              title: "开始",
              onPressed: authBiometrics,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> authBiometrics() async {
    final auth = LocalAuthentication();

    final isDeviceSupported = await auth.isDeviceSupported();
    if (!isDeviceSupported) {
      DLog.d("设备不支持");
      return false;
    }

    final canAuthWithBiometrics = await auth.canCheckBiometrics;
    if (!canAuthWithBiometrics) {
      DLog.d("设备不支持1");
      return false;
    }

    final availableBiometrics = await auth.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) {
      DLog.d("不可用");
      return false;
    }
    DLog.d("availableBiometrics: $availableBiometrics");
    return true;
  }
}
