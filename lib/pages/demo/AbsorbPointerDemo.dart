//
//  AbsorbPointerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/25/21 11:05 AM.
//  Copyright © 10/25/21 shang. All rights reserved.
//
// AbsorbPointer本身可以接收点击事件，消耗掉事件，而IgnorePointer无法接收点击事件，其下的控件可以接收到点击事件（不是子控件）。


import "package:flutter/material.dart";
import 'package:flutter_templet_project/extension/ddlog.dart';

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
                  _disable = val;
                  setState(() {});
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
                      _switchValue = val;
                      setState(() {});
                    },
                  ),
                  MaterialButton(
                    color: Colors.green,
                    onPressed: () => onClick('我是按钮'),
                    child: Text('我是按钮'),
                  ),
                  buildBody1(),
                  Divider(),
                  _buildAbsorbPointer(),
                ],
              ),
            ),
          ),
          MaterialButton(
            color: Colors.lightBlue,
            onPressed: () => onClick('我是外面的按钮，不受影响'),
            child: Text('我是外面的按钮，不受影响'),
          ),
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
              onClick('click red');
            },
            child: Container(
              color: Colors.red,
            ),
          ),
          Listener(
            onPointerDown: (v) {
              onClick('click blue self');
            },
            child: AbsorbPointer(
              absorbing: true,
              child: InkWell(
                onTap: () => onClick('Colors.blue'),
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

  /// 默认允许穿透
  _buildAbsorbPointer({bool absorbing = true}) {
    return Listener(
      onPointerDown: (e) => onClick("up"),
      child: AbsorbPointer(
        absorbing: absorbing,
        child: Listener(
          onPointerDown: (e) => onClick("in"),
          child: Container(
            color: Colors.yellow,
            width: 200.0,
            height: 100.0,
          ),
        ),
      ),
    );
  }

  onClick(String msg) {
    ddlog(msg);
  }
}

