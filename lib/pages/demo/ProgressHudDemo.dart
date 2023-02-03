//
//  ProgressHudDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/27/21 5:15 PM.
//  Copyright © 7/27/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/hud/progresshud.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class ProgressHudDemo extends StatefulWidget {
  final String? title;

  ProgressHudDemo({Key? key, this.title}) : super(key: key);

  @override
  _ProgressHudDemoState createState() => _ProgressHudDemoState();
}

class _ProgressHudDemoState extends State<ProgressHudDemo> {


  ButtonStyle get buttonStyle => TextButton.styleFrom(
    minimumSize: Size(100, 30),
    backgroundColor: Colors.blue,
    primary: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
  );

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          FlatButton(
            onPressed: () {
              ddlog("done");
            },
            child: Text("done"),
          ),
        ],
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
            onPressed: () {
              NNProgressHUD.showLoading(context);
            },
            child: Text("showLoading"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              NNProgressHUD.showLoading(context, message: "loading");
            },
            child: Text("showLoadingMessage"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              NNProgressHUD.showSuccess(context);
            },
            child: Text("showSuccess"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              NNProgressHUD.showSuccess(context, message: "success");
            },
            child: Text("showSuccessMessage"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              NNProgressHUD.showError(context);
            },
            child: Text("showError"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              NNProgressHUD.showError(context, message: "error");
            },
            child: Text("showErrorMessage"),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: () {
              NNProgressHUD.showToast(context, message: "这是一个 NNProgressHUD.toast 类型的文字提示 toast.");
            },
            child: Text("showToast"),
          ),
        ].map((e) => Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: e,
        )).toList(),
      ),
    );
  }

}
