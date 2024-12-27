//
//  WillPopScopeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/25/21 2:48 PM.
//  Copyright © 10/25/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class WillPopScopeDemo extends StatefulWidget {
  final String? title;

  const WillPopScopeDemo({Key? key, this.title}) : super(key: key);

  @override
  _WillPopScopeDemoState createState() => _WillPopScopeDemoState();
}

class _WillPopScopeDemoState extends State<WillPopScopeDemo> {
  /// onWillPop 返回值
  bool enable = true;

  /// onWillPop 事项为空
  bool onWillPopNull = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: null,// 为 null 可返回
      onWillPop: enable
          ? null
          : () async {
              await showAlert();
              return false;
            },
      child: buildPage(context),
    );
  }

  Future<void> showAlert() async {
    // 弹出确认对话框
    bool shouldPop = await showDialog(
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

  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildSwitch(
              name: 'onWillPop 返回：',
              value: enable,
              onChanged: (bool val) {
                enable = val;
                setState(() {});
              },
            ),
            buildSwitch(
              name: 'onWillPop 参数为空：',
              value: onWillPopNull,
              onChanged: (bool val) {
                onWillPopNull = val;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
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
