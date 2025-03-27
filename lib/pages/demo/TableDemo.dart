//
//  TableDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/14/21 7:02 PM.
//  Copyright © 10/14/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class TableDemo extends StatefulWidget {
  final String? title;

  const TableDemo({Key? key, this.title}) : super(key: key);

  @override
  _TableDemoState createState() => _TableDemoState();
}

class _TableDemoState extends State<TableDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Table(
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
    var titles = ['a', 'b' * 2, 'c' * 4, 'd' * 8, 'e' * 16];

    return titles
        .map((e) => TableRow(children: [
              Container(
                padding: EdgeInsets.all(8),
                child: Text(e),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(titles.indexOf(e) % 2 == 0 ? 'content' : 'content' * 13),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(titles.indexOf(e) % 2 == 0 ? 'three' : 'three' * 13),
              ),
            ]))
        .toList();
  }
}
