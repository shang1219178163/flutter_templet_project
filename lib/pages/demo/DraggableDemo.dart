//
//  DraggableDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/2/21 5:37 PM.
//  Copyright © 6/2/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class DraggableDemo extends StatefulWidget {
  final String? title;

  const DraggableDemo({Key? key, this.title}) : super(key: key);

  @override
  _DraggableDemoState createState() => _DraggableDemoState();
}

class _DraggableDemoState extends State<DraggableDemo> {
  int acceptedData = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Draggable<int>(
          data: 10,
          feedback: Container(
            color: Colors.deepOrange,
            height: 100,
            width: 100,
            child: const Icon(Icons.directions_run),
          ),
          childWhenDragging: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.pinkAccent,
            child: const Center(
              child: Text('Child When Dragging'),
            ),
          ),
          child: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.lightGreenAccent,
            child: const Center(
              child: Text('Draggable'),
            ),
          ),
        ),
        DragTarget<int>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Container(
              height: 100.0,
              width: 100.0,
              color: Colors.cyan,
              child: Center(
                child: Text(
                  'Value is updated to: $acceptedData',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          // onAccept: (int data) {
          //   setState(() {
          //     acceptedData += data;
          //   });
          // },
          onAcceptWithDetails: handleOnAccept,
        ),
      ],
    );
  }

  void handleOnAccept(DragTargetDetails details) {
    final int data = details.data;
    setState(() {
      acceptedData += data;
    });
  }
}
