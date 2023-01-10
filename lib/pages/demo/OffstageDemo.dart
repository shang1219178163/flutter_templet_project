//
//  OffstageDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/6/21 2:25 PM.
//  Copyright © 12/6/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class OffstageDemo extends StatefulWidget {

  final String? title;

  OffstageDemo({ Key? key, this.title}) : super(key: key);


  @override
  _OffstageDemoState createState() => _OffstageDemoState();
}

class _OffstageDemoState extends State<OffstageDemo> {

  bool _offstage = true;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildOffstageExampele(),
    );
  }

  Widget _buildOffstageExampele() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Flutter logo is offstage: $_offstage'),
        ElevatedButton(
          child: const Text('Toggle Offstage Value'),
          onPressed: () {
            setState(() {
              _offstage = !_offstage;
            });
          },
        ),
        Offstage(
          offstage: _offstage,
          child: FlutterLogo(
            size: 150.0,
          ),
        ),
        if (_offstage) ElevatedButton(
            child: const Text('Get Flutter Logo size'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Flutter Logo'),
                ),
              );
            }
        ),
      ],
    );
  }
}



