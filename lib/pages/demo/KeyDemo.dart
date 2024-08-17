//
//  KeyDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2/1/23 3:23 PM.
//  Copyright © 2/1/23 shang. All rights reserved.
//

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

class KeyDemo extends StatefulWidget {
  const KeyDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _KeyDemoState createState() => _KeyDemoState();
}

class _KeyDemoState extends State<KeyDemo> {
  List<Widget> items = [
    Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.all(8.0),
      child: ColorBox(),
    ),
    Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.all(8.0),
      child: ColorBox(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: () {
                    debugPrint("${DateTime.now()}: $e");
                    setState(() {});
                  },
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: switchWidget,
        child: Icon(Icons.undo),
      ),
    );
  }

  switchWidget() {
    items.insert(0, items.removeAt(1));
    setState(() {});
  }
}

class ColorBox extends StatefulWidget {
  const ColorBox({Key? key}) : super(key: key);

  @override
  _ColorBoxState createState() => _ColorBoxState();
}

class _ColorBoxState extends State<ColorBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: ColorExt.random,
    );
  }
}
