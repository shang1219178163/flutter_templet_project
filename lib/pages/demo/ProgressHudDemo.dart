//
//  ProgressHudDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/27/21 5:15 PM.
//  Copyright © 7/27/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/hud/progress_hud_popup.dart';

class ProgressHudDemo extends StatefulWidget {
  final String? title;

  const ProgressHudDemo({Key? key, this.title}) : super(key: key);

  @override
  _ProgressHudDemoState createState() => _ProgressHudDemoState();
}

class _ProgressHudDemoState extends State<ProgressHudDemo> {
  ButtonStyle get buttonStyle => TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        minimumSize: Size(100, 30),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done']
            .map((e) => TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text(e),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.only(top: 80),
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextButton(
            style: buttonStyle,
            onPressed: () async {
              ProgressHudPopupExt.loading(context);
              await Future.delayed(Duration(seconds: 2));
              ProgressHudPopupExt.dismiss(context);
            },
            child: Text("loading"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () async {
              ProgressHudPopupExt.loading(context, message: "loading");
              await Future.delayed(Duration(seconds: 2));
              ProgressHudPopupExt.dismiss(context);
            },
            child: Text("loadingMessage"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              ProgressHudPopupExt.success(context);
            },
            child: Text("success"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              ProgressHudPopupExt.success(context, message: "success");
            },
            child: Text("successMessage"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              ProgressHudPopupExt.error(context);
            },
            child: Text("error"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              ProgressHudPopupExt.error(context, message: "error");
            },
            child: Text("errorMessage"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              ProgressHudPopupExt.toast(
                context,
                message: "这是一个 NProgressHudPopupExt.toast 类型的文字提示 toast.",
              );
            },
            child: Text("showToast"),
          ),
        ]
            .map((e) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: e,
                ))
            .toList(),
      ),
    );
  }
}
