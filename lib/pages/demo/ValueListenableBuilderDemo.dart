//
//  ValueListenableBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 5:09 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class ValueListenableBuilderDemo extends StatefulWidget {

  final String? title;

  ValueListenableBuilderDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _ValueListenableBuilderDemoState createState() => _ValueListenableBuilderDemoState();
}

class _ValueListenableBuilderDemoState extends State<ValueListenableBuilderDemo> {

  var _counter = ValueNotifier<int>(0);
  final netState = ValueNotifier<MyResult>(MyResult.mobile);

  final Widget goodJob = const Text('Good job!');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title ?? "$widget")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              child: goodJob,
              builder: (BuildContext context, int value, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('$value'),
                    child!,
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:MyResult.values.map((e) => FloatingActionButton(
                child: Text("$e".split(".")[1]),
                onPressed: () => netState.value = e,
              )).toList(),
            ),
            ValueListenableBuilder<MyResult>(
              valueListenable: netState,
              child: const Text("child"),
              builder: (context, value,  child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('$value'),
                    child!,
                  ],
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one),
        onPressed: () => _counter.value += 1,
      ),
    );
  }
}


enum MyResult {
  /// WiFi: Device connected via Wi-Fi
  wifi,

  /// Mobile: Device connected to cellular network
  mobile,

  /// None: Device not connected to any network
  none
}