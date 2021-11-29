//
//  TableDemo.dart
//  fluttertemplet
//
//  Created by shang on 10/14/21 7:02 PM.
//  Copyright © 10/14/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:fluttertemplet/uti/screen_uti.dart';

class TableDemo extends StatefulWidget {

  final String? title;

  TableDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _TableDemoState createState() => _TableDemoState();
}

class _TableDemoState extends State<TableDemo> {




  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return
    Table(
      columnWidths: <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(80),
        2: FlexColumnWidth(80),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: Colors.green,
        width: 2,
        style: BorderStyle.solid,
      ),
      children: _renderList(),
    );
  }

  List<TableRow> _renderList() {
    List titleList = ['aaaaaaaa', 'bbbb', 'ccccccccc', 'ddd', 'ee'];
    List<TableRow> list = [];
    for (var i = 0; i < titleList.length; i++) {
      list.add(
          TableRow(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  child: Text(titleList[i]),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: Text(i % 2 == 0 ? 'content' : 'contentcontentcontentcontentcontentcontentcontentcontent'),
                )
              ]
          )
      );
    }
    return list;
  }
}
