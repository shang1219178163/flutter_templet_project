//
//  MediaQueryDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/6/23 4:13 PM.
//  Copyright © 3/6/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:tuple/tuple.dart';


class MediaQueryDemoOne extends StatefulWidget {

  const MediaQueryDemoOne({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _MediaQueryDemoOneState createState() => _MediaQueryDemoOneState();
}

class _MediaQueryDemoOneState extends State<MediaQueryDemoOne> {
  final _textcontroller  = TextEditingController();

  var labelText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            buildTable(rows: _renderTuples(items: tips)),
            Divider(),
            buildTable(rows: _renderTuples(items: items)),
          ].map((e) => e.toSliverToBoxAdapter()).toList(),
        ),
      )
    );
  }

  Widget buildTable({required List<TableRow> rows}) {
    return Table(
      columnWidths: <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(80),
        2: FlexColumnWidth(80),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: Colors.green,
        width: 1,
        style: BorderStyle.solid,
      ),
      children: rows,
    );
  }


  List<TableRow> _renderTuples({List items = const []}) {
    if (items.isEmpty || !isTuple(items[0])) {
      return [];
    }

    return items.map((e){
      final array = e.toList();

      return TableRow(
        children: List.generate(array.length, (index) => Container(
          padding: EdgeInsets.all(8),
          child: Text(array.toList()[index]),
        )).toList(),
      );
    }).toList();
  }

  final tips = [
    Tuple3("", "无键盘", "显示键盘"),
    Tuple3("viewInsets", "EdgeInsets.zero", "EdgeInsets(0.0, 0.0, 0.0, 336.0)"),
    Tuple3("viewPadding", "EdgeInsets(0.0, 47.0, 0.0, 34.0)", "EdgeInsets(0.0, 47.0, 0.0, 34.0)"),
    Tuple3("padding", "EdgeInsets(0.0, 47.0, 0.0, 34.0)", "EdgeInsets(0.0, 47.0, 0.0, 0.0)"),
  ];

  final items = [
    Tuple2("属性", "说明"),
    Tuple2("size", "逻辑像素，并不是物理像素，类似于Android中的dp，逻辑像素会在不同大小的手机上显示的大小基本一样，物理像素 = size*devicePixelRatio。"),
    Tuple2("devicePixelRatio", "单位逻辑像素的物理像素数量，即设备像素比。"),
    Tuple2("textScaleFactor", "单位逻辑像素字体像素数，如果设置为1.5则比指定的字体大50%。"),
  ];

}

bool isTuple(dynamic obj) {
  return obj is Tuple2 || obj is Tuple3 || obj is Tuple4 || obj is Tuple5 || obj is Tuple6 || obj is Tuple7;
}
