//
//  ButtonStyleDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/19/23 2:37 PM.
//  Copyright © 1/19/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class ButtonStyleDemo extends StatefulWidget {

  const ButtonStyleDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ButtonStyleDemoState createState() => _ButtonStyleDemoState();
}

class _ButtonStyleDemoState extends State<ButtonStyleDemo> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint(e.toString()),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: Column(
        children: [
          _buildButton()
        ],
      )
    );
  }

  _buildButton() {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          debugPrint("states:$states");
          if (states.contains(MaterialState.pressed)) {
            return Colors.pink;
          }
          return Colors.black87;
        }),
      ),
      child: Text('Change My Color', style: TextStyle(fontSize: 15),
      ),
    );
  }

}



