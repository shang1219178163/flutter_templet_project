//
//  DraggableDemoPage.dart
//  fluttertemplet
//
//  Created by shang on 6/2/21 5:37 PM.
//  Copyright © 6/2/21 shang. All rights reserved.
//



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class DraggableDemoPage extends StatefulWidget {

  final String? title;

  DraggableDemoPage({ Key? key, this.title}) : super(key: key);

  
  @override
  _DraggableDemoPageState createState() => _DraggableDemoPageState();
}

class _DraggableDemoPageState extends State<DraggableDemoPage> {

  int acceptedData = 0;



  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: buildBody(context),
    );
  }


  Widget buildBody(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Draggable<int>(
          // Data is the value this Draggable stores.
          data: 10,
          child: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.lightGreenAccent,
            child: const Center(
              child: Text('Draggable'),
            ),
          ),
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
        ),
        DragTarget<int>(
          builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected,) {
            return Container(
              height: 100.0,
              width: 100.0,
              color: Colors.cyan,
              child: Center(
                child: Text('Value is updated to: $acceptedData', textAlign: TextAlign.center,),
              ),
            );
          },

          // onAccept: (int data) {
          //   setState(() {
          //     acceptedData += data;
          //   });
          // },
          onAccept: handleOnAccept,
        ),
      ],
    ).padding(top: 20);
  }

  void handleOnAccept(int data) {
    setState(() {
      acceptedData += data;
    });
  }
}

