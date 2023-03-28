//
//  TestFunction.dart
//  flutter_templet_project
//
//  Created by shang on 3/28/23 9:49 AM.
//  Copyright © 3/28/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class TestFunction extends StatefulWidget {

  TestFunction({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _TestFunctionState createState() => _TestFunctionState();
}

class _TestFunctionState extends State<TestFunction> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed,)
        ).toList(),
      ),
      body: Text(arguments.toString())
    );
  }

  fc(int n, int m, {operation: "add"}) {
    if (operation == "add") {
      return n + m;
    }
    return n - m;
  }

  onPressed() {
    int a = Function.apply(fc, [10, 3]);
    print("a: ${a}");//a: 13
    int b = Function.apply(fc, [10, 3], {new Symbol("operation"): "subtract"});
    print("b: ${b}");//b: 7
  }
}

