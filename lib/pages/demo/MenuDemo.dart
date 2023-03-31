//
//  MenuDemo.dart
//  flutter_templet_project
//
//  Created by shang on 8/17/21 8:42 AM.
//  Copyright © 8/17/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class MenuDemo extends StatefulWidget {

  final String? title;

  const MenuDemo({ Key? key, this.title}) : super(key: key);


  @override
  _MenuDemoState createState() => _MenuDemoState();
}

class _MenuDemoState extends State<MenuDemo> {




  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            _buildDropdownButton(),
          ],
        ),
        body: Text(arguments.toString())
    );
  }


  final items = [
    DropdownMenuItem(value: 0,child: Text('语文'),),
    DropdownMenuItem(value: 1, child: Text('数学'),),
    DropdownMenuItem(value: 2, child: Text('英语'),),
  ];

  Object? _dropValue = 0;

  _buildDropdownButton() {
    return DropdownButton(
      disabledHint:Text("Disabled"),
      elevation: 8,
      // style:TextStyle(color:Colors.green, fontSize: 16),
      // icon: Icon(Icons.arrow_drop_down_circle),
      hint: Text('请选择'),
      value: _dropValue,
      items: items,
      onChanged: (value){
        setState(() {
          _dropValue = value;
        });
      },
    );
  }
}