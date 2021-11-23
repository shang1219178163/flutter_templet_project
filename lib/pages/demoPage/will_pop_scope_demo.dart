//
//  WillPopScopeDemo.dart
//  fluttertemplet
//
//  Created by shang on 10/25/21 2:48 PM.
//  Copyright © 10/25/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:fluttertemplet/dartExpand/ddlog.dart';

class WillPopScopeDemo extends StatefulWidget {

  final String? title;

  WillPopScopeDemo({ Key? key, this.title}) : super(key: key);


  @override
  _WillPopScopeDemoState createState() => _WillPopScopeDemoState();
}

class _WillPopScopeDemoState extends State<WillPopScopeDemo> {

  bool _disable = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: buildPage(context),
        onWillPop: () async {
          return !_disable;
        });
  }

  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('不可返回：'),
              Switch(
                value: _disable,
                onChanged: (bool val) {
                  setState(() {
                    _disable = val;
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  void handleAction() {
    ddlog("obj");
  }

  void handleAction1() {
    ddlog('我是外面的按钮，不受影响');
  }
}
