//
//  ExpandIconDemo.dart
//  fluttertemplet
//
//  Created by shang on 7/16/21 10:03 AM.
//  Copyright © 7/16/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertemplet/dartExpand/ddlog.dart';
import 'package:fluttertemplet/dartExpand/color_extension.dart';

import 'package:tuple/tuple.dart';

class ExpandIconDemo extends StatefulWidget {

  final String? title;

  ExpandIconDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ExpandIconDemoState createState() => _ExpandIconDemoState();
}

class _ExpandIconDemoState extends State<ExpandIconDemo> {

  late bool _isExpanded = false;

  List<Color> colors = [
    Colors.black,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Column(
        children: [
          buildExpandIconColors(context),
        ],
      ),
    );
  }

  var chooseColor = Colors.black;

  Widget buildExpandIconColors(BuildContext context) {
    return
    ExpansionTile(
      leading: Icon(Icons.color_lens, color: chooseColor,),
      title: Text('颜色主题', style: TextStyle(color: chooseColor),),
      initiallyExpanded: false,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((e) {
              return InkWell(
                onTap: () {
                  setState(() {
                    chooseColor = e;
                  });
                  ddlog(e.nameDes,);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  color: e,
                  child: chooseColor == e ? Icon(Icons.done, color: Colors.white,) : null,
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}

