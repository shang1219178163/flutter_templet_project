//
//  ClickNotificationDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/9/12 20:42.
//  Copyright © 2025/9/12 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_tap_gesture_intercept.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class ClickNotificationDemo extends StatelessWidget {
  const ClickNotificationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("页面点击拦截")),
      body: NTapGestureIntercept(
        ignoring: true,
        onTap: () {
          DLog.d('页面点击事件');
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // decoration: BoxDecoration(color: Colors.green),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  debugPrint("按钮1");
                },
                child: Text("按钮1"),
              ),
              ElevatedButton(
                onPressed: () {
                  debugPrint("按钮2");
                },
                child: Text("按钮2"),
              ),
              GestureDetector(
                onTap: () {
                  debugPrint("点击黄色区域");
                },
                child: Container(
                  color: Colors.yellow,
                  padding: EdgeInsets.all(20),
                  child: Text("点击黄色区域"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
