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

  const ValueListenableBuilderDemo({Key? key, this.title}) : super(key: key);

  @override
  _ValueListenableBuilderDemoState createState() =>
      _ValueListenableBuilderDemoState();
}

class _ValueListenableBuilderDemoState
    extends State<ValueListenableBuilderDemo> {
  final _counter = ValueNotifier<int>(0);
  final netState = ValueNotifier<MyResult>(MyResult.mobile);

  final Widget goodJob = const Text('Good job!');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? "$widget")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              builder: (BuildContext context, int value, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('$value'),
                    child!,
                  ],
                );
              },
              child: goodJob,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: MyResult.values
                  .map((e) => FloatingActionButton.extended(
                        onPressed: () => netState.value = e,
                        label: Text("$e".split(".")[1]),
                      ))
                  .toList(),
            ),
            ValueListenableBuilder<MyResult>(
              valueListenable: netState,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('$value'),
                    child!,
                  ],
                );
              },
              child: const Text("child"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _counter.value += 1,
        child: const Icon(Icons.plus_one),
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
