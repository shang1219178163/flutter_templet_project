//
//  IndexedStackDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/28/21 5:46 PM.
//  Copyright © 10/28/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class IndexedStackDemo extends StatefulWidget {
  final String? title;

  const IndexedStackDemo({Key? key, this.title}) : super(key: key);

  @override
  _IndexedStackDemoState createState() => _IndexedStackDemoState();
}

class _IndexedStackDemoState extends State<IndexedStackDemo> {
  final _scrollController = ScrollController();

  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (selectedIndex < 2) {
              selectedIndex++;
            } else {
              selectedIndex = 0;
            }
          });
        },
        child: Text("Next"),
      ),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("IndexedStack 开始就会初始化所有子视图"),
            buildIndexedStack(),
          ],
        ),
      ),
    );
  }

  Widget buildIndexedStack() {
    final items = [
      Colors.green,
      Colors.red,
      Colors.yellow,
    ];
    return IndexedStack(
      alignment: Alignment.center,
      index: selectedIndex,
      children: items.map((e) {
        final index = items.indexOf(e);

        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          DLog.d("$widget, index $index");

          return Container(
            width: 200,
            height: 200,
            color: e,
            alignment: Alignment.center,
            child: Text(index.toString()),
          );
        });
      }).toList(),
    );
  }
}
