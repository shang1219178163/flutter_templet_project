//
//  FractionallySizedBoxDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/24/23 4:39 PM.
//  Copyright © 3/24/23 shang. All rights reserved.
//



import 'package:flutter/material.dart';

class FractionallySizedBoxDemo extends StatefulWidget {

  const FractionallySizedBoxDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _FractionallySizedBoxDemoState createState() => _FractionallySizedBoxDemoState();
}

class _FractionallySizedBoxDemoState extends State<FractionallySizedBoxDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint(e),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: Align(
        alignment: Alignment.center,
        child: FractionallySizedBox(
          widthFactor: .5,
          heightFactor: .5,
          child: ElevatedButton(
            onPressed: () { debugPrint("button"); },
            child: Text('button'),
          ),
        ),
      )
    );
  }

}
