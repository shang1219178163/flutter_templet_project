//
//  ProgressHudDemo.dart
//  fluttertemplet
//
//  Created by shang on 7/27/21 5:15 PM.
//  Copyright © 7/27/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertemplet/basicWidget/hud/progresshud.dart';
import 'package:fluttertemplet/dartExpand/ddlog.dart';

class ProgressHudDemo extends StatefulWidget {
  final String? title;

  ProgressHudDemo({Key? key, this.title}) : super(key: key);

  @override
  _ProgressHudDemoState createState() => _ProgressHudDemoState();
}

class _ProgressHudDemoState extends State<ProgressHudDemo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 80),
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: () {
                NNProgressHUD.showLoading(context);
              },
              child: Text("showLoading"),
              color: Colors.blue),
          FlatButton(
              onPressed: () {
                NNProgressHUD.showLoading(context, message: "loading");
              },
              child: Text("showLoadingMessage"),
              color: Colors.blue),
          FlatButton(
              onPressed: () {
                NNProgressHUD.showSuccess(context);
              },
              child: Text("showSuccess"),
              color: Colors.blue),
          FlatButton(
              onPressed: () {
                NNProgressHUD.showSuccess(context, message: "success");
              },
              child: Text("showSuccessMessage"),
              color: Colors.blue),
          FlatButton(
              onPressed: () {
                NNProgressHUD.showError(context);
              },
              child: Text("showError"),
              color: Colors.blue),
          FlatButton(
              onPressed: () {
                NNProgressHUD.showError(context, message: "error");
              },
              child: Text("showErrorMessage"),
              color: Colors.blue),
          FlatButton(
              onPressed: () {
                NNProgressHUD.showToast(context, message: "这是一个 NNProgressHUD.toast 类型的文字提示 toast.");
              },
              child: Text("showToast"),
              color: Colors.blue),
        ],
      ),
    );
  }
}
