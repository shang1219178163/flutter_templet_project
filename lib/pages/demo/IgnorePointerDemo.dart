//
//  IgnorePointerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/11/23 8:47 AM.
//  Copyright © 1/11/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class IgnorePointerDemo extends StatefulWidget {

  const IgnorePointerDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _IgnorePointerDemoState createState() => _IgnorePointerDemoState();
}

class _IgnorePointerDemoState extends State<IgnorePointerDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => print(e),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: buildBody()
    );
  }

  buildBody() {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            print("${DateTime.now()}点击A");
          },
          child: Container(
            width: 200,
            height: 200,
            color: Colors.amber,
            alignment: Alignment.center,
            child: const Text('A'),
          ),
        ),
        IgnorePointer(
          // ignoring: false,
          child: InkWell(
            onTap: () {
              print("${DateTime.now()}点击B");
            },
            child: Container(
              width: 50,
              height: 50,
              color: Colors.red,
              alignment: Alignment.center,
              child: const Text('B'),
            )),
        ),
      ],
    );
  }
}