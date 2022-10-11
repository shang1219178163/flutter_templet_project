//
//  FittedBoxDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 2:12 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class FittedBoxDemo extends StatefulWidget {

  final String? title;

  FittedBoxDemo({ Key? key, this.title}) : super(key: key);


  @override
  _FittedBoxDemoState createState() => _FittedBoxDemoState();
}

class _FittedBoxDemoState extends State<FittedBoxDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.green,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
        child: Image.asset("images/avatar.png", width: 200, height: 100),
      ),
    );
  }

}



