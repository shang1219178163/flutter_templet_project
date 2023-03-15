//
//  TooltipDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/15/23 9:20 AM.
//  Copyright © 3/15/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class TooltipDemo extends StatefulWidget {

  TooltipDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _TooltipDemoState createState() => _TooltipDemoState();
}

class _TooltipDemoState extends State<TooltipDemo> {


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
          onPressed: () => print(e),)
        ).toList(),
      ),
      body: Center(
        child: _buildTooltip(),
      )
    );
  }
  
  _buildTooltip() {
    return Tooltip(
      preferBelow: false,
      padding: EdgeInsets.symmetric(horizontal: 40,vertical: 5),
      margin: EdgeInsets.all(10),
      verticalOffset: 15,
      message: "Tooltip",
      textStyle: TextStyle(
        color: Colors.red,
        shadows: [
          Shadow(
            color: Colors.white,
            offset: Offset(1, 1),
          ),
        ],
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.orangeAccent,
          offset: Offset(1, 1),
          blurRadius: 8,
        )
      ]),
      child: Icon(Icons.info_outline)
    );
  }

}