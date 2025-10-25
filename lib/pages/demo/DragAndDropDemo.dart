//
//  DragAndDropDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/10/22 4:07 PM.
//  Copyright © 10/10/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/drag_destination_view.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

class DragAndDropDemo extends StatefulWidget {
  final String? title;

  const DragAndDropDemo({Key? key, this.title}) : super(key: key);

  @override
  _DragAndDropDemoState createState() => _DragAndDropDemoState();
}

class _DragAndDropDemoState extends State<DragAndDropDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Container(
        child: FractionallySizedBox(
          heightFactor: 0.9,
          widthFactor: 0.5,
          child: DragDestinationView(
            onChanged: (files) {
              DLog.d("file: ${files.map((e) => e.path).join("\n")}");
            },
          ),
        ),
      ),
    );
  }
}
