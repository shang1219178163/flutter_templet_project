//
//  PositionedDirectionalDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 4:32 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class PositionedDirectionalDemo extends StatefulWidget {

  final String? title;

  const PositionedDirectionalDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _PositionedDirectionalDemoState createState() => _PositionedDirectionalDemoState();
}

class _PositionedDirectionalDemoState extends State<PositionedDirectionalDemo> {


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
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: 10,
          end: 10,
          top: 10,
          bottom: 10,
          child: Container(
            color: Colors.red,
            child: Icon(Icons.sentiment_very_satisfied, color: Colors.white),
          ),
        ),
      ],
    );
  }
}



