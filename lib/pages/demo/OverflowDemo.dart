//
//  OverflowDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2/3/23 6:23 PM.
//  Copyright © 2/3/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class OverflowDemo extends StatefulWidget {
  const OverflowDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _OverflowDemoState createState() => _OverflowDemoState();
}

class _OverflowDemoState extends State<OverflowDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: () => debugPrint(e.toString()),
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Container(
      color: Colors.yellow,
      width: 200.0,
      height: 200.0,
      padding: const EdgeInsets.all(15.0),
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxWidth: 300.0,
        maxHeight: 300.0,
        child: Container(
          color: Colors.greenAccent,
          width: 500.0,
          height: 500.0,
        ),
      ),
    );
  }
}
