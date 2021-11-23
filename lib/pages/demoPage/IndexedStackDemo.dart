//
//  IndexedStackDemo.dart
//  fluttertemplet
//
//  Created by shang on 10/28/21 5:46 PM.
//  Copyright © 10/28/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class IndexedStackDemo extends StatefulWidget {

  final String? title;

  IndexedStackDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _IndexedStackDemoState createState() => _IndexedStackDemoState();
}

class _IndexedStackDemoState extends State<IndexedStackDemo> {

  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Flutter IndexedStack Example")
      ),
      body: SizedBox (
        width: double.infinity,
        height: double.infinity,
        child: IndexedStack (
            alignment: Alignment.center,
            index: this.selectedIndex,
            children: <Widget>[
              Container(
                width: 290,
                height: 210,
                color: Colors.green,
              ),
              Container(
                width: 250,
                height: 170,
                color: Colors.red,
              ),
              Container(
                width: 220,
                height: 150,
                color: Colors.yellow,
              ),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Next"),
        onPressed: () {
          setState(() {
            if(this.selectedIndex < 2)  {
              this.selectedIndex++;
            } else {
              this.selectedIndex = 0;
            }
          });
        },
      ),
    );
  }

}

