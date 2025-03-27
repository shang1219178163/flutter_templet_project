//
//  PopScopeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/10/29 17:26.
//  Copyright © 2024/10/29 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

class PopScopeDemo extends StatefulWidget {
  const PopScopeDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<PopScopeDemo> createState() => _PopScopeDemoState();
}

class _PopScopeDemoState extends State<PopScopeDemo> {
  var canPop = false;

  @override
  void didUpdateWidget(covariant PopScopeDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      //popGesture: false 时 iOS 生效
      canPop: canPop,
      onPopInvoked: (pop) async {
        DLog.d("onPopInvoked: $pop");
        await showAlert();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("PopScope 示例")),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Text("按返回按钮会弹出确认对话框")),
              buildSwitch(
                name: '可以返回 canPop：',
                value: canPop,
                onChanged: (bool val) {
                  canPop = val;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAlert() async {
    // 弹出确认对话框
    var shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("确认"),
            content: Text("你确定要离开这个页面吗？"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("取消"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("确定"),
              ),
            ],
          ),
        ) ??
        false;
    DLog.d("shouldPop: $shouldPop");
    if (shouldPop) {
      Navigator.of(context).pop();
    }
  }

  Widget buildSwitch({
    required String name,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(name),
        Switch(
          value: value,
          onChanged: onChanged,
        )
      ],
    );
  }
}
