//
//  ActivityIndicatorPlacehorlder.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/7 15:27.
//  Copyright © 2026/1/7 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

/// 加载中占位图
class ActivityIndicatorPlacehorlder extends StatelessWidget {
  const ActivityIndicatorPlacehorlder({
    super.key,
    this.icon,
    this.text,
    this.message,
  });

  final Widget? icon;
  final Widget? text;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          // color: Colors.green,
          // border: Border.all(color: Colors.blue),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? const CupertinoActivityIndicator(),
          text ??
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(message ?? "加载中..."),
              )
        ],
      ),
    );
  }
}
