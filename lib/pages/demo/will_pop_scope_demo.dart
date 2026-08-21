//
//  WillPopScopeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/25/21 2:48 PM.
//  Copyright © 10/25/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class WillPopScopeDemo extends StatefulWidget {

  const WillPopScopeDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _WillPopScopeDemoState createState() => _WillPopScopeDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _WillPopScopeDemoState extends State<WillPopScopeDemo> {
  /// onWillPop 返回值
  bool enable = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: enable,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || enable) {
          return;
        }
        DLog.d(["onPopInvokedWithResult", didPop, result].join(", "));
        final shouldPop = await showAlert();
        DLog.d("shouldPop: $shouldPop");
        if (shouldPop) {
          Navigator.of(context).pop({"desc": runtimeType});
        }
      },
      child: buildPage(context),
    );
  }

  Widget buildWillPopScope(BuildContext context) {
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

  Future<bool> showAlert({String message = ""}) async {
    // 弹出确认对话框
    var shouldPop = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("确认"),
              content: Text("你确定要离开这个页面吗？$message"),
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
            );
          },
        ) ??
        false;
    return shouldPop;
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
            SwitchListTile(
              title: Text('直接返回'),
              value: enable,
              onChanged: (val) {
                enable = val;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('enable', enable));
  }
}
