//
//  DragAndDropDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/10/22 4:07 PM.
//  Copyright © 10/10/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/drag_destination_view.dart';

class DragAndDropDemo extends StatefulWidget {
  final String? title;

  const DragAndDropDemo({Key? key, this.title}) : super(key: key);

  @override
  _DragAndDropDemoState createState() => _DragAndDropDemoState();
}

class _DragAndDropDemoState extends State<DragAndDropDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Container(
          // constraints: BoxConstraints(
          // maxWidth: 120,
          // maxHeight: 200,
          // minWidth: 120,
          // minHeight: 200,
          // ),
          // width: 120,
          // height: 200,
          child: FractionallySizedBox(
            heightFactor: 0.5,
            widthFactor: 0.5,
            child: DragDestinationView(),
          ),
        ));
  }
}
