//
//  IndexedStackDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/28/21 5:46 PM.
//  Copyright © 10/28/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class IndexedStackDemo extends StatefulWidget {

  final String? title;

  const IndexedStackDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _IndexedStackDemoState createState() => _IndexedStackDemoState();
}

class _IndexedStackDemoState extends State<IndexedStackDemo> {

  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: SizedBox (
        width: double.infinity,
        height: double.infinity,
        child: IndexedStack (
            alignment: Alignment.center,
            index: selectedIndex,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                color: Colors.green,
              ),
              Container(
                width: 250,
                height: 250,
                color: Colors.red,
              ),
              Container(
                width: 300,
                height: 300,
                color: Colors.yellow,
              ),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if(selectedIndex < 2)  {
              selectedIndex++;
            } else {
              selectedIndex = 0;
            }
          });
        },
        child: Text("Next"),
      ),
    );
  }

}

