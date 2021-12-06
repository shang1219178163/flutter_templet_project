//
//  AbsorbPointerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/25/21 11:05 AM.
//  Copyright © 10/25/21 shang. All rights reserved.
//


import "package:flutter/material.dart";
import 'package:flutter_templet_project/extensions/ddlog.dart';

class AbsorbPointerDemo extends StatefulWidget {
  @override
  _AbsorbPointerDemoState createState() => _AbsorbPointerDemoState();
}

class _AbsorbPointerDemoState extends State<AbsorbPointerDemo> {
  bool _disable = false;
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absorbpointer'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('不可点击：'),
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
          Container(
            child: AbsorbPointer(
              absorbing: _disable,
              child: Column(
                children: <Widget>[
                  Switch(
                    value: _switchValue,
                    onChanged: (bool val) {
                      setState(() {
                        _switchValue = val;
                      });
                    },
                  ),
                  MaterialButton(
                    color: Colors.green,
                    child: Text('我是按钮'),
                    onPressed: handleAction,
                  ),
                  buildBody1(),
                  Divider(),
                ],
              ),
            ),
          ),
          MaterialButton(
            color: Colors.lightBlue,
            child: Text('我是外面的按钮，不受影响'),
            onPressed: handleAction1,
          )
        ],
      ),
    );
  }

  Widget buildBody1() {
    return Container(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Listener(
            onPointerDown: (v) {
              print('click red');
            },
            child: Container(
              color: Colors.red,
            ),
          ),
          Listener(
            onPointerDown: (v) {
              print('click blue self');
            },
            child: AbsorbPointer(
              absorbing: true,
              child: Listener(
                onPointerDown: (v) {
                  print('click blue child');
                },
                child: Container(
                  color: Colors.blue,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
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

